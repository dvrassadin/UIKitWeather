//
//  WeatherViewModel.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 12/5/25.
//

import CoreLocation

final class WeatherViewModel: WeatherViewModelProtocol {
    
    // MARK: Properties
    
    var viewState: ((WeatherViewState) -> Void)?
    
    // MARK: Servicies
    
    private let locationService: LocationServiceProtocol
    private let networkService: NetworkServiceProtocol
    
    // MARK: Initialization
    
    init(locationService: LocationServiceProtocol, networkService: NetworkServiceProtocol) {
        self.locationService = locationService
        self.networkService = networkService
    }
    
    // MARK: Public Methods
    
    func viewDidLoad() {
        locationService.requestAuthorizationIfNeeded()
        fetchWeatherData()
    }
    
    func retryFetchWeather() {
        fetchWeatherData()
    }
    
    // MARK: Private Methods
    
    private func fetchWeatherData() {
        viewState?(.loading)
        locationService.requestCurrentLocation { [weak self] location in
            if let location {
                self?.fetchWeather(for: location.coordinate)
            } else {
                let moscowCoordinates = CLLocationCoordinate2D(
                    latitude: 55.75866,
                    longitude: 37.61929
                )
                self?.fetchWeather(for: moscowCoordinates)
            }
        }
    }
    
    private func fetchWeather(for coordinates: CLLocationCoordinate2D) {
        Task {
            do {
                let weatherForecast = try await NetworkService.shared.getWeatherForecast(
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                    days: 5
                )
                let currentWeather = mapToCurrentWeather(from: weatherForecast)
                let hourlyWeather = mapToHourlyWeather(from: weatherForecast)
                let dailyWeather = mapToDailyWeather(from: weatherForecast)
                viewState?(
                    .loaded(current: currentWeather, hourly: hourlyWeather, daily: dailyWeather)
                )
            } catch {
                viewState?(.error(message: error.localizedDescription))
            }
        }
    }
    
    // MARK: Mapping Functions
    
    private func mapToCurrentWeather(from response: APIWeatherForecast) -> CurrentWeather {
        let highest = (response.forecast.forecastday.first?.day.maxtempC)
            .map { "\(Int(round($0)))°" }
        let lowest = (response.forecast.forecastday.first?.day.mintempC)
            .map { "\(Int(round($0)))°" }
        
        return CurrentWeather(
            locationName: response.location.name,
            temperature: "\(Int(response.current.tempC.rounded()))°",
            description: response.current.condition.text,
            minimumTemperature: highest,
            maximumTemperature: lowest
        )
    }
    
    private func mapToHourlyWeather(from response: APIWeatherForecast) -> [HourlyWeather] {
        response.forecast.forecastday
            .filter { day in
                Calendar.current.isDateInToday(day.dateEpoch) ||
                Calendar.current.isDateInTomorrow(day.dateEpoch)
            }
            .flatMap { $0.hour }
            .filter { $0.timeEpoch > .now }
            .map { hour in
                HourlyWeather(
                    hour: hour.timeEpoch.formatted(.dateTime.hour()),
                    iconURL: URL(string: "https:\(hour.condition.icon)"),
                    temperature: "\(Int(hour.tempC.rounded()))°"
                )
            }
    }
    
    private func mapToDailyWeather(from response: APIWeatherForecast) -> [DailyWeather] {
        response.forecast.forecastday.map { forecast in
            let weekday = Calendar.current.isDateInToday(forecast.dateEpoch) ?
            "Today" : forecast.dateEpoch.formatted(.dateTime.weekday(.wide))
            
            let precipitation = max(forecast.day.dailyChanceOfRain, forecast.day.dailyChanceOfSnow)
            let chance = precipitation > 0 ? "\(precipitation)%" : " "
            
            return DailyWeather(
                day: weekday,
                iconURL: URL(string: "https:\(forecast.day.condition.icon)"),
                minimumTemperature: "\(Int(forecast.day.mintempC.rounded()))°",
                maximumTemperature: "\(Int(forecast.day.maxtempC.rounded()))°",
                chanceOfPrecipitation: chance
            )
        }
    }
    
}

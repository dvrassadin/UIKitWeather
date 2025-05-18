//
//  NetworkService.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 12/5/25.
//

import OSLog

@MainActor
final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    
    // MARK: Properties
    
    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 10
        return session
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    private let baseURL: URL = {
        guard let url = URL(string: "https://api.weatherapi.com/") else {
            fatalError("Invalid base URL")
        }
        return url
    }()
    
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["WeatherAPIKey"] as? String else {
            fatalError("Unable to get API key from Config.plist")
        }
        return key    }
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "Networking"
    )
    
    // MARK: Initialization
    
    private init() {}
    
    // MARK: Get Weather Forecast
    
    func getWeatherForecast(
        latitude: Double,
        longitude: Double,
        days: Int
    ) async throws -> APIWeatherForecast {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            logger.error("Failed to create URL components from base URL")
            throw URLError(.badURL)
        }
        
        components.path = "/v1/forecast.json"
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "days", value: String(days))
        ]
        
        guard let url = components.url else {
            logger.error("Failed to create URL from components")
            throw URLError(.badURL)
        }
        
        do {
            logger.info("Starting request to \(url.absoluteString)")
            let (data, _) = try await session.data(from: url)
            
            let weatherForecast = try decoder.decode(APIWeatherForecast.self, from: data)
            logger.info("Received weather forecast for \(weatherForecast.location.name) from \(url.absoluteString)")
            
            return weatherForecast
        } catch {
            logger.error("Failed to get response from \(url.absoluteString): \(error)")
            throw error
        }
    }
    
}

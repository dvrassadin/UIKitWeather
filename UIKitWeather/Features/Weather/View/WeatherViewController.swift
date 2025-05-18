//
//  WeatherViewController.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 12/5/25.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: WeatherViewModel
    private lazy var contentView = WeatherView()
    
    private var isLoading: Bool = false {
        didSet {
            isLoading ? contentView.showLoading() : contentView.hideLoading()
        }
    }
    
    private lazy var hourlyWeatherDataSource = makeHourlyDataSource()
    
    private let hourlyWeatherCellRegistration = UICollectionView.CellRegistration<
        HourlyWeatherCollectionViewCell,
        HourlyWeather
    > { cell, _, weather in
        cell.configure(with: weather)
    }
    
    // MARK: Lifecycle
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        subscribeToNotifications()
        viewModel.viewDidLoad()
    }
    
    // MARK: Setup
    
    private func setupBindings() {
        viewModel.viewState = { [weak self] viewState in
            self?.handleViewState(viewState)
        }
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: nil,
            using: { [weak self] _ in
                Task { @MainActor in
                    self?.handleApplicationDidBecomeActive()
                }
            }
        )
    }
    
    // MARK: Update UI
    
    private func handleViewState(_ state: WeatherViewState) {
        switch state {
        case .loading:
            isLoading = true
        case .loaded(let current, let hourly, let daily):
            isLoading = false
            contentView.update(current: current, daily: daily)
            applyHourlyWeatherSnapshot(weather: hourly)
        case .error(let message):
            isLoading = false
            showError(message: message)
        }
    }
    
    private func handleApplicationDidBecomeActive() {
        guard !isLoading else { return }
        
        viewModel.retryFetchWeather()
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(
            title: String(localized: "Error"),
            message: message,
            preferredStyle: .alert
        )
        let refreshAction = UIAlertAction(
            title: String(localized: "Try again"),
            style: .default
        ) { [weak self] _ in
            guard let self, !isLoading else { return }
            
            viewModel.retryFetchWeather()
        }
        alertController.addAction(refreshAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: Hourly Weather Diffable Data Source
    
    private func makeHourlyDataSource() -> UICollectionViewDiffableDataSource<Int, HourlyWeather> {
        UICollectionViewDiffableDataSource(
            collectionView: contentView.hourlyForecastView.collectionView) {
                [weak self] collectionView, indexPath, weather in
                guard let self else { return nil }
                
                return collectionView.dequeueConfiguredReusableCell(
                    using: hourlyWeatherCellRegistration,
                    for: indexPath,
                    item: weather
                )
            }
    }
    
    private func applyHourlyWeatherSnapshot(weather: [HourlyWeather]) {
        var weatherSnapshot = NSDiffableDataSourceSnapshot<Int, HourlyWeather>()
        weatherSnapshot.appendSections([0])
        weatherSnapshot.appendItems(weather)
        hourlyWeatherDataSource.apply(weatherSnapshot)
    }

}

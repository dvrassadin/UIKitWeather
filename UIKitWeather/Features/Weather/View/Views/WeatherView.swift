//
//  WeatherView.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 17/5/25.
//

import UIKit

final class WeatherView: UIView {

    // MARK: UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .Brand.yellow
        return activityIndicator
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 80, weight: .thin)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .Brand.secondaryText
        label.textAlignment = .center
        return label
    }()
    
    private let minMaxLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()
    
    let hourlyForecastView = HourlyForecastView()
    let dailyForecastView = DailyForecastView()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        backgroundColor = .Brand.background
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(activityIndicator)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cityLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(minMaxLabel)
        contentView.addSubview(hourlyForecastView)
        contentView.addSubview(dailyForecastView)
    }
    
    private func setupConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        hourlyForecastView.translatesAutoresizingMaskIntoConstraints = false
        dailyForecastView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 4),
            temperatureLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: cityLabel.trailingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: cityLabel.trailingAnchor),
            
            minMaxLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 4),
            minMaxLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            minMaxLabel.trailingAnchor.constraint(equalTo: cityLabel.trailingAnchor),
            
            hourlyForecastView.topAnchor.constraint(equalTo: minMaxLabel.bottomAnchor, constant: 16),
            hourlyForecastView.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            hourlyForecastView.trailingAnchor.constraint(equalTo: cityLabel.trailingAnchor),
            hourlyForecastView.heightAnchor.constraint(equalToConstant: 150),

            dailyForecastView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor, constant: 8),
            dailyForecastView.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            dailyForecastView.trailingAnchor.constraint(equalTo: cityLabel.trailingAnchor),
            dailyForecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: Public Methods
    
    func showLoading() {
        activityIndicator.startAnimating()
        cityLabel.isHidden = true
        temperatureLabel.isHidden = true
        statusLabel.isHidden = true
        minMaxLabel.isHidden = true
        hourlyForecastView.isHidden = true
        dailyForecastView.isHidden = true
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func update(current: CurrentWeather, daily: [DailyWeather]) {
        cityLabel.text = current.locationName
        cityLabel.isHidden = false
        temperatureLabel.text = current.temperature
        temperatureLabel.isHidden = false
        statusLabel.text = current.description
        statusLabel.isHidden = false
        if let highest = current.maximumTemperature, let lowest = current.minimumTemperature {
            minMaxLabel.text = String(
                localized: "H:\(highest) L:\(lowest)"
            )
            minMaxLabel.isHidden = false
        }
        hourlyForecastView.isHidden = false
        dailyForecastView.update(daily: daily)
        dailyForecastView.isHidden = false
    }

}

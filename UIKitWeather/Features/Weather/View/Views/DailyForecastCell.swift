//
//  DailyForecastCell.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 18/5/25.
//

import UIKit
import Kingfisher

final class DailyForecastCell: UIView {

    // MARK: UI Components
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .Brand.secondaryText.withAlphaComponent(0.7)
        return view
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let statusImageView = UIImageView()
    
    private let chanceOfPrecipitationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .Brand.blueText
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Initialization
    
    init(daily: DailyWeather) {
        super.init(frame: .zero)
        setupUI()
        weekdayLabel.text = daily.day
        statusImageView.kf.setImage(with: daily.iconURL)
        chanceOfPrecipitationLabel.text = daily.chanceOfPrecipitation
        temperatureLabel.text = "\(daily.minimumTemperature) – \(daily.maximumTemperature)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(separatorView)
        addSubview(weekdayLabel)
        addSubview(statusImageView)
        addSubview(chanceOfPrecipitationLabel)
        addSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        chanceOfPrecipitationLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            weekdayLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 1),
            weekdayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdayLabel.widthAnchor.constraint(equalToConstant: 100),
            
            statusImageView.topAnchor.constraint(equalTo: separatorView.topAnchor, constant: 3),
            statusImageView.leadingAnchor.constraint(equalTo: weekdayLabel.trailingAnchor, constant: 8),
            statusImageView.heightAnchor.constraint(equalToConstant: 32),
            statusImageView.widthAnchor.constraint(equalTo: statusImageView.heightAnchor),
            
            chanceOfPrecipitationLabel.topAnchor.constraint(equalTo: statusImageView.bottomAnchor),
            chanceOfPrecipitationLabel.leadingAnchor.constraint(equalTo: statusImageView.leadingAnchor),
            chanceOfPrecipitationLabel.trailingAnchor.constraint(equalTo: statusImageView.trailingAnchor),
            chanceOfPrecipitationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 1),
            temperatureLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 8),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

}

//
//  HourlyWeatherCollectionViewCell.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 17/5/25.
//

import UIKit
import Kingfisher

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Components
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let statusImageView = UIImageView()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
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
        contentView.addSubview(hourLabel)
        contentView.addSubview(statusImageView)
        contentView.addSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hourLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hourLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            hourLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            statusImageView.topAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 8),
            statusImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            statusImageView.heightAnchor.constraint(equalToConstant: 32),
            statusImageView.widthAnchor.constraint(equalTo: statusImageView.heightAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: 8),
            temperatureLabel.leadingAnchor.constraint(equalTo: hourLabel.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: hourLabel.trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: Configure
    
    func configure(with weather: HourlyWeather) {
        hourLabel.text = weather.hour
        statusImageView.kf.setImage(with: weather.iconURL)
        temperatureLabel.text = weather.temperature
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hourLabel.text = nil
        statusImageView.image = nil
        temperatureLabel.text = nil
    }

}

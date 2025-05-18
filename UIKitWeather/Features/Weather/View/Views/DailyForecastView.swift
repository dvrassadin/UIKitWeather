//
//  DailyForecastView.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 18/5/25.
//

import UIKit

final class DailyForecastView: UIView {

    // MARK: UI Components
    
    private let imageView = UIImageView(
        image: UIImage(
            systemName: "calendar"
        )?.withTintColor(.Brand.secondaryText, renderingMode: .alwaysOriginal)
    )
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .Brand.secondaryText
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return stackView
    }()
    
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
        backgroundColor = .Brand.widget
        layer.cornerRadius = 16
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: Public Methods
    
    func update(daily: [DailyWeather]) {
        titleLabel.text = String(localized: "\(daily.count)-DAY FORECAST")
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        daily.forEach { weather in
            stackView.addArrangedSubview(DailyForecastCell(daily: weather))
        }
    }
    
}

//
//  WeatherViewModelProtocol.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 13/5/25.
//

import Foundation

@MainActor
protocol WeatherViewModelProtocol {
    var viewState: ((WeatherViewState) -> Void)? { get set }
    
    func viewDidLoad()
    func retryFetchWeather()
}

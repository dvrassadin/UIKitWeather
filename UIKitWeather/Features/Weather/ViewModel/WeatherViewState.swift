//
//  WeatherViewState.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 17/5/25.
//

import Foundation

enum WeatherViewState {
    case loading
    case loaded(current: CurrentWeather, hourly: [HourlyWeather], daily: [DailyWeather])
    case error(message: String)
}

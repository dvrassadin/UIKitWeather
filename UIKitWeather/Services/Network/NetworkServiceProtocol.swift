//
//  NetworkServiceProtocol.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 12/5/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func getWeatherForecast(
        latitude: Double,
        longitude: Double,
        days: Int
    ) async throws -> APIWeatherForecast
}

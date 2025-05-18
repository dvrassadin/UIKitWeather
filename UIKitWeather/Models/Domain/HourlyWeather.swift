//
//  HourlyWeather.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 17/5/25.
//

import Foundation

struct HourlyWeather: Hashable {
    let hour: String
    let iconURL: URL?
    let temperature: String
}

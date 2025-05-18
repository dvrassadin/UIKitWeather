//
//  APIWeatherForecast.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 13/5/25.
//

import Foundation

struct APIWeatherForecast: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast
    
    struct Location: Decodable {
        let name: String
    }
    
    struct Current: Decodable {
        let tempC: Double
        let condition: Condition
        
        struct Condition: Decodable {
            let text: String
            let icon: String
        }
    }
    
    struct Forecast: Decodable {
        let forecastday: [Forecastday]
        
        struct Forecastday: Decodable {
            let dateEpoch: Date
            let day: Day
            let hour: [Hour]
            
            struct Day: Decodable {
                let maxtempC: Double
                let mintempC: Double
                let condition: Condition
                let dailyChanceOfRain: Int
                let dailyChanceOfSnow: Int
                
                struct Condition: Decodable {
                    let icon: String
                }
            }
            
            struct Hour:Decodable {
                let timeEpoch: Date
                let tempC: Double
                let condition: Condition
                
                struct Condition: Decodable {
                    let icon: String
                }
            }
        }
    }
    
}

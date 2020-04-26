//
//  WeatherData.swift
//  Clima
//
//  Created by Alex on 26.04.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let main: String
    let id: Int
    let icon: String
    
}

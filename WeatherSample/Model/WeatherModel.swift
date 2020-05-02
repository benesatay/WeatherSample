//
//  WeatherInformation.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

protocol BaseMain {
    var temp: Double? { get }
    var feels_like: Double? { get }
    var temp_min: Double? { get }
    var temp_max: Double? { get }
    var pressure: Int? { get }
    var humidity: Int?  { get }
    var sea_level: Double? { get }
    var grnd_level: Double? { get }
}

struct CurrentWeatherModel: Codable {
    let coord: Coord?
    let weather: [Weather?]
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    var name: String?
    let cod: Int?
}

struct Clouds: Codable {
    let all: Int?
}

struct Coord: Codable {
    let lon: Double?
    let lat: Double?
}

struct Main: Codable, BaseMain {
    var temp: Double?
    
    var feels_like: Double?
    
    var temp_min: Double?
    
    var temp_max: Double?
    
    var pressure: Int?
    
    var humidity: Int?
    
    var sea_level: Double?
    
    var grnd_level: Double?
        
}

struct Sys: Codable {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?
    
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}


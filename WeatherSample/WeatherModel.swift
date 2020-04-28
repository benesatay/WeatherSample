//
//  WeatherInformation.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

import Foundation

struct WeatherModel: Codable {
    var coord: Coord
    var weather: [Weather]
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var clouds: Clouds
    var dt: Int
    var sys: Sys
    var timezone, id: Int
    var name: String
    var cod: Int
        
}

struct Clouds: Codable {
    var all: Int
}

struct Coord: Codable {
    var lon: Double
    var lat: Double
}

struct Main: Codable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Int?
    var humidity: Int?
}

struct Sys: Codable {
    var type, id: Int
    var message: Double
    var country: String
    var sunrise, sunset: Int
}

struct Weather: Codable {
    var id: Int
    var main: String
    var weatherDescription: String
    var icon: String
}

struct Wind: Codable {
    var speed: Double
    var deg: Int
}


//struct coord {
//    var lon: Int?
//    var lat: Int?
//}
//
//struct weather {
//
//    var id: Int?
//    var main: String!
//    var description: String!
//    var icon: UIImage?
//}
//
//struct main : Decodable {
//    var temp: Double?
//    var feels_like: Int?
//    var temp_min: Int?
//    var temp_max: Int?
//    var pressure: Int?
//    var humidity: Int?
//}
//
//var visibility: Int?
//struct wind {
//    var speed: Int?
//    var deg: Int?
//}
//
//struct clouds {
//    var all: Int?
//}
//
//var dt: Int?
//struct sys {
//    var type: Int?
//    var id: Int?
//    var message: Int?
//    var country: String!
//    var sunrise: Int?
//    var sunset: Int?
//}
//
//var timezone: Int?
//var id: Int?
//var name: String?
//var cod: Int?
//

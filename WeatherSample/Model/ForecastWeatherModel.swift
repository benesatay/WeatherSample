//
//  NextWeatherModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 30.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

struct ForecastWeatherModel: Codable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let list: [List]?
    let city: City?
}

struct List: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let sys: NextSys?
    let dt_txt: String?
    let rain: Rain?
}

struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}

struct Rain: Codable {
    let the3h: Double?
    enum CodingKeys: String, CodingKey {
        case the3h = "3h"
    }
}

struct NextSys: Codable {
    let pod: String?
}

struct ForecastMain: Codable, BaseMain {
    var temp: Double?
    
    var feels_like: Double?
    
    var temp_min: Double?
    
    var temp_max: Double?
    
    var pressure: Int?
    
    var humidity: Int?
    
    var sea_level: Double?
    
    var grnd_level: Double?
    
    var temp_kf: Double?
    

}

//struct NextWeather: Codable {
//    let id: Int?
//    let main: String?
//    let description: String?
//    let icon: String?
//}

//struct NextCoord: Codable {
//    let lat: Double?
//    let lon: Double?
//}

//struct NextClouds: Codable {
//    let all: Int?
//}


//struct NextWind: Codable {
//    let speed: Double?
//    let deg: Int?
//}

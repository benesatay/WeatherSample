//
//  WeatherInformation.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

struct City {
    var city: String?
}

struct Weather {
    var main: String!
    var description: String!
    //var icon: UIImage
}

struct Temperature {
    var temp: String?
    var feels_like: String?
    var temp_min: String?
    var temp_max: String?
}

struct OtherTempDetails {
    var pressure: String?
    var humidirty: Int?
    var visibility: Int?
}

struct Wind {
    var speed: Int?
    var deg: Int?
}

struct Clouds {
    var all: Int?
}

struct SunTime {
    var sunrise: Int?
    var sunset: Int?
}



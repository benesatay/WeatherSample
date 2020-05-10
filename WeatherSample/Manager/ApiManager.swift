//
//  ApiManager.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import Foundation

let apikey: String = "&APPID=52fac2e571e411a42fedbe9676d8824c"
let unit: String = "&units=metric"
let lang: String = "&lang=tr"
let currentWeatherBaseURL: String = "http://api.openweathermap.org/data/2.5/weather?q="
//let currentWeatherBaseURL: String = "http://api.openweathermap.org/data/2.5/weather?q=İzmir"
let nextWeatherBaseURL: String = "http://api.openweathermap.org/data/2.5/forecast?q="

//let nextWeatherBaseURL: String = "http://api.openweathermap.org/data/2.5/forecast?q=İzmir"
let iconBaseURL: String = "http://openweathermap.org/img/wn/"
class ApiManager {
    static let shared = ApiManager()
}

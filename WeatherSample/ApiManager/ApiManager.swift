//
//  ApiManager.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import Foundation

let baseURL: String = "http://api.openweathermap.org/data/2.5/weather?q=İzmir&"
let iconBaseURL: String = "http://openweathermap.org/img/wn/"
class ApiManager {
    static let shared = ApiManager()
}

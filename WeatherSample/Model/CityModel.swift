//
//  CityModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 2.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import Foundation

struct TRCityModel: Codable {
    let trcitylist: [Trcitylist]?
}

struct Trcitylist: Codable {
    let id: Int?
    let name, state: String?
    let country: String?
    let coord: Coord?
}


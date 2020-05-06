//
//  GetForecastWeatherTime.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 30.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension Int {
    func getForecastDate(with format: String) -> String {
        let nextTempTime = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: nextTempTime)
    }
}

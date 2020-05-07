//
//  Double+Extensions.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 6.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension Double {
    func convertToFahrenheit(with celcius: Double) -> Double {
        return (celcius * 1.8) + 32.0
    }
}

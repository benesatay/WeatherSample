//
//  String+Extensions.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 5.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension Date {
    
    func setDate(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.string(from: Date())
        return date
    }
}

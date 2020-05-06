//
//  ForecastTempCollectionViewCell.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 4.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class ForecastTempCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var forecastWeatherTempLabel: UILabel!
    @IBOutlet weak var forecastWeatherImageView: UIImageView!
    @IBOutlet weak var forecastWeatherTimeLabel: UILabel!
    @IBOutlet weak var forecastRainVolumeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

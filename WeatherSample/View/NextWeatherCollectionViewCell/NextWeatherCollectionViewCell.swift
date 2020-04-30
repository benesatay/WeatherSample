//
//  NextWeatherCollectionViewCell.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class NextWeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nextTempLabel: UILabel!
    @IBOutlet weak var nextTempIcon: UIImageView!
    @IBOutlet weak var nextTempTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

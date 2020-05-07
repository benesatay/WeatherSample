//
//  WindCollectionViewCell.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 26.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class ForecastWindCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var windDegImage: UIImageView!
    @IBOutlet weak var windDegLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

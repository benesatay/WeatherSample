//
//  GradientColor.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension UIView {
    
    func createGradientLayer(color1: UIColor, color2: UIColor) -> CAGradientLayer {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}

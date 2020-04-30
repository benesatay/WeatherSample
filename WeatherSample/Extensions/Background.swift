//
//  GradientColor.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension UIView {
    func createGradientLayer(color1: UIColor, color2: UIColor, x: Int, y: Int, width: Int, height: Int) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: x, y: y, width: width, height: height)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setBackgroundImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))
        let image = UIImage(named: "afternoon")
        imageView.image = image
        self.addSubview(imageView)
        self.sendSubviewToBack(imageView)
    }
}

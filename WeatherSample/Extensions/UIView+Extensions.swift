//
//  GradientColor.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension UIView {
    func createGradientLayer(startColor: UIColor, endColor: UIColor, width: Int, height: Int) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setBackground(with name: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))
        let image = UIImage(named: name)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        self.sendSubviewToBack(imageView)
    }
}

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
    
//    func createGradientLayer(startColor: UIColor, endColor: UIColor, xStartpoint: Double, yStartpoint: Double, xEndpoint: Double, yEndpoint: Double, width: Int, height: Int) {
//        //       view.createGradientLayer(startColor:, endColor:, xStartpoint: 0.0, yStartpoint: 0.5, xEndpoint: 0.75, yEndpoint: 0.5, width:, height:) // horizontal
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
//        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//        gradientLayer.startPoint = CGPoint(x: xStartpoint, y: yStartpoint)
//        gradientLayer.endPoint = CGPoint(x: xEndpoint, y: yEndpoint )
//        self.layer.insertSublayer(gradientLayer, at: 0)
//    }

}

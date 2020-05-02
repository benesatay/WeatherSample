//
//  GradientColor.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension UIView {
    func createGradientLayer(startColor: UIColor, middleColor: UIColor, endColor: UIColor, xStartpoint: Double, yStartpoint: Double, xEndpoint: Double, yEndpoint: Double, width: Int, height: Int) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: xStartpoint, y: yStartpoint)
        gradientLayer.endPoint = CGPoint(x: xEndpoint, y: yEndpoint )
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setBackgroundImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))
        let image = UIImage(named: "afternoon")
        imageView.image = image
        self.addSubview(imageView)
        self.sendSubviewToBack(imageView)
    }
    
    func instanceFromNib(nib: String) -> UIView {
        return UINib(nibName: nib, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView

    }
}

//
//  SetupSubviews.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 7.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class SetupSubviews {
    func setSubview(with nib: UIViewController, with view: UIView, viewFrame: CGRect) {
        nib.view.frame = viewFrame
        view.addSubview(nib.view)
    }
    
    //MARK: CurrentWeatherViewController
    func setCurrentWeatherSubview(with vc: WeatherViewController, with view: UIView) {
        let destination = CurrentWeatherViewController(nibName: "CurrentWeatherViewController", bundle: nil)
        vc.setBackgroundImage(with: destination)
        vc.setBackgroundColor(with: destination,
                              dayStartColor: .cyan,
                              dayEndColor: .systemTeal,
                              nightStartColor: .clear,
                              nightEndColor: .clear,
                              height: 500)
        
        vc.setSegmentedControllSubview(with: destination)
        let viewFrame = CGRect(x: 0, y: 10, width: view.bounds.width, height: 500)
        setSubview(with: destination, with: view, viewFrame: viewFrame)
    }
    
    //MARK: CurrentWeatherDetailViewController
    func setCurrentWeatherDetailSubview(with vc: WeatherViewController, with view: UIView) {
        let destination = CurrentWeatherDetailsViewController(nibName: "CurrentWeatherDetailsViewController", bundle: nil)
        
        vc.setBackgroundColor(with: destination,
                              dayStartColor: .systemTeal,
                              dayEndColor: .systemPurple,
                              nightStartColor: .black,
                              nightEndColor: UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0),
                              height: 185)
        
        let viewFrame = CGRect(x: 0, y: 510, width: view.bounds.width, height: 185)
        setSubview(with: destination, with: view, viewFrame: viewFrame)
    }
    
    //MARK: ForecastTempViewController
    func setForecastTempSubview(with vc: WeatherViewController, with view: UIView) {
        let destination = ForecastTempViewController(nibName: "ForecastTempViewController", bundle: nil)
        vc.setBackgroundColor(with: destination,
                              dayStartColor: .systemPurple,
                              dayEndColor: UIColor(red: 137/255, green: 68/255, blue: 171/255, alpha: 1.0),
                              nightStartColor: UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0), //systemIndigo
            nightEndColor: .systemPurple,
            height: 161)
        let viewFrame = CGRect(x: 0, y: 695, width: view.bounds.width, height: 161)
        setSubview(with: destination, with: view ,viewFrame: viewFrame)
        vc.addChild(destination)
    }
    
    //MARK: ForecastWindViewController
    func setForecastWindSubview(with vc: WeatherViewController, with view: UIView) {
        let destination = ForecastWindViewController(nibName: "ForecastWindViewController", bundle: nil)
        vc.setBackgroundColor(with: destination,
                              dayStartColor: UIColor(red: 137/255, green: 68/255, blue: 171/255, alpha: 1.0),
                              dayEndColor: UIColor(red: 125/255, green: 122/255, blue: 255/255, alpha: 1.0),
                              nightStartColor: .systemPurple,
                              nightEndColor: .systemTeal,
                              height: 256)
        let viewFrame = CGRect(x: 0, y: 856, width: view.bounds.width, height: 256)
        setSubview(with: destination, with: view, viewFrame: viewFrame)
        vc.addChild(destination)
    }
    
    //MARK: SunTimeViewController
    func setSunTimeSubview(with vc: WeatherViewController, with view: UIView) {
        let destination = SunTimeViewController(nibName: "SunTimeViewController", bundle: nil)
        vc.setBackgroundColor(with: destination,
                              dayStartColor: UIColor(red: 125/255, green: 122/255, blue: 255/255, alpha: 1.0),
                              dayEndColor: UIColor(red: 54/255, green: 52/255, blue: 163/255, alpha: 1.0),
                              nightStartColor: .systemTeal,
                              nightEndColor: .white,
                              height: 310)
        let viewFrame = CGRect(x: 0, y: 1112, width: view.bounds.width, height: 140)
        setSubview(with: destination, with: view, viewFrame: viewFrame)
        vc.addChild(destination)
    }
}

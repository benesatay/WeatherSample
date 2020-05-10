//
//  SetupSubviews.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 7.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

extension WeatherViewController {
    func setSubview(with nib: UIViewController, with view: UIView, viewFrame: CGRect) {
        nib.view.frame = viewFrame
        view.addSubview(nib.view)
    }

    //MARK: CurrentWeatherViewController
    func setCurrentWeatherSubview(with view: UIView) {
        let destination = CurrentWeatherViewController(nibName: "CurrentWeatherViewController", bundle: nil)
        setBackgroundImage(with: destination)
        setBackgroundColor(with: destination,
                              dayStartColor: .cyan,
                              dayEndColor: .systemTeal,
                              nightStartColor: .clear,
                              nightEndColor: .clear,
                              height: 500)
        
        setSegmentedControllSubview(with: destination)
        let viewFrame = CGRect(x: 0, y: 10, width: view.bounds.width, height: 500)
        setSubview(with: destination, with: view, viewFrame: viewFrame)
        startPoint = (destination.view.frame.size.height) + (destination.view.frame.origin.y)
    }
    
    //MARK: CurrentWeatherDetailViewController
    func setCurrentWeatherDetailSubview(with view: UIView) {
        let destination = CurrentWeatherDetailsViewController(nibName: "CurrentWeatherDetailsViewController", bundle: nil)
        setBackgroundColor(with: destination,
                              dayStartColor: .systemTeal,
                              dayEndColor: .systemPurple,
                              nightStartColor: .black,
                              nightEndColor: UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0),
                              height: 185)
        let viewFrame = CGRect(x: 0, y: startPoint, width: view.bounds.width, height: 185)

        setSubview(with: destination, with: view, viewFrame: viewFrame)
        self.startPoint = (destination.view.frame.size.height) + (destination.view.frame.origin.y)
    }
    
    //MARK: ForecastTempViewController
    func setForecastTempSubview(with view: UIView) {
        let destination = ForecastTempViewController(nibName: "ForecastTempViewController", bundle: nil)
        setBackgroundColor(with: destination,
                              dayStartColor: .systemPurple,
                              dayEndColor: UIColor(red: 137/255, green: 68/255, blue: 171/255, alpha: 1.0),
                              nightStartColor: UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0), //systemIndigo
            nightEndColor: .systemPurple,
            height: 161)
        let viewFrame = CGRect(x: 0, y: startPoint, width: view.bounds.width, height: 161)
        setSubview(with: destination, with: view ,viewFrame: viewFrame)
        self.startPoint = (destination.view.frame.size.height) + (destination.view.frame.origin.y)
        addChild(destination)
    }
    
    //MARK: ForecastWindViewController
    func setForecastWindSubview( with view: UIView) {
        let destination = ForecastWindViewController(nibName: "ForecastWindViewController", bundle: nil)
        setBackgroundColor(with: destination,
                              dayStartColor: UIColor(red: 137/255, green: 68/255, blue: 171/255, alpha: 1.0),
                              dayEndColor: UIColor(red: 125/255, green: 122/255, blue: 255/255, alpha: 1.0),
                              nightStartColor: .systemPurple,
                              nightEndColor: .systemTeal,
                              height: 256)
        let viewFrame = CGRect(x: 0, y: startPoint, width: view.bounds.width, height: 256)
        setSubview(with: destination, with: view, viewFrame: viewFrame)
        self.startPoint = (destination.view.frame.size.height) + (destination.view.frame.origin.y)
        addChild(destination)
    }
    
    //MARK: SunTimeViewController
    func setSunTimeSubview(with view: UIView) {
        let destination = SunTimeViewController(nibName: "SunTimeViewController", bundle: nil)
        setBackgroundColor(with: destination,
                              dayStartColor: UIColor(red: 125/255, green: 122/255, blue: 255/255, alpha: 1.0),
                              dayEndColor: UIColor(red: 54/255, green: 52/255, blue: 163/255, alpha: 1.0),
                              nightStartColor: .systemTeal,
                              nightEndColor: .white,
                              height: 310)
        let viewFrame = CGRect(x: 0, y: startPoint, width: view.bounds.width, height: 140)
        setSubview(with: destination, with: view, viewFrame: viewFrame)
        self.startPoint = (destination.view.frame.size.height) + (destination.view.frame.origin.y)
        addChild(destination)
    }
}

extension WeatherViewController {
    //MARK: Setup Background
    func setBackgroundColor(with destination: UIViewController, dayStartColor: UIColor, dayEndColor: UIColor, nightStartColor: UIColor, nightEndColor: UIColor, height: Int) {
        setTimeForBackground(completionHandler: {(currentDate, sunriseString, sunsetString) in
            if let currentTime = Int(currentDate), currentTime >= Int(sunriseString) ?? 0 && currentTime < Int(sunsetString) ?? 0 {
                destination.view.createGradientLayer(startColor: dayStartColor, endColor: dayEndColor, width: Int(UIScreen.main.bounds.width), height: height)
            } else {
                destination.view.createGradientLayer(startColor: nightStartColor, endColor: nightEndColor, width: Int(UIScreen.main.bounds.width), height: height)
                UILabel.appearance().textColor = .white
                self.navigationController?.navigationBar.barStyle = .black

            }
        })
    }
    
    func setBackgroundImage(with destination: UIViewController) {
        setTimeForBackground(completionHandler: { (currentDate, sunriseString, sunsetString) in
            if let currentTime = Int(currentDate), currentTime >= Int(sunriseString) ?? 0 && currentTime < Int(sunsetString) ?? 0 {
                destination.view.setBackground(with: "newdaymoon")
            } else {
                destination.view.setBackground(with: "bloodmoon")
            }
        })
    }
    
    func setTimeForBackground(completionHandler: @escaping (String, String, String) -> Void) {
        guard let sunrise = weatherWiewModel.currentWeatherData?.sys?.sunrise else { return }
        guard let sunset = weatherWiewModel.currentWeatherData?.sys?.sunset else { return }
        let sunriseString = sunrise.getForecastDate(with: "HHmm")
        let sunsetString = sunset.getForecastDate(with: "HHmm")
        let currentDate = Date().setDate(with: "HHmm")
        completionHandler(currentDate, sunriseString, sunsetString)
    }
}

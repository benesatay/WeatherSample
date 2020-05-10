//
//  CurrentWeatherViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    let selectedUnitData = UnitViewModel()
    
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    @IBOutlet weak var feelslikeLabel: UILabel!
    @IBOutlet weak var currentTempMaxLabel: UILabel!
    @IBOutlet weak var currentTempMinLabel: UILabel!
    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCurrentWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.setupWeatherMainData()
                self.setupWeatherData()
            }
        })
    }
    
    func setupWeatherMainData() {
        self.selectedUnitData.getUnitCoreData(compHandler: {
            DispatchQueue.main.async {
                if !self.selectedUnitData.selectedUnitSegmentIndexArray.isEmpty {
                    switch self.selectedUnitData.selectedUnitSegmentIndexArray[0] {
                    case 0:
                        self.getAsCelcius(onSuccess: { (temp, feels_like, temp_max, temp_min) in
                            self.currentTemperatureLabel.text = String(format:"%.0f", temp).appending("°")
                            self.feelslikeLabel.text = "Feels like " + String(format:"%.0f", feels_like).appending("°")
                            self.currentTempMaxLabel.text = "Max " + String(format:"%.0f", temp_max).appending("°")
                            self.currentTempMinLabel.text = "Min " + String(format:"%.0f", temp_min).appending("°")
                        })
                    case 1:
                        self.getAsFahrenheit(onSuccess: { (temp, feels_like, temp_max, temp_min) in
                            self.currentTemperatureLabel.text = String(format:"%.0f", temp).appending("°")
                            self.feelslikeLabel.text = "Feels like " + String(format:"%.0f", feels_like).appending("°")
                            self.currentTempMaxLabel.text = "Max " + String(format:"%.0f", temp_max).appending("°")
                            self.currentTempMinLabel.text = "Min " + String(format:"%.0f", temp_min).appending("°")
                        })
                    default:
                        break
                    }
                } else {
                    self.getAsCelcius(onSuccess: { (temp, feels_like, temp_max, temp_min) in
                        self.currentTemperatureLabel.text = String(format:"%.0f", temp).appending("°")
                        self.feelslikeLabel.text = "Feels like " + String(format:"%.0f", feels_like).appending("°")
                        self.currentTempMaxLabel.text = "Max " + String(format:"%.0f", temp_max).appending("°")
                        self.currentTempMinLabel.text = "Min " + String(format:"%.0f", temp_min).appending("°")
                    })
                }
            }
        })
    }
    
    func setupWeatherData() {
        let currentDate = Date().setDate(with: "dd/MM E")
        self.currentDayLabel.text = currentDate
        let currentTime = Date().setDate(with: "HH:mm")
        self.currentTimeLabel.text = currentTime
        self.cityNameLabel.text = viewModel.currentWeatherData?.name!
        
        guard let windSpeed = viewModel.currentWeatherData?.wind?.speed else { return }
        self.windSpeedLabel.text = String(format: "%.2f", windSpeed)
        
        let windDeg = viewModel.currentWeatherData?.wind?.deg
        UIView.animate(withDuration: 0.3, animations: {
            self.windImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double(windDeg ?? 0) * Double.pi / 180.0))
        })
        
        let weather = viewModel.currentWeatherData?.weather
        let description = weather?[0]?.description
        viewModel.downloadCurrentWeatherIcon(completionHandler: { imageView in
            DispatchQueue.main.async {
                self.weatherIconImageView.image = imageView
                self.descriptionLabel.text = description
            }
        })
    }
}

extension CurrentWeatherViewController {
    func getAsCelcius(onSuccess: @escaping (Double, Double, Double, Double) -> Void) {
        let main = viewModel.currentWeatherData?.main
        guard let temp = main?.temp else { return }
        guard let feels_like = main?.feels_like else { return }
        guard let temp_max = main?.temp_max else { return }
        guard let temp_min = main?.temp_min else { return }
        onSuccess(temp, feels_like, temp_max, temp_min)
    }
    
    func getAsFahrenheit(onSuccess: @escaping (Double, Double, Double, Double) -> Void) {
        var fahrenheitTemp: Double = 0.0
        var fahrenheitFeels_like: Double = 0.0
        var fahrenheitTemp_max: Double = 0.0
        var fahrenheitTemp_min: Double = 0.0
        getAsCelcius(onSuccess: { (temperature, feelsLike, maxTemperature, minTemperature) in
            fahrenheitTemp = fahrenheitTemp.convertToFahrenheit(with: temperature)
            fahrenheitFeels_like = fahrenheitFeels_like.convertToFahrenheit(with: feelsLike)
            fahrenheitTemp_max = fahrenheitTemp_max.convertToFahrenheit(with: maxTemperature)
            fahrenheitTemp_min = fahrenheitTemp_min.convertToFahrenheit(with: minTemperature)
            onSuccess(fahrenheitTemp, fahrenheitFeels_like, fahrenheitTemp_max, fahrenheitTemp_min)
        })
    }
}

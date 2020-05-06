//
//  CurrentWeatherViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    var viewModel = WeatherViewModel()
    
    var segmentIndex: Int?
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    @IBOutlet weak var feelslikeLabel: UILabel!
    @IBOutlet weak var currentTempMaxLabel: UILabel!
    @IBOutlet weak var currentTempMinLabel: UILabel!
    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel.getCurrentWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.viewModel.getUnitCoreData(compHandler: {
                    DispatchQueue.main.async {
                        print(self.viewModel.selectedUnitArray[0])
                        if !self.viewModel.selectedUnitArray.isEmpty {
                            self.segmentIndex = self.viewModel.selectedUnitArray[0]
                        } else {
                            self.segmentIndex = 0
                        }
                        
                        if self.segmentIndex == 0 {
                            self.getAsCelcius()
                        } else {
                            self.getAsFahrenheit()
                        }
                        self.setWeather()
                    }
                })
            }
        })
    }
    
    @objc func getAsCelcius() {
        setupWeatherMain(onSuccess: {(temperature, feelsLike, maxTemperature, minTemperature) in
            self.fillLabels(temp: temperature, feels_like: feelsLike, temp_max: maxTemperature, temp_min: minTemperature)
        })
    }
    
    @objc func getAsFahrenheit() {
        let f_Temperature: Double = 0.0
        let f_FeelsLike: Double = 0.0
        let f_MaxTemperature: Double = 0.0
        let f_MinTemperature: Double = 0.0
        setupWeatherMain(onSuccess: { (temperature, feelsLike, maxTemperature, minTemperature) in
            let fahrenheitTemp = f_Temperature.convertToFahrenheit(with: temperature)
            let fahrenheitFeels_like = f_FeelsLike.convertToFahrenheit(with: feelsLike)
            let fahrenheitTemp_max = f_MaxTemperature.convertToFahrenheit(with: maxTemperature)
            let fahrenheitTemp_min = f_MinTemperature.convertToFahrenheit(with: minTemperature)
            self.fillLabels(temp: fahrenheitTemp, feels_like: fahrenheitFeels_like, temp_max: fahrenheitTemp_max, temp_min: fahrenheitTemp_min)
        })
    }
    
    func fillLabels(temp: Double, feels_like: Double, temp_max: Double, temp_min: Double) {
        self.currentTemperatureLabel.text = String(format:"%.0f", temp).appending("°C")
        self.feelslikeLabel.text = "Feels like " + String(format:"%.0f", feels_like).appending("°")
        self.currentTempMaxLabel.text = "Max " + String(format:"%.0f", temp_max).appending("°")
        self.currentTempMinLabel.text = "Min " + String(format:"%.0f", temp_min).appending("°")
        let currentDate = Date().setDate(with: "dd/MM E")
        self.currentDayLabel.text = currentDate
        let currentTime = Date().setDate(with: "HH:mm")
        self.currentTimeLabel.text = currentTime
        self.cityNameLabel.text = viewModel.currentWeatherData?.name!
    }
    
    
    
    func setWeather() {
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
    func setupWeatherMain(onSuccess: @escaping (Double, Double, Double, Double) -> Void) {
        let main = viewModel.currentWeatherData?.main
        guard let temp = main?.temp else { return }
        guard let feels_like = main?.feels_like else { return }
        guard let temp_max = main?.temp_max else { return }
        guard let temp_min = main?.temp_min else { return }
        onSuccess(temp, feels_like, temp_max, temp_min)
    }
}

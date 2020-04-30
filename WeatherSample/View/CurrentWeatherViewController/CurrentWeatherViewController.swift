//
//  CurrentWeatherViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    var ViewModel = WeatherViewModel()
    //ar WeatherModel: WeatherModel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    @IBOutlet weak var feelslikeLabel: UILabel!
    @IBOutlet weak var currentTempMaxLabel: UILabel!
    @IBOutlet weak var currentTempMinLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setBackgroundImage()

        self.activityIndicator.isHidden = false
        ViewModel.getCurrentWeatherData(onSuccess: { WeatherModel in
            DispatchQueue.main.async {
                self.getMain()
                self.getWeather()
                self.activityIndicator.isHidden = true
            }
        }, onError: { error in
            print(error!.localizedDescription)
        })
    }
    
    func getMain() {
        let main = ViewModel.currentWeatherModel?.main
        
        let temp: Double = main?.temp ?? 0
        let feels_like: Double = main?.feels_like ?? 0
        let temp_max: Double = main?.temp_max ?? 0
        let temp_min: Double = main?.temp_min ?? 0

        self.currentTemperatureLabel.text = String(format:"%.0f", temp).appending("°C")
        self.feelslikeLabel.text = String(format:"%.0f", feels_like).appending("°")
        self.currentTempMaxLabel.text = String(format:"%.0f", temp_max).appending("°")
        self.currentTempMinLabel.text = String(format:"%.0f", temp_min).appending("°")
        
        self.currentDateLabel.text = self.setDate()
        self.cityNameLabel.text = ViewModel.currentWeatherModel?.name!
    }
    
    func getWeather() {
        let weather = ViewModel.currentWeatherModel?.weather
        let description = weather?[0]?.description
        ViewModel.downloadCurrentWeatherIcon(completionHandler: { imageView in
            DispatchQueue.main.async {
                self.weatherIconImageView.image = imageView
                self.descriptionLabel.text = description
            }
        })
    }
}

extension CurrentWeatherViewController {
    func setDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM HH:mm E"
        let currentTime = dateFormatter.string(from: currentDate)
        print(currentTime)
        return currentTime
    }
}


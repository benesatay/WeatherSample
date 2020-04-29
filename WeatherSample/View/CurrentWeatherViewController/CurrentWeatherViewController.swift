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
    
    @IBOutlet weak var celciusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = false
        ViewModel.getcurrentWeatherData(onSuccess: { WeatherModel in
            DispatchQueue.main.async {
                self.getMain(model: WeatherModel!)
                self.getWeather(model: WeatherModel!)
                self.activityIndicator.isHidden = true
            }
        }, onError: { error in
            print(error!.localizedDescription)
        })
        self.view.setBackgroundImage()
    }
    
    func getMain(model: Model) {
        let main = model.main
        
        var temp: Double = 0.0
        temp = main?.temp ?? 0
        
        var feels_like: Double = 0.0
        feels_like = main?.feels_like ?? 0
        
        var temp_max: Double = 0.0
        temp_max = main?.temp_max ?? 0
        
        var temp_min: Double = 0.0
        temp_min = main?.temp_min ?? 0
        
        self.currentTemperatureLabel.text = String(format:"%.0f", temp)
        self.feelslikeLabel.text = String(format:"%.0f", feels_like)
        self.currentTempMaxLabel.text = String(format:"%.0f", temp_max)
        self.currentTempMinLabel.text = String(format:"%.0f", temp_min)
        
        self.currentDateLabel.text = self.setDate()
        self.cityNameLabel.text = model.name!
    }
    
    func getWeather(model: Model) {
        let weather = model.weather
        let description = weather[0]?.description

        ViewModel.downloadWeatherIcon(completionHandler: { imageView in
            DispatchQueue.main.async {
                self.weatherIconImageView.image = imageView
                self.descriptionLabel.text = description
            }
        })
    }
      
    func setDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM HH:mm E"
        let currentTime = dateFormatter.string(from: currentDate)
        print(currentTime)
        return currentTime
    }
}


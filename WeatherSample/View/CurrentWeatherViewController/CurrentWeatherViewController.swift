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
        
        setCurrentWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(setCurrentWeatherData), name: NSNotification.Name(rawValue: "newCity"), object: nil)
    }
    
    @objc func setCurrentWeatherData() {
        viewModel.getCurrentWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.setWeatherMain()
                self.setWeather()
                self.activityIndicator.isHidden = true
            }
        })
    }
    
    func setWeatherMain() {
        let main = viewModel.currentWeatherData?.main
        
        let temp = main?.temp
        let feels_like = main?.feels_like
        let temp_max = main?.temp_max
        let temp_min = main?.temp_min
        
        self.currentTemperatureLabel.text = String(format:"%.0f", temp!).appending("°C")
        self.feelslikeLabel.text = String(format:"%.0f", feels_like!).appending("°")
        self.currentTempMaxLabel.text = String(format:"%.0f", temp_max!).appending("°")
        self.currentTempMinLabel.text = String(format:"%.0f", temp_min!).appending("°")
        
        self.currentDateLabel.text = self.setDate()
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
    func setDate() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM HH:mm E"
        let currentTime = dateFormatter.string(from: currentDate)
        print(currentTime)
        return currentTime
    }
}



//
//  CurrentWeatherDetailsViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 3.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class CurrentWeatherDetailsViewController: UIViewController {
    let viewModel = WeatherViewModel()
    
    @IBOutlet weak var viewHeaderLabel: UILabel!
    @IBOutlet weak var humidityHeaderLabel: UILabel!
    @IBOutlet weak var pressureHeaderLabel: UILabel!
    @IBOutlet weak var visibilityHeaderLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCurrentWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.setWeatherMainDetailsData()
            }
        })
    }
    
    func setWeatherMainDetailsData() {
        let main = viewModel.currentWeatherData?.main
        let humidity: Int = main?.humidity ?? 0
        let pressure: Int = main?.pressure ?? 0
        let visibility: Int = viewModel.currentWeatherData?.visibility ?? 0
        DispatchQueue.main.async {
            self.humidityLabel.text = "\(humidity)"
            self.pressureLabel.text = "\(pressure)"
            self.visibilityLabel.text = "\(visibility)"
        }
    }
}

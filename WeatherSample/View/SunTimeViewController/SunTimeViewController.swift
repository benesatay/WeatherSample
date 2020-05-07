//
//  SunTimeViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 4.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class SunTimeViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCurrentWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.setSysData()
            }
        })
    }
    
    func setSysData() {
        let sys = viewModel.currentWeatherData?.sys
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let sunrise: Int = sys?.sunrise ?? 0
        let sunriseTime = Date(timeIntervalSince1970: TimeInterval(sunrise))
        
        let sunset: Int = sys?.sunset ?? 0
        let sunsetTime = Date(timeIntervalSince1970: TimeInterval(sunset))
        
        DispatchQueue.main.async {
            self.sunriseLabel.text = dateFormatter.string(from: sunriseTime)
            self.sunsetLabel.text = dateFormatter.string(from: sunsetTime)
        }
    }
}

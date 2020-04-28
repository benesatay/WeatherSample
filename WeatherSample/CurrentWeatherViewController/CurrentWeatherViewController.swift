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
    var temp: Double = 0.0
    var feels_like: Double = 0.0
    var temp_max: Double = 0.0
    var temp_min: Double = 0.0
    
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
        
        ViewModel.getcurrentTempData(onSuccess: { weather, error in
            let main = weather["main"] as? [String : Any]
            print(main)
            self.temp = main?["temp"] as! Double
            self.feels_like = main?["feels_like"] as! Double
            self.temp_max = main?["temp_max"] as! Double
            self.temp_min = main?["temp_min"] as! Double
            
            print(weather["name"])
            DispatchQueue.main.async {
                self.currentTemperatureLabel.text = String(format:"%.0f", self.temp)
                self.feelslikeLabel.text = String(format:"%.0f", self.feels_like)
                self.currentTempMaxLabel.text = String(format:"%.0f", self.temp_max)
                self.currentTempMinLabel.text = String(format:"%.0f", self.temp_min)
                   
                self.currentDateLabel.text = self.setDate().date
                self.cityNameLabel.text = weather["name"] as! String
                
            }
        })
        
        setBackgroundImage()
        

    }
    
    func setBackgroundImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))
        let image = UIImage(named: "afternoon")
        imageView.image = image
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    func setDate() -> (date:String, time: String) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM HH:mm E"
        let currentTime = dateFormatter.string(from: currentDate)
        print(currentTime)
        return (currentTime, "")
    }
    

    
    
    
}

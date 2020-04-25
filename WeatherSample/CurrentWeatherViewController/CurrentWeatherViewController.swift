//
//  CurrentWeatherViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundImage()
        // Do any additional setup after loading the view.
    }

    func setBackgroundImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))
        let image = UIImage(named: "afternoon")
        imageView.image = image
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }



}

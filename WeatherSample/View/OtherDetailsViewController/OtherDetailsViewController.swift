//
//  OtherDetailsViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class OtherDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let ViewModel = WeatherViewModel()
    
    @IBOutlet weak var rainChanceCollectionView: UICollectionView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rainChanceCollectionView.dataSource = self
        rainChanceCollectionView.delegate = self

        let nib = UINib(nibName: "RainChanceCollectionViewCell", bundle: nil)
        rainChanceCollectionView.register(nib, forCellWithReuseIdentifier: "RainChanceCollectionViewCell")
        // Do any additional setup after loading the view.
        
        ViewModel.getcurrentWeatherData(onSuccess: { WeatherModel in
            self.getMain(model: WeatherModel!)
            self.getSys(model: WeatherModel!)
        }, onError: { error in
            print(error!.localizedDescription)
        })
        
        
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 60, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = rainChanceCollectionView.dequeueReusableCell(withReuseIdentifier: "RainChanceCollectionViewCell", for: indexPath) as! RainChanceCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor.systemGroupedBackground
        return cell
    }
    
    func getMain(model: Model) {
        let main = model.main
        
        var humidity: Int = 0
        humidity = main?.humidity ?? 0
        var pressure: Int = 0
        pressure = main?.pressure ?? 0
        var visibility: Int = 0
        visibility = model.visibility ?? 0
        
        DispatchQueue.main.async {
            self.humidityLabel.text = "\(humidity)"
            self.pressureLabel.text = "\(pressure)"
            self.visibilityLabel.text = "\(visibility)"
        }
    }
    
    func getSys(model: Model) {
        let sys = model.sys
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var sunrise: Int = 0
        sunrise = sys?.sunrise ?? 0
        let sunriseTime = Date(timeIntervalSince1970: TimeInterval(sunrise))
        print(sunriseTime)
        
        var sunset: Int = 0
        sunset = sys?.sunset ?? 0
        let sunsetTime = Date(timeIntervalSince1970: TimeInterval(sunset))
        print(sunsetTime)
        
        DispatchQueue.main.async {
            self.sunriseLabel.text = dateFormatter.string(from: sunriseTime)
            self.sunsetLabel.text = dateFormatter.string(from: sunsetTime)
        }
        
    }

}

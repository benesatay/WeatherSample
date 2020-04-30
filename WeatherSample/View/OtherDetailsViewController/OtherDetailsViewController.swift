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
    @IBOutlet weak var sunView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rainChanceCollectionView.dataSource = self
        rainChanceCollectionView.delegate = self
        
        ViewModel.getCurrentWeatherData(onSuccess: { WeatherModel in
            DispatchQueue.main.async {
                self.getMainDetails()
                self.getSys()
            }
        }, onError: {error in
            print(error!.localizedDescription)
        })
        
        ViewModel.getForecastWeatherData(onSuccess: { forecast in
            DispatchQueue.main.async {
                self.rainChanceCollectionView.reloadData()
            }
        }, onError: { error in
            print(error!.localizedDescription)
        })
        
        sunView.createGradientLayer(color1: .systemOrange, color2: .systemIndigo, x:0, y:0 , width: Int(UIScreen.main.bounds.width), height: 142)
        let nib = UINib(nibName: "RainChanceCollectionViewCell", bundle: nil)
        rainChanceCollectionView.register(nib, forCellWithReuseIdentifier: "RainChanceCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewModel.forecastWeatherModel?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = rainChanceCollectionView.dequeueReusableCell(withReuseIdentifier: "RainChanceCollectionViewCell", for: indexPath) as! RainChanceCollectionViewCell
        
        let rainData = ViewModel.forecastWeatherModel?.list?[indexPath.row].rain
        cell.rainChanceLabel.text = String(format:"%.2f", rainData?.the3h ?? 0)
        
        let dtTime: Int = ViewModel.forecastWeatherModel?.list?[indexPath.row].dt ?? 0
        cell.rainTimeLabel.text = dtTime.getForecastDate()
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor.systemGroupedBackground
        return cell
    }
}

extension OtherDetailsViewController {
    func getMainDetails() {
        let main = ViewModel.currentWeatherModel?.main
        
        let humidity: Int = main?.humidity ?? 0
        let pressure: Int = main?.pressure ?? 0
        let visibility: Int = ViewModel.currentWeatherModel?.visibility ?? 0
        
        DispatchQueue.main.async {
            self.humidityLabel.text = "\(humidity)"
            self.pressureLabel.text = "\(pressure)"
            self.visibilityLabel.text = "\(visibility)"
        }
    }
    
    func getSys() {
        let sys = ViewModel.currentWeatherModel?.sys
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

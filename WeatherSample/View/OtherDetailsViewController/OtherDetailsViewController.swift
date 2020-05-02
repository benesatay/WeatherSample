//
//  OtherDetailsViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class OtherDetailsViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    
    @IBOutlet weak var rainChanceCollectionView: UICollectionView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunView: UIView!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var rainLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        rainChanceCollectionView.dataSource = self
        rainChanceCollectionView.delegate = self
        
        viewModel.getCurrentWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.getMainDetails()
                self.getSys()
            }
        })
        
        viewModel.getForecastWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.rainChanceCollectionView.reloadData()
            }
        }, onError: { error in
            print(error!.localizedDescription)
        })
        
        detailView.createGradientLayer(startColor: .white, middleColor: .clear, endColor: .systemTeal, xStartpoint: 0.5, yStartpoint: 0.0, xEndpoint: 0.5, yEndpoint: 1.0, width: Int(UIScreen.main.bounds.width), height: 160)
        sunView.createGradientLayer(startColor: .systemOrange, middleColor: .clear, endColor: .systemIndigo, xStartpoint: 0.0, yStartpoint: 0.5, xEndpoint: 0.75, yEndpoint: 0.5, width: Int(UIScreen.main.bounds.width), height: 199)
 
        
        let nib = UINib(nibName: "RainChanceCollectionViewCell", bundle: nil)
        rainChanceCollectionView.register(nib, forCellWithReuseIdentifier: "RainChanceCollectionViewCell")
    }
    
    func getMainDetails() { //setup/confurge
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
    
    func getSys() {
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

extension OtherDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecastData?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = rainChanceCollectionView.dequeueReusableCell(withReuseIdentifier: "RainChanceCollectionViewCell", for: indexPath) as! RainChanceCollectionViewCell
        
        let rainData = viewModel.forecastData?.list?[indexPath.row].rain
        cell.rainChanceLabel.text = String(format:"%.2f", rainData?.the3h ?? 0)
        
        let dtTime: Int = viewModel.forecastData?.list?[indexPath.row].dt ?? 0
        cell.rainTimeLabel.text = dtTime.getForecastDate()
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .clear
        return cell
    }


}

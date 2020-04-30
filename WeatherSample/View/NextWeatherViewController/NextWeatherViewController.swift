//
//  NextWeatherViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class NextWeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let ViewModel = WeatherViewModel()
    
    @IBOutlet weak var NextWeatherCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        
        NextWeatherCollectionView.dataSource = self
        NextWeatherCollectionView.delegate = self
        
        ViewModel.getForecastWeatherData(onSuccess: { WeatherModel in
            DispatchQueue.main.async {
                self.NextWeatherCollectionView.reloadData()
            }
        }, onError: { error in
            print(error!.localizedDescription)
        })
        
        let nib = UINib(nibName: "NextWeatherCollectionViewCell", bundle: nil)
        NextWeatherCollectionView.register(nib, forCellWithReuseIdentifier: "NextWeatherCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewModel.forecastWeatherModel?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = NextWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: "NextWeatherCollectionViewCell", for: indexPath) as! NextWeatherCollectionViewCell
        
        let forecastWeatherList = ViewModel.forecastWeatherModel?.list?[indexPath.row]
        let forecastWeatherMain = forecastWeatherList?.main
        
        let nextTemp: Double = forecastWeatherMain?.temp ?? 0
        cell.nextTempLabel.text = String(format:"%.0f", nextTemp).appending("°")
        
        let dtTime: Int = ViewModel.forecastWeatherModel?.list?[indexPath.row].dt ?? 0
        cell.nextTempTimeLabel.text = dtTime.getForecastDate()
        
        ViewModel.downloadForecastWeatherIcon(index: indexPath.row, completionHandler: { imageView in
            DispatchQueue.main.async {
                cell.nextTempIcon.image = imageView
            }
        })
        
        cell.layer.cornerRadius = 20
      
        cell.backgroundColor = UIColor.systemPurple
        return cell
    }
}


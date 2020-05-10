//
//  ForecastTempViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 4.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class ForecastTempViewController: UIViewController {
    
    let weatherViewModel = WeatherViewModel()
    let forecastViewModel = ForecastViewModel()
    let selectedUnitViewModel = UnitViewModel()
    
    @IBOutlet weak var forecastTempCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTempCollectionView.dataSource = self
        forecastTempCollectionView.delegate = self
        
        forecastViewModel.getForecastWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.forecastTempCollectionView.reloadData()
            }
        }, onError: { error in
            print(error!.localizedDescription)
        })
        
        let nib = UINib(nibName: "ForecastTempCollectionViewCell", bundle: nil)
        forecastTempCollectionView.register(nib, forCellWithReuseIdentifier: "ForecastTempCollectionViewCell")
    }
    
    func getAsFahrenheit(with indexPath: IndexPath, onSuccess: @escaping (Double) -> Void) {
        var fahrenheitForecastTemp: Double = 0.0
        getAsCelcius(with: indexPath, onSuccess: { (forecastTemp) in
            fahrenheitForecastTemp = fahrenheitForecastTemp.convertToFahrenheit(with: forecastTemp)
            onSuccess(fahrenheitForecastTemp)
        })
    }
    
    func getAsCelcius(with indexPath: IndexPath, onSuccess: @escaping (Double) -> Void) {
        guard let forecastTemp = forecastViewModel.forecastData?.list?[indexPath.row].main?.temp else { return }
        onSuccess(forecastTemp)
    }
    
    func setupTempCell(to cell: ForecastTempCollectionViewCell, with indexPath: IndexPath) {
        self.selectedUnitViewModel.getUnitCoreData(compHandler: {
            DispatchQueue.main.async {
                if !self.selectedUnitViewModel.selectedUnitSegmentIndexArray.isEmpty {
                    switch self.selectedUnitViewModel.selectedUnitSegmentIndexArray[0] {
                    case 0:
                        self.getAsCelcius(with: indexPath, onSuccess: { (forecast) in
                            cell.forecastWeatherTempLabel.text = String(format:"%.0f", forecast).appending("°")
                        })
                    case 1:
                        self.getAsFahrenheit(with: indexPath, onSuccess: { (forecast) in
                            cell.forecastWeatherTempLabel.text = String(format:"%.0f", forecast).appending("°")
                        })
                    default:
                        break
                    }
                }
            }
        })
    }
    
    func setupCell(to cell: ForecastTempCollectionViewCell, with indexPath: IndexPath) {
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .clear
        forecastViewModel.downloadForecastWeatherIcon(index: indexPath.row, completionHandler: { weatherIcon in
            DispatchQueue.main.async {
                cell.forecastWeatherImageView.image = weatherIcon
            }
        })
        let forecastWeatherList = forecastViewModel.forecastData?.list?[indexPath.row]
        
        guard let dtTime = forecastWeatherList?.dt else { return }
        cell.forecastWeatherTimeLabel.text = dtTime.getForecastDate(with: "HH:mm")

        let rainVolume = forecastWeatherList?.rain
        cell.forecastRainVolumeLabel.text = String(format:"%.2f", rainVolume?.the3h ?? 0)
    }
}

extension ForecastTempViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastViewModel.forecastData?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastTempCollectionView.dequeueReusableCell(withReuseIdentifier: "ForecastTempCollectionViewCell", for: indexPath) as! ForecastTempCollectionViewCell
            
        setupTempCell(to: cell, with: indexPath)
        setupCell(to: cell, with: indexPath)
        return cell
        
    }
}

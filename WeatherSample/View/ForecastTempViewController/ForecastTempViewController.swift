//
//  ForecastTempViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 4.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class ForecastTempViewController: UIViewController {
    let viewModel = WeatherViewModel()

    @IBOutlet weak var forecastTempCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        forecastTempCollectionView.dataSource = self
        forecastTempCollectionView.delegate = self
        
        viewModel.getForecastWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.forecastTempCollectionView.reloadData()
            }
        }, onError: { error in
            print(error!.localizedDescription)
        })
        
        let nib = UINib(nibName: "ForecastTempCollectionViewCell", bundle: nil)
        forecastTempCollectionView.register(nib, forCellWithReuseIdentifier: "ForecastTempCollectionViewCell")
        
    }


    func setup(to cell: ForecastTempCollectionViewCell, with indexPath: IndexPath) {
        
        let forecastWeatherList = viewModel.forecastData?.list?[indexPath.row]
        let forecastWeatherMain = forecastWeatherList?.main
        
        let nextTemp: Double = forecastWeatherMain?.temp ?? 0
        cell.forecastWeatherTempLabel.text = String(format:"%.0f", nextTemp).appending("°")
        
        let dtTime: Int = viewModel.forecastData?.list?[indexPath.row].dt ?? 0
        cell.forecastWeatherTimeLabel.text = dtTime.getForecastDate(with: "HH:mm")
        
        let rainVolume = forecastWeatherList?.rain
        cell.forecastRainVolumeLabel.text = String(format:"%.2f", rainVolume?.the3h ?? 0)
        
        viewModel.downloadForecastWeatherIcon(index: indexPath.row, completionHandler: { imageView in
            DispatchQueue.main.async {
                cell.forecastWeatherImageView.image = imageView
            }
        })
        
        cell.layer.cornerRadius = 20
        
        cell.backgroundColor = .clear
        
    }
}

extension ForecastTempViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecastData?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastTempCollectionView.dequeueReusableCell(withReuseIdentifier: "ForecastTempCollectionViewCell", for: indexPath) as! ForecastTempCollectionViewCell
        
        setup(to: cell, with: indexPath)
        return cell
        
    }
}

//
//  NextWeatherViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class NextWeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    
    @IBOutlet weak var NextWeatherCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        
        NextWeatherCollectionView.dataSource = self
        NextWeatherCollectionView.delegate = self

        viewModel.getForecastWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.NextWeatherCollectionView.reloadData()
            }
        }, onError: { error in
            print(error!.localizedDescription)
        })
        
        let nib = UINib(nibName: "NextWeatherCollectionViewCell", bundle: nil)
        NextWeatherCollectionView.register(nib, forCellWithReuseIdentifier: "NextWeatherCollectionViewCell")
    }
    
    func setup(to cell: NextWeatherCollectionViewCell, with indexPath: IndexPath) {
          
          let forecastWeatherList = viewModel.forecastData?.list?[indexPath.row]
          let forecastWeatherMain = forecastWeatherList?.main
          
          let nextTemp: Double = forecastWeatherMain?.temp ?? 0
          cell.nextTempLabel.text = String(format:"%.0f", nextTemp).appending("°")
          
          let dtTime: Int = viewModel.forecastData?.list?[indexPath.row].dt ?? 0
          cell.nextTempTimeLabel.text = dtTime.getForecastDate()
          
          viewModel.downloadForecastWeatherIcon(index: indexPath.row, completionHandler: { imageView in
              DispatchQueue.main.async {
                  cell.nextTempIcon.image = imageView
              }
          })
          
          cell.layer.cornerRadius = 20
        
        cell.backgroundColor = .clear

    }
}

extension NextWeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecastData?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = NextWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: "NextWeatherCollectionViewCell", for: indexPath) as! NextWeatherCollectionViewCell
        
         setup(to: cell, with: indexPath)
        return cell

    }
}

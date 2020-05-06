//
//  ForecastWindViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 4.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class ForecastWindViewController: UIViewController {
    let viewModel = WeatherViewModel()
    
    @IBOutlet weak var forecastWindCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        forecastWindCollectionView.dataSource = self
        forecastWindCollectionView.delegate = self
        
        viewModel.getForecastWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.forecastWindCollectionView.reloadData()
            }
        }, onError: { error in
            print(error!.localizedDescription)
        })

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "WindCollectionViewCell", bundle: nil)
        forecastWindCollectionView.register(nib, forCellWithReuseIdentifier: "WindCollectionViewCell")
    }

    func setupWindData(to cell: WindCollectionViewCell, with indexPath: IndexPath) {
        let forecastWeatherList = viewModel.forecastData?.list?[indexPath.row]
        let forecastWind = forecastWeatherList?.wind
        
        let windSpeed = forecastWind?.speed
        cell.windSpeedLabel.text = "\(windSpeed ?? 0)"
        
        let windTime = forecastWeatherList?.dt
        cell.windTimeLabel.text = windTime?.getForecastDate(with: "HH:mm")
        
        let windDeg = forecastWind?.deg
        
        let grad = CAGradientLayer()
        grad.frame = cell.windDegImage.bounds
        let startColor = UIColor.white
        let endColor = UIColor.black
        grad.colors = [startColor, endColor]
        cell.windDegImage.layer.insertSublayer(grad, at: 0)
        
//        cell.windDegImage.createGradientLayer(startColor: .white, endColor: .systemBlue, xStartpoint: 0.5, yStartpoint: 0.0, xEndpoint: 0.5, yEndpoint: 1.0, width: Int(view.bounds.width), height: Int(view.bounds.height))
        UIView.animate(withDuration: 0.3, animations: {
            cell.windDegImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double(windDeg ?? 0) * Double.pi / 180.0))
        })
    }


}

extension ForecastWindViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 75, height: 121)
      }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecastData?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = forecastWindCollectionView.dequeueReusableCell(withReuseIdentifier: "WindCollectionViewCell", for: indexPath) as! WindCollectionViewCell
        
        setupWindData(to: cell, with: indexPath)
        return cell
    }
    
    
}

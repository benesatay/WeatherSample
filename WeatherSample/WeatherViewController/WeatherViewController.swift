//
//  WeatherViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 24.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var currentDayCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDayCollectionView.delegate = self
        currentDayCollectionView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true

        let nib = UINib(nibName: "CurrentWeatherCollectionViewCell", bundle: nil)
        currentDayCollectionView.register(nib, forCellWithReuseIdentifier: "CurrentWeatherCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 500)
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = currentDayCollectionView.dequeueReusableCell(withReuseIdentifier: "CurrentWeatherCollectionViewCell", for: indexPath) as! CurrentWeatherCollectionViewCell
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        let image = UIImage(named: "afternoon")
        imageView.image = image
        cell.backgroundView = UIView()
        cell.backgroundView?.addSubview(imageView)
        return cell
    }
    


}

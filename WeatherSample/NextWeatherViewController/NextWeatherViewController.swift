//
//  NextWeatherViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class NextWeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var NextWeatherCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
      
        NextWeatherCollectionView.dataSource = self
        NextWeatherCollectionView.delegate = self
        
        let nib = UINib(nibName: "NextWeatherCollectionViewCell", bundle: nil)
        NextWeatherCollectionView.register(nib, forCellWithReuseIdentifier: "NextWeatherCollectionViewCell")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = NextWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: "NextWeatherCollectionViewCell", for: indexPath) as! NextWeatherCollectionViewCell
        
        cell.layer.cornerRadius = 20
        cell.backgroundColor = UIColor.systemTeal
        return cell
        
    }
    


}

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
        
        let customOrange = UIColor(red:250/255, green:198/255, blue:97/255, alpha:1.0)
        self.view.createGradientLayer(color1: customOrange, color2: .white)
       
      
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        currentDayCollectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
      
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 0, height: 0)
        if indexPath.row == 1 || indexPath.row == 2 {
            size = CGSize(width: UIScreen.main.bounds.width, height: 250)
        } else {
            size = CGSize(width: UIScreen.main.bounds.width, height: 500)
        }
        return size
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = currentDayCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if indexPath.row == 1 {
            let nib = NextWeatherViewController(nibName: "NextWeatherViewController", bundle: nil)
            cell.addSubview(nib.view)
            addChild(nib)
        } else if indexPath.row == 2 {
            let nib = NextWeatherViewController(nibName: "NextWeatherViewController", bundle: nil)

            cell.addSubview(nib.view)
            addChild(nib)
        }else {
            let nib = CurrentWeatherViewController(nibName: "CurrentWeatherViewController", bundle: nil)

            cell.addSubview(nib.view)
        }
 
        return cell
    }
    


}


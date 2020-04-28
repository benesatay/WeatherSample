//
//  OtherDetailsViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 25.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit

class OtherDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var rainChanceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rainChanceCollectionView.dataSource = self
        rainChanceCollectionView.delegate = self

        let nib = UINib(nibName: "RainChanceCollectionViewCell", bundle: nil)
        rainChanceCollectionView.register(nib, forCellWithReuseIdentifier: "RainChanceCollectionViewCell")
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 60, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = rainChanceCollectionView.dequeueReusableCell(withReuseIdentifier: "RainChanceCollectionViewCell", for: indexPath) as! RainChanceCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor.systemGroupedBackground
        return cell

    }

}

//
//  WeatherViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 24.04.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import CoreData


class WeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel()
    
    let tableview = UITableView()
    
    
    var searchActive: Bool = false
    var cityNameArray: [String] = []
    var filteredCity: [String] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var currentDayCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        currentDayCollectionView.delegate = self
        currentDayCollectionView.dataSource = self
        
        setNavigationController()
        setBackground()
        
        tableview.isHidden = true
        setSubview()
        
        viewModel.getTRcityList(onSuccess: {
            for city in (self.viewModel.cityData?.trcitylist!)! {
                self.cityNameArray.append(city.name!)
                self.cityNameArray.sort()
            }
        })
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        currentDayCollectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    func setBackground() {
        //view background
        let customOrange = UIColor(red:250/255, green:198/255, blue:97/255, alpha:1.0)
        self.view.createGradientLayer(startColor: customOrange, middleColor: .clear, endColor: customOrange, xStartpoint: 0.5, yStartpoint: 0.0, xEndpoint: 0.5, yEndpoint: 1.0, width: Int(UIScreen.main.bounds.width), height: 500)
        
        //collectionview background
        currentDayCollectionView.backgroundColor = .clear
    }
    
    func setNavigationController() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func setSubview() {
        
        let viewFrame = CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width-16, height: 176)
        tableview.frame = viewFrame
        tableview.backgroundColor = .systemGroupedBackground
        tableview.layer.cornerRadius = 10
        view.addSubview(tableview)
        tableview.didMoveToSuperview()
        UICollectionView.animate(withDuration: 0.3) {
            self.tableview.transform = CGAffineTransform(translationX: 0, y: 100)
        }
        
    }
    
    func saveCityData(value: Any?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        guard context != nil else { return }
        let newCity = NSEntityDescription.insertNewObject(forEntityName: "Cities", into: context)
        newCity.setValue(value, forKey: "name")
        do {
            try context.save()
        } catch {
            print("context error")
        }
    }
}

extension WeatherViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        tableview.isHidden = false
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = nil
        tableview.isHidden = true
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCity = cityNameArray.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            return range.location != NSNotFound
        })
        if(filteredCity.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        tableview.reloadData()
        tableview.isHidden = false
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredCity.count
        }
        return cityNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if filteredCity.count > 0 {
            cell.textLabel?.text = filteredCity[indexPath.row]
        } else {
            cell.textLabel?.text = cityNameArray[indexPath.row]
        }
        cell.separatorInset = .zero
        cell.backgroundColor = .systemGroupedBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchActive){
            saveCityData(value: filteredCity[indexPath.row])
            print("added")
            tableview.removeFromSuperview()
        }
        else {
            saveCityData(value: cityNameArray[indexPath.row])
            print("added")
            tableView.removeFromSuperview()
        }
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 0, height: 0)
        if indexPath.row == 1 {
            size = CGSize(width: UIScreen.main.bounds.width, height: 200)
        } else if indexPath.row == 2 {
            size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
            let nib = OtherDetailsViewController(nibName: "OtherDetailsViewController", bundle: nil)
            cell.addSubview(nib.view)
            addChild(nib)
        }else {
            let nib = CurrentWeatherViewController(nibName: "CurrentWeatherViewController", bundle: nil)
            cell.addSubview(nib.view)
        }
        cell.backgroundColor = .white
        return cell
    }
}

extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(scrollView.contentOffset.y)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldHide = scrollView.contentOffset.y > 100
        //        navigationController?.setNavigationBarHidden(shouldHide, animated: true)
    }
}

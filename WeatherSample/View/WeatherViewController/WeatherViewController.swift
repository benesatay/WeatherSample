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
    
    let setAlert = SetupAlert()
    let viewModel = WeatherViewModel()
    let coreDataOperations = CoreDataOperations()
    let setupSubview = SetupExternalSubviews()
    
    var searchBar = UISearchBar()
    let tableview = UITableView()

    var searching: Bool = false
    var cityNameArray: [String] = []
    var filteredCity: [String] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var currentWeatherDetailView: UIView!
    @IBOutlet weak var forecastWeatherView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = false
        
        searchBar.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        
        DispatchQueue.main.async {
            self.setSubviews()
            self.setupTableViewSubview()
            self.setupSearchbarSubview()
            self.setNavigationController()
        }
        
        viewModel.getTRcityList(onSuccess: {
            for city in (self.viewModel.cityData?.trcitylist!)! {
                self.cityNameArray.append(city.name!)
                self.cityNameArray.sort()
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(setSubviews), name: NSNotification.Name(rawValue: "deleted"), object: nil)
    }
    
    @objc func passToCityList() {
        let destination = SelectedCitiesViewController(nibName: "SelectedCitiesViewController", bundle: nil)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func setSearchBar() {
        UICollectionView.animate(withDuration: 0.2) {
            self.searchBar.transform = CGAffineTransform(translationX: 0, y: self.topBarHeight)
            if self.searchBar.isHidden {
                self.searchBar.isHidden = false
            } else {
                self.searchBar.isHidden = true
            }
        }
    }
    
    func setNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(passToCityList))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(setSearchBar))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setMainBackground() {
        setBackgroundColor(with: self,
                           dayStartColor: .cyan,
                           dayEndColor: .cyan,
                           nightStartColor: .black,
                           nightEndColor: .black,
                           height: Int(UIScreen.main.bounds.height))
    }
    
    @objc func setSubviews() {
        viewModel.getCurrentWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.setMainBackground()
                self.setupSubview.setCurrentWeatherSubview(with: self, with: self.contentView)
                self.setupSubview.setCurrentWeatherDetailSubview(with: self, with: self.contentView)
                self.setupSubview.setForecastTempSubview(with: self, with: self.contentView)
                self.setupSubview.setForecastWindSubview(with: self, with: self.contentView)
                self.setupSubview.setSunTimeSubview(with: self, with: self.contentView)
                self.activityIndicator.isHidden = true
            }
        })
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            coreDataOperations.saveNewUnit(value: 0, onSuccess: {
                self.setSubviews()
            })
        case 1:
            coreDataOperations.saveNewUnit(value: 1, onSuccess: {
                self.setSubviews()
            })
        default:
            break
        }
    }
}

extension WeatherViewController {
    //MARK: SegmentedControl
    func setSegmentedControllSubview(with nib: UIViewController) {
        let segmentedItems = ["°C", "°F"]
        
        let segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .white
        } else {
            segmentedControl.tintColor = .white
        }
        
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        viewModel.getUnitCoreData(compHandler: {
            if !self.viewModel.selectedUnitSegmentIndexArray.isEmpty {
                segmentedControl.selectedSegmentIndex = self.viewModel.selectedUnitSegmentIndexArray[0]
            } else {
                segmentedControl.selectedSegmentIndex = 0
            }
        })
        let viewFrame = CGRect(x: UIScreen.main.bounds.width-116, y: 0, width: 100, height: 30)
        segmentedControl.frame = viewFrame
        nib.view.addSubview(segmentedControl)
    }
    
    //MARK: Searchbar
    func setupSearchbarSubview() {
        let viewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        searchBar.frame = viewFrame
        view.addSubview(searchBar)
        searchBar.didMoveToSuperview()
        searchBar.isHidden = true
        UICollectionView.animate(withDuration: 0.2) {
            self.searchBar.transform = CGAffineTransform(translationX: 0, y: self.topBarHeight)
        }
    }
    
    //MARK: Tableview
    func setupTableViewSubview() {
        let viewFrame = CGRect(x: 8, y: 0, width: UIScreen.main.bounds.width-16, height: 176)
        tableview.frame = viewFrame
        tableview.backgroundColor = .white
        tableview.layer.cornerRadius = 10
        view.addSubview(tableview)
        tableview.didMoveToSuperview()
        tableview.isHidden = true

        UICollectionView.animate(withDuration: 0.3) {
            self.tableview.transform = CGAffineTransform(translationX: 0, y: self.topBarHeight + 44)
        }
    }
}

extension WeatherViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
        tableview.isHidden = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.filteredCity.removeAll()
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searching = false
        tableview.isHidden = true
        searchBar.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCity = cityNameArray.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            return range.location != NSNotFound
        })
        tableview.isHidden = false
        if filteredCity.isEmpty {
            searching = false;
        } else {
            searching = true;
        }
        tableview.reloadData()
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searching) {
            return filteredCity.count
        }
        return cityNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if !filteredCity.isEmpty {
            cell.textLabel?.text = filteredCity[indexPath.row]
        } else {
            cell.textLabel?.text = cityNameArray[indexPath.row]
        }
        cell.separatorInset = .zero
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !filteredCity.isEmpty {
            coreDataOperations.saveNewCity(value: filteredCity[indexPath.row], onSuccess: {
                self.setAlert.setupAlert(with: self, title: "Success!", message: "City was added")
                self.setSubviews()
            }, entityAlert: {
                self.setAlert.setupAlert(with: self, title: "Warning!", message: "City already was added")
            })
        } else {
            coreDataOperations.saveNewCity(value: cityNameArray[indexPath.row], onSuccess: {
                self.setAlert.setupAlert(with: self, title: "Success!", message: "City was added")
                self.setSubviews()
            }, entityAlert: {
                self.setAlert.setupAlert(with: self, title: "Warning!", message: "City already was added")
            })
        }
        self.searchBar.resignFirstResponder()
        
        self.filteredCity.removeAll()
        self.tableview.reloadData()
        
        self.searchBar.endEditing(true)
        self.searchBar.text = nil
    }
}

extension WeatherViewController {
    //MARK: Setup Background
    func setBackgroundColor(with destination: UIViewController, dayStartColor: UIColor, dayEndColor: UIColor, nightStartColor: UIColor, nightEndColor: UIColor, height: Int) {
        setTimeForBackground(completionHandler: {(currentDate, sunriseString, sunsetString) in
            if let currentTime = Int(currentDate), currentTime >= Int(sunriseString) ?? 0 && currentTime < Int(sunsetString) ?? 0 {
                destination.view.createGradientLayer(startColor: dayStartColor, endColor: dayEndColor, width: Int(UIScreen.main.bounds.width), height: height)
            } else {
//                destination.view.createGradientLayer(startColor: nightStartColor, endColor: nightEndColor, width: Int(UIScreen.main.bounds.width), height: height)
//                UILabel.appearance().textColor = .white
//                self.navigationController?.navigationBar.barStyle = .black
                destination.view.createGradientLayer(startColor: dayStartColor, endColor: dayEndColor, width: Int(UIScreen.main.bounds.width), height: height)

            }
        })
    }
    
    func setBackgroundImage(with destination: UIViewController) {
        setTimeForBackground(completionHandler: { (currentDate, sunriseString, sunsetString) in
            if let currentTime = Int(currentDate), currentTime >= Int(sunriseString) ?? 0 && currentTime < Int(sunsetString) ?? 0 {
                destination.view.setBackground(with: "newdaymoon")
            } else {
                destination.view.setBackground(with: "newdaymoon")
            }
        })
    }
    
    func setTimeForBackground(completionHandler: @escaping (String, String, String) -> Void) {
        guard let sunrise = viewModel.currentWeatherData?.sys?.sunrise else { return }
        guard let sunset = viewModel.currentWeatherData?.sys?.sunset else { return }
        let sunriseString = sunrise.getForecastDate(with: "HHmm")
        let sunsetString = sunset.getForecastDate(with: "HHmm")
        let currentDate = Date().setDate(with: "HHmm")
        completionHandler(currentDate, sunriseString, sunsetString)
    }
}



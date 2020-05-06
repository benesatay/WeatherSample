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
    let coreDataOperations = CoreDataOperations()

    let tableview = UITableView()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var searching: Bool = false
    var cityNameArray: [String] = []
    var filteredCity: [String] = []
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var currentWeatherView: UIView!
    @IBOutlet weak var currentWeatherDetailView: UIView!
    @IBOutlet weak var forecastWeatherView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = false
        searchBar.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        
        setNavigationController()
        //self.view.setBackgroundImage()
        tableview.isHidden = true
        
        DispatchQueue.main.async {
            self.setTableViewSubview()
        }
        setupSubviews()
        
        viewModel.getTRcityList(onSuccess: {
            for city in (self.viewModel.cityData?.trcitylist!)! {
                self.cityNameArray.append(city.name!)
                self.cityNameArray.sort()
            }
        })
        

        
        NotificationCenter.default.addObserver(self, selector: #selector(setupSubviews), name: NSNotification.Name(rawValue: "deleted"), object: nil)
    }
    
    @objc func setupSubviews() {
        viewModel.getCurrentWeatherData(onSuccess: {
            DispatchQueue.main.async {
                self.setMainBackground()
                self.setCurrentWeatherSubview()
                self.setCurrentWeatherDetailSubview()
                self.setForecastTempSubview()
                self.setForecastWindSubview()
                self.setSunTimeSubview()
                self.activityIndicator.isHidden = true
            }
        })
    }
    
    @IBAction func selectedCityList(_ sender: Any) {
        passToCityList()
    }
    func passToCityList() {
        let destination = SelectedCitiesViewController(nibName: "SelectedCitiesViewController", bundle: nil)
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func setNavigationController() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    
    
    func setupAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func cityAddedAlert() {
        setupAlert(title: "Success", message: "City was added")
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
        cell.backgroundColor = .systemGroupedBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !filteredCity.isEmpty {
            coreDataOperations.saveNewObject(value: filteredCity[indexPath.row], onSuccess: {
                self.setupAlert(title: "Success!", message: "City was added")
                self.setupSubviews()
            }, entityAlert: {
                self.setupAlert(title: "Warning!", message: "City already was added")
            })
        } else {
            coreDataOperations.saveNewObject(value: cityNameArray[indexPath.row], onSuccess: {
                self.setupAlert(title: "Success!", message: "City was added")
                self.setupSubviews()
            }, entityAlert: {
                self.setupAlert(title: "Warning!", message: "City already was added")
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
    func setSubview(with nib: UIViewController, viewFrame: CGRect) {
        nib.view.frame = viewFrame
        contentView.addSubview(nib.view)
    }
    
    //MARK: CurrentWeatherViewController
    func setCurrentWeatherSubview() {
        let destination = CurrentWeatherViewController(nibName: "CurrentWeatherViewController", bundle: nil)
        setBackgroundImage(with: destination)
        setBackgroundColor(with: destination,
                           dayStartColor: .cyan,
                           dayEndColor: .systemTeal,
                           nightStartColor: .clear,
                           nightEndColor: .clear,
                           height: 500)
        
        setSegmentedControllSubview(with: destination)
        let viewFrame = CGRect(x: 0, y: 60, width: contentView.bounds.width, height: 500)
        setSubview(with: destination, viewFrame: viewFrame)
    }

    
    //MARK: CurrentWeatherDetailViewController
    func setCurrentWeatherDetailSubview() {
        let destination = CurrentWeatherDetailsViewController(nibName: "CurrentWeatherDetailsViewController", bundle: nil)
        setBackgroundColor(with: destination,
                           dayStartColor: .systemTeal,
                           dayEndColor: .systemPurple,
                           nightStartColor: .black,
                           nightEndColor: .systemIndigo,
                           height: 185)
        let viewFrame = CGRect(x: 0, y: 560, width: contentView.bounds.width, height: 185)
        setSubview(with: destination, viewFrame: viewFrame)
    }
    
    //MARK: ForecastTempViewController
    func setForecastTempSubview() {
        let destination = ForecastTempViewController(nibName: "ForecastTempViewController", bundle: nil)
        setBackgroundColor(with: destination,
                           dayStartColor: .systemPurple,
                           dayEndColor: UIColor(red: 137/255, green: 68/255, blue: 171/255, alpha: 1.0),
                           nightStartColor: .systemIndigo,
                           nightEndColor: .systemPurple,
                           height: 161)
        let viewFrame = CGRect(x: 0, y: 745, width: contentView.bounds.width, height: 161)
        setSubview(with: destination ,viewFrame: viewFrame)
        addChild(destination)
    }
    
    //MARK: ForecastWindViewController
    func setForecastWindSubview() {
        let destination = ForecastWindViewController(nibName: "ForecastWindViewController", bundle: nil)
        setBackgroundColor(with: destination,
                           dayStartColor: UIColor(red: 137/255, green: 68/255, blue: 171/255, alpha: 1.0),
                           dayEndColor: .systemIndigo,
                           nightStartColor: .systemPurple,
                           nightEndColor: .systemTeal,
                           height: 256)
        let viewFrame = CGRect(x: 0, y: 906, width: contentView.bounds.width, height: 256)
        setSubview(with: destination, viewFrame: viewFrame)
        addChild(destination)
    }
    
    //MARK: SunTimeViewController
    func setSunTimeSubview() {
        let destination = SunTimeViewController(nibName: "SunTimeViewController", bundle: nil)
        setBackgroundColor(with: destination,
                           dayStartColor: .systemIndigo,
                           dayEndColor: UIColor(red: 54/255, green: 52/255, blue: 163/255, alpha: 1.0),
                           nightStartColor: .systemTeal,
                           nightEndColor: .white,
                           height: 199)
        let viewFrame = CGRect(x: 0, y: 1162, width: contentView.bounds.width, height: 140)
        setSubview(with: destination, viewFrame: viewFrame)
        addChild(destination)
    }
    
    //MARK: Tableview
    func setTableViewSubview() {
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
}

extension WeatherViewController {
    func setMainBackground() {
        setBackgroundColor(with: self, dayStartColor: .cyan, dayEndColor: .cyan, nightStartColor: .black, nightEndColor: .black, height: 500)
    }
    
    func setBackgroundColor(with destination: UIViewController, dayStartColor: UIColor, dayEndColor: UIColor, nightStartColor: UIColor, nightEndColor: UIColor, height: Int) {
        setTimeForBackground(completionHandler: {(currentDate, sunriseString, sunsetString) in
            if let currentTime = Int(currentDate), currentTime >= Int(sunriseString) ?? 0 && currentTime < Int(sunsetString) ?? 0 {
                destination.view.createGradientLayer(startColor: dayStartColor, endColor: dayEndColor, width: Int(UIScreen.main.bounds.width), height: height)
            } else {
                destination.view.createGradientLayer(startColor: nightStartColor, endColor: nightEndColor, width: Int(UIScreen.main.bounds.width), height: height)
                UILabel.appearance().textColor = .white
            }
        })
    }
    
    func setBackgroundImage(with destination: UIViewController) {
        setTimeForBackground(completionHandler: { (currentDate, sunriseString, sunsetString) in
            if let currentTime = Int(currentDate), currentTime >= Int(sunriseString) ?? 0 && currentTime < Int(sunsetString) ?? 0 {
                destination.view.setBackground(with: "newdaymoon")
            } else {
                destination.view.setBackground(with: "bloodmoon")
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

extension WeatherViewController {
    
    
    
    func setSegmentedControllSubview(with nib: UIViewController) {
        let segmentedItems = ["°C", "°F"]
        let segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.frame = CGRect(x: UIScreen.main.bounds.width-116, y: 0, width: 100, height: 30)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        
        viewModel.getUnitCoreData(compHandler: {
            if !self.viewModel.selectedUnitArray.isEmpty {
                segmentedControl.selectedSegmentIndex = self.viewModel.selectedUnitArray[0]
                print("self.viewModel.selectedUnitArray[0]",self.viewModel.selectedUnitArray[0])
            } else {
                segmentedControl.selectedSegmentIndex = 0
            }
        })
        nib.view.addSubview(segmentedControl)
    }
 
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("c")
          
            coreDataOperations.saveNewUnitObject(value: 0, onSuccess: {
                self.setupSubviews()
            })
            
          
        case 1:
            print("f")
            
            coreDataOperations.saveNewUnitObject(value: 1, onSuccess: {
                self.setupSubviews()
            })
        default:
            break
        }
    }
}

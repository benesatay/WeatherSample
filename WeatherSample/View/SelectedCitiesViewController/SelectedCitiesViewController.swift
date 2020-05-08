//
//  SelectedCitiesViewController.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 2.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import CoreData

class SelectedCitiesViewController: UIViewController {
    
    var viewModel = WeatherViewModel()
    var coreDataOperations = CoreDataOperations()
    let setAlert = SetupAlert()
    var selectedCityArray: [String] = []
    
    var choosedCity: String = ""
    
    @IBOutlet weak var selectedCitiesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCitiesTableView.delegate = self
        selectedCitiesTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeCityList))
        viewModel.getCityCoreData(compHandler: {
            for city in self.viewModel.selectedCitiesArray {
                print(city)
                self.selectedCityArray.append(city)
            }
        })
    }
    
    func turnToWeather() {
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleted"), object: nil)
    }

    @objc func removeCityList() {
        coreDataOperations.clearCityList(onSuccess: {
            self.selectedCityArray.removeAll()
            self.selectedCitiesTableView.reloadData()
            self.setAlert.setupAlert(with: self, title: "Success", message: "Deleted")
        })
    }
}

extension SelectedCitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = selectedCityArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDataOperations.removeSelectedCity(index: indexPath.row, onSuccess: {
                self.selectedCityArray.remove(at: indexPath.row)
                self.selectedCitiesTableView.reloadData()
                self.setAlert.setupAlert(with: self, title: "Success", message: "Deleted")
            }, onError: {
                print("delete error")
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coreDataOperations.removeSelectedCity(index: indexPath.row, onSuccess: {
            self.choosedCity = self.selectedCityArray[indexPath.row]
            self.selectedCityArray.remove(at: indexPath.row)
            self.coreDataOperations.saveNewCity(value: self.choosedCity, onSuccess: {
                self.turnToWeather()
            }, entityAlert: {
                self.setAlert.setupAlert(with: self, title: "Error", message: "City could not selected")
            })
        }, onError: {
            self.setAlert.setupAlert(with: self, title: "Error", message: "City could not selected")
        })
    }
}

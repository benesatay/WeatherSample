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
    
    var coreDataOperations = CoreDataOperations()
    var viewModel = WeatherViewModel()
    var selectedCityArray: [String] = []
    
    @IBOutlet weak var selectedCitiesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedCitiesTableView.delegate = self
        selectedCitiesTableView.dataSource = self
        viewModel.getCityCoreData(compHandler: {
            for city in self.viewModel.selectedCitiesArray {
                print(city)
                self.selectedCityArray.append(city)
            }
        })
    }
    
    @IBAction func backBarButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleted"), object: nil)
    }
    @IBAction func removeCityListButton(_ sender: Any) {
        coreDataOperations.clearCityList(onSuccess: {
            self.selectedCityArray.removeAll()
            self.selectedCitiesTableView.reloadData()
            self.deletedCityAlert()
        })
    }
    
    func deletedCityAlert() {
        let alert = UIAlertController(title: "Success", message: "Deleted", preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            alert.dismiss(animated: true, completion: nil)
        }
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
                self.deletedCityAlert()
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleted"), object: nil)
            }, onError: {
                print("delete error")
            })
        }
    }
}

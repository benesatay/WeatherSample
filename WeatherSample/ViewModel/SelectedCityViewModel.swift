//
//  SelectedCityViewModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 10.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataProtocol {
    func getCoreData(entityName: String, onSuccess: @escaping (Any) -> Void)
}

class SelectedCityViewModel {
    
    var selectedCitiesArray: [String] = []
    
    func getCityCoreData(compHandler: @escaping () -> Void)  {
        selectedCitiesArray.removeAll()
        getCoreData(entityName: "Cities", onSuccess: { (results) in
            for result in results as! [NSManagedObject] {
                guard let name = result.value(forKey: "name") as? String else { return }
                self.selectedCitiesArray.insert(name, at: 0)
            }
        })
        compHandler()
    }
}

extension SelectedCityViewModel: CoreDataProtocol {
    func getCoreData(entityName: String, onSuccess: @escaping (Any) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            onSuccess(results)
        } catch {
            print("fetchrequest error")
        }
    }
}

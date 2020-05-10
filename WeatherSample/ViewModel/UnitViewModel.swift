//
//  UnitViewModel.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 10.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import CoreData

class UnitViewModel {
    var temperatureTypeData: TemperatureType?
    var selectedUnitSegmentIndexArray: [Int] = []
    func getUnitCoreData(compHandler: @escaping () -> Void) {
        getCoreData(entityName: "TempUnit", onSuccess: { (results) in
            self.selectedUnitSegmentIndexArray.removeAll()
            for result in results as! [NSManagedObject] {
                guard let unit = result.value(forKey: "unit") as? Int32 else { return }
                self.selectedUnitSegmentIndexArray.insert(Int(unit), at: 0)
            }
        })
        compHandler()
    }
}

extension UnitViewModel: CoreDataProtocol {
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

//
//  CoreDataOperations.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 5.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    var selectedCityViewModel = SelectedCityViewModel()
    var selectedUnitViewModel = UnitViewModel()
    
    // MARK: save new object
    func saveNewCity(value: Any?, onSuccess: @escaping () -> Void, entityAlert: @escaping () -> Void) {
        setupCoreData(completionHandler: { (context) in
            guard context != nil else { return }
            self.selectedCityViewModel.getCityCoreData(compHandler: {
                if self.selectedCityViewModel.selectedCitiesArray.isEmpty {
                    self.insertNewObject(value: value, onSuccess: {
                        onSuccess()
                    })
                } else {
                    self.avoidDuplicatedObject(value: value, onSuccess: {
                        onSuccess()
                    }, entityAlert: {
                        entityAlert()
                    })
                }
            })
        })
    }
    
    func saveNewUnit(value: Any?, onSuccess: @escaping () -> Void) {
        setupCoreData(completionHandler: { (context) in
            guard context != nil else { return }
            self.selectedUnitViewModel.getUnitCoreData(compHandler: {
                if !self.selectedUnitViewModel.selectedUnitSegmentIndexArray.isEmpty {
                    self.clearUnitList()
                }
                self.insertUnitObject(value: value, onSuccess: {
                    onSuccess()
                })
            })
        })
    }
    
    // MARK: Insert new object
    func insertNewObject(value: Any?, onSuccess: @escaping ()-> Void) {
        setupObjectInserting(value: value, forEntityName: "Cities", forKey: "name")
        onSuccess()
    }
    
    func insertUnitObject(value: Any?, onSuccess: @escaping ()-> Void) {
        setupObjectInserting(value: value, forEntityName: "TempUnit", forKey: "unit")
        onSuccess()
    }
    
    // MARK: Whole entities will be removed
    func clearCityList(onSuccess: @escaping () -> Void) {
        setupRemovingWholeEntities(entityName: "Cities", onSuccess: {
            self.selectedCityViewModel.getCityCoreData(compHandler: {
                self.selectedCityViewModel.selectedCitiesArray.removeAll()
                print("deleted")
            })
            onSuccess()
        })
    }
    
    func clearUnitList() {
        setupRemovingWholeEntities(entityName: "TempUnit", onSuccess: {
            self.selectedUnitViewModel.getUnitCoreData(compHandler: {
                self.selectedUnitViewModel.selectedUnitSegmentIndexArray.removeAll()
                print("deleted")
            })
        })
    }
    
    // MARK: Catch duplicated entity during new object inserting
    func avoidDuplicatedObject(value: Any?, onSuccess: @escaping ()-> Void, entityAlert: @escaping () -> Void) {
        setupCoreData(completionHandler: {(context) in
            let entity = NSEntityDescription.entity(forEntityName: "Cities", in: context)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            let predicate = NSPredicate.init(format: "name contains[c] %@", value as? String ?? "")
            fetchRequest.predicate = predicate
            fetchRequest.entity = entity
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    print("city already exist")
                    entityAlert()
                } else {
                    self.insertNewObject(value: value, onSuccess: {
                        onSuccess()
                    })
                }
            } catch {
                print(error.localizedDescription)
            }
        })
    }
    
    // MARK: Selected entities will be removed
    func removeSelectedCity(index: Int, onSuccess: @escaping () -> Void, onError: @escaping ()-> Void) {
        setupCoreData(completionHandler: { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
            self.selectedCityViewModel.getCityCoreData(compHandler: {
                var willRemoveItemOfArray = self.selectedCityViewModel.selectedCitiesArray
                let willRemoveItem = willRemoveItemOfArray[index]
                fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", willRemoveItem)
                fetchRequest.returnsObjectsAsFaults = false
                do {
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            if let name = result.value(forKey: "name") as? String {
                                if name == willRemoveItem {
                                    context.delete(result)
                                    willRemoveItemOfArray.remove(at: index)
                                    do {
                                        try context.save()
                                    } catch {
                                        onError()
                                    }
                                }
                            }
                        }
                    }
                    onSuccess()
                } catch {
                    onError()
                }
            })
        })
    }
}

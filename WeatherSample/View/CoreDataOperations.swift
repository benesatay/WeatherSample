//
//  CoreDataOperations.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 5.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import CoreData

class CoreDataOperations {
    
    var viewModel = WeatherViewModel()
    // MARK: save new object
    func saveNewObject(value: Any?, onSuccess: @escaping () -> Void, entityAlert: @escaping () -> Void) {
        setupCoreData(completionHandler: { (context) in
            guard context != nil else { return }
            self.viewModel.getCityCoreData(compHandler: {
                if self.viewModel.selectedCitiesArray.isEmpty {
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
    
    func saveNewUnitObject(value: Any?, onSuccess: @escaping () -> Void) {
        setupCoreData(completionHandler: { (context) in
            guard context != nil else { return }
            self.viewModel.getUnitCoreData(compHandler: {
                if self.viewModel.selectedUnitArray.count > 2 {
                    self.clearUnitList(onSuccess: {
                        self.viewModel.selectedUnitArray.removeAll()
                    })
                }
                self.insertUnitObject(value: value, onSuccess: {
                    onSuccess()
                })
            })
        })
    }
    
    // MARK: Insert new object
    func insertNewObject(value: Any?, onSuccess: @escaping ()-> Void) {
        setupCoreData(completionHandler: { (context) in
            let newEntity = NSEntityDescription.insertNewObject(forEntityName: "Cities", into: context)
            newEntity.setValue(value, forKey: "name")
            do {
                try context.save()
                onSuccess()
            } catch {
                print("insert error")
            }
        })
    }
    
    func insertUnitObject(value: Any?, onSuccess: @escaping ()-> Void) {
        setupCoreData(completionHandler: { (context) in
            let newEntity = NSEntityDescription.insertNewObject(forEntityName: "TempUnit", into: context)
            newEntity.setValue(value, forKey: "unit")
            do {
                try context.save()
                onSuccess()
            } catch {
                print("insert error")
            }
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

    // MARK: Whole entities will be removed
    func clearCityList(onSuccess: @escaping () -> Void) {
        setupCoreData(completionHandler: { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
            self.viewModel.getCityCoreData(compHandler: {
                self.viewModel.selectedCitiesArray.removeAll()
                print("deleted")
            })
            onSuccess()
        })
    }
    
    // MARK: Whole entities will be removed
    func clearUnitList(onSuccess: @escaping () -> Void) {
        setupCoreData(completionHandler: { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TempUnit")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
            self.viewModel.getCityCoreData(compHandler: {
                self.viewModel.selectedCitiesArray.removeAll()
                print("deleted")
            })
            onSuccess()
        })
    }
    
    // MARK: Selected entities will be removed
    func removeSelectedCity(index: Int, onSuccess: @escaping () -> Void, onError: @escaping ()-> Void) {
        setupCoreData(completionHandler: { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
            self.viewModel.getCityCoreData(compHandler: {
                var willRemoveItemOfArray = self.viewModel.selectedCitiesArray
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

extension CoreDataOperations {
    func setupCoreData(completionHandler: @escaping (NSManagedObjectContext) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        completionHandler(context)
    }
}

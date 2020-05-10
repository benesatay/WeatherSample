//
//  CoreDataViewController+Extensions.swift
//  WeatherSample
//
//  Created by Bahadır Enes Atay on 10.05.2020.
//  Copyright © 2020 Bahadır Enes Atay. All rights reserved.
//

import UIKit
import CoreData

extension CoreDataManager {
    func setupCoreData(completionHandler: @escaping (NSManagedObjectContext) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        completionHandler(context)
    }
    
    func setupObjectInserting(value: Any?, forEntityName: String, forKey: String) {
        setupCoreData(completionHandler: { (context) in
            let newEntity = NSEntityDescription.insertNewObject(forEntityName: forEntityName, into: context)
            newEntity.setValue(value, forKey: forKey)
            do {
                try context.save()
            } catch {
                print("insert error")
            }
        })
    }
    
    func setupRemovingWholeEntities(entityName: String, onSuccess: @escaping () -> Void) {
        setupCoreData(completionHandler: { (context) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                try context.execute(deleteRequest)
                try context.save()
                onSuccess()
            } catch {
                print ("There was an error")
            }
        })
    }
}

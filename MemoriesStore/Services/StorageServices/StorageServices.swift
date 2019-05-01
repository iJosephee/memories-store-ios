//
//  StorageServices.swift
//  MemoriesStore
//
//  Created by Arnold Giuseppe Dominguez Eusebio on 4/30/19.
//  Copyright © 2019 Arnold Giuseppe Dominguez Eusebio. All rights reserved.
//

import Foundation
import CoreData

protocol MarketActions: class {
    func saveProduct(_ code: String, name: String, price: Double, counter: Int)
    func deleteItems(_ code: String, counter: Int) -> Bool
    func fetchItems() -> [CartItem]
}

/**
 This class is in charge of retrieving the data from CoreData.
 */

class StorageServices {
    public static let shared = StorageServices()
    
    // MARK: Core Data Methods
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Memories")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension StorageServices: MarketActions {
    
    func saveProduct(_ code: String, name: String, price: Double, counter: Int) {
        let formatCounter: Int32 = Int32(counter)
        let items = fetchItems()
        var alreadySaved = false
        for item in items {
            if code == item.code {
                alreadySaved = true
            }
        }
        let managedContext = self.persistentContainer.viewContext
        if alreadySaved {
            for item in items where item.code == code {
                item.counter += formatCounter
            }
        } else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "CartItem", into: managedContext) as! CartItem
            item.code = code
            item.name = name
            item.price = price
            item.counter = formatCounter
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func fetchItems() -> [CartItem] {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CartItem>(entityName: "CartItem")
        var items: [CartItem] = []
        do {
            items = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return items
    }
    
    func deleteItems(_ code: String, counter: Int) -> Bool {
        let managedContext = self.persistentContainer.viewContext
        let objects = fetchItems()
        for obj in objects where obj.code == code {
            managedContext.delete(obj)
        }
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            return false
        }
    }
    
}

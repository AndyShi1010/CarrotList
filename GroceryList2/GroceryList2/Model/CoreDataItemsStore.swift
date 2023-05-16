//
//  CoreDataStore.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 5/8/23.
//

import Foundation
import CoreData

protocol ItemStore {
    func fetch() -> [GroceryItem]
    func save(item: GroceryItem)
    func delete(item: GroceryItem)
    func update(item: GroceryItem)
}

struct CoreDataItemsStore: ItemStore {
    
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Groceries")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("DB error")
            }
        }
        return container
    }()
    
    func fetch() -> [GroceryItem] {
        print("FETCH")
        let managedContext = CoreDataItemsStore.persistentContainer.viewContext

        let fetchRequest = GroceryItemEntity.fetchRequest()

        do{
            let dbitems: [GroceryItemEntity] = try managedContext.fetch(fetchRequest)
            let groceryItems = dbitems.compactMap({(i:GroceryItemEntity) -> GroceryItem? in
                return GroceryItem(i)
            })
        } catch {
            print("Error fetching: \(error)");
            return []
        }
        return []
    }
    
    func save(item: GroceryItem) {
        print("SAVE")
        let managedContext = CoreDataItemsStore.persistentContainer.viewContext
        let _ = GroceryItemEntity(context: managedContext, item: item)
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    
    func delete(item: GroceryItem) {
        
    }
    
    func update(item: GroceryItem) {
        
    }
    
}


extension GroceryItemEntity {
    convenience init(context: NSManagedObjectContext, item: GroceryItem) {
        self.init(context: context)
        name = item.name
        currentPricePerUnit = item.price
        let jsonEncoder = JSONEncoder()
        priceHistory = String(data: try! jsonEncoder.encode(item.priceHistory), encoding: String.Encoding.utf8)
//        print(priceHistory)
//        priceHistory = item.priceHistory
    }
}

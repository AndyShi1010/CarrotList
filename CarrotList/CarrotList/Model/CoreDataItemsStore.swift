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
//    func update(item: GroceryItem)
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
        let managedContext = CoreDataItemsStore.persistentContainer.viewContext

        let fetchRequest = GroceryItemEntity.fetchRequest()

        do{
            print("FETCH")
            let dbitems: [GroceryItemEntity] = try managedContext.fetch(fetchRequest)
            print(dbitems)
            let groceryItems = dbitems.compactMap({(i:GroceryItemEntity) -> GroceryItem? in
                GroceryItem(i)
            })
            return groceryItems
        } catch {
            print("Error fetching: \(error)");
            return []
        }
        return []
    }
    
    func save(item: GroceryItem) {
        let managedContext = CoreDataItemsStore.persistentContainer.viewContext
        let _ = GroceryItemEntity(context: managedContext, item: item)
        do {
            try managedContext.save()
        } catch { }
    }
    
    func delete(item: GroceryItem) {
        let managedContext = CoreDataItemsStore.persistentContainer.viewContext
        let fetchRequest = GroceryItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id.uuidString)
        do {
            guard let item = try managedContext.fetch(fetchRequest).first else {
                return
            }
            managedContext.delete(item)
//            for i in items {
//                managedContext.delete(i)
//            }
            try managedContext.save()
        } catch {
            print("Error deleting: \(error)")
        }
    }
    
    func pushNewPrice(item: GroceryItem, newPrice: Double) {
        let managedContext = CoreDataItemsStore.persistentContainer.viewContext
        let fetchRequest = GroceryItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id.uuidString)
        do {
            guard let item = try managedContext.fetch(fetchRequest).first,
              var groceryItem = GroceryItem(item)
            else {
                return
            }
            groceryItem.priceHistory[Date()] = newPrice
            groceryItem.price = newPrice
            managedContext.delete(item)
            try managedContext.save()
            let _ = GroceryItemEntity(context: managedContext, item: groceryItem)
            try managedContext.save()
        } catch {
            print("Error updating: \(error)")
        }
    }
    
    func fetchItem(id: UUID) -> GroceryItem? {
        let managedContext = CoreDataItemsStore.persistentContainer.viewContext
        let fetchRequest = GroceryItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            guard let item = try managedContext.fetch(fetchRequest).first,
                var groceryItem = GroceryItem(item)
            else {
                return nil
            }
            return groceryItem
        } catch {
            print("Error updating: \(error)")
        }
        return nil
    }
    
}


extension GroceryItemEntity {
    convenience init(context: NSManagedObjectContext, item: GroceryItem) {
        self.init(context: context)
        id = item.id.uuidString
        name = item.name
        currentPricePerUnit = item.price
        let jsonEncoder = JSONEncoder()
        priceHistory = String(data: try! jsonEncoder.encode(item.priceHistory), encoding: String.Encoding.utf8)
        attributes = String(data: try! jsonEncoder.encode(item.attributes), encoding: String.Encoding.utf8)
//        print(priceHistory)
//        priceHistory = item.priceHistory
    }
}

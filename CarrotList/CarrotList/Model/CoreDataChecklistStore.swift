//
//  CoreDataStore.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 5/8/23.
//

import Foundation
import CoreData

protocol ChecklistStore {
    func fetch() -> [Checklist]
    func save(item: Checklist)
    func delete(item: Checklist)
//    func update(item: GroceryItem)
}

struct CoreDataChecklistStore: ChecklistStore {
    
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Groceries")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("DB error")
            }
        }
        return container
    }()
    
    func fetch() -> [Checklist] {
        let managedContext = CoreDataChecklistStore.persistentContainer.viewContext

        let fetchRequest = ChecklistEntity.fetchRequest()

        do{
            print("FETCH CHEKCLIST")
            let dbitems: [ChecklistEntity] = try managedContext.fetch(fetchRequest)
//            print(dbitems)
            let checklistItems = dbitems.compactMap({(i:ChecklistEntity) -> Checklist? in
                Checklist(i)
            })
            return checklistItems
        } catch {
            print("Error fetching: \(error)");
            return []
        }
        return []
    }
    
    func save(item: Checklist) {
        let managedContext = CoreDataChecklistStore.persistentContainer.viewContext
        let _ = ChecklistEntity(context: managedContext, checklist: item)
        do {
            try managedContext.save()
        } catch { }
    }
    
    func delete(item: Checklist) {
        let managedContext = CoreDataChecklistStore.persistentContainer.viewContext
        let fetchRequest = ChecklistEntity.fetchRequest()
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
    
    func pushNewPrice(item: Checklist, newPrice: Double) {
//        let managedContext = CoreDataItemsStore.persistentContainer.viewContext
//        let fetchRequest = GroceryItemEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id.uuidString)
//        do {
//            guard let item = try managedContext.fetch(fetchRequest).first,
//              var groceryItem = GroceryItem(item)
//            else {
//                return
//            }
//            groceryItem.priceHistory[Date()] = newPrice
//            groceryItem.price = newPrice
//            managedContext.delete(item)
//            try managedContext.save()
//            let _ = GroceryItemEntity(context: managedContext, item: groceryItem)
//            try managedContext.save()
//        } catch {
//            print("Error updating: \(error)")
//        }
    }
    
//    func fetchItem(id: UUID) -> GroceryItem? {
//        let managedContext = CoreDataItemsStore.persistentContainer.viewContext
//        let fetchRequest = GroceryItemEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
//        do {
//            guard let item = try managedContext.fetch(fetchRequest).first,
//                var groceryItem = GroceryItem(item)
//            else {
//                return nil
//            }
//            return groceryItem
//        } catch {
//            print("Error updating: \(error)")
//        }
//        return nil
//    }
    
}


extension ChecklistEntity {
    convenience init(context: NSManagedObjectContext, checklist: Checklist) {
        self.init(context: context)
        id = checklist.id.uuidString
        name = checklist.name
//        print(priceHistory)
//        priceHistory = item.priceHistory
    }
}

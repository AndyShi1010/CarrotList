//
//  ItemImage.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 5/9/23.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var currentPricePerUnit: Double
    @NSManaged public var icon: Image?
    @NSManaged public var name: String?
    @NSManaged public var priceHistory: NSObject?
    @NSManaged public var relationship: Shop?

}

extension Item : Identifiable {

}

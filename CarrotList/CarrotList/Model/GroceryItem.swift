//
//  Item.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 5/8/23.
//

import Foundation
import UIKit

struct GroceryItem: Hashable, Identifiable {
    var id = UUID()
    let name: String
    var price: Double
    var priceHistory: [Date: Double]
    let attributes: [String]
//    let icon: UIImage
}

extension GroceryItem {
    init?(_ groceryItemEntity: GroceryItemEntity) {
        guard
            let uuid = UUID(uuidString: groceryItemEntity.id ?? ""),
            let name = groceryItemEntity.name,
            let priceHistoryData = groceryItemEntity.priceHistory?.data(using: .utf8),
            let priceHistory = try? JSONDecoder().decode([Date: Double].self, from: priceHistoryData),
            let attributesData = groceryItemEntity.attributes?.data(using: .utf8),
            let attributes = try? JSONDecoder().decode([String].self, from: attributesData)
//            let icon = groceryItemEntity.icon
        else {
            return nil
        }
        let price = groceryItemEntity.currentPricePerUnit
        self = GroceryItem(id: uuid, name: name, price: price, priceHistory: priceHistory, attributes: attributes)
    }
    
    init() {
        self = GroceryItem(id: UUID(), name: "", price: 0, priceHistory: [Date(): 0], attributes: [])
    }
}

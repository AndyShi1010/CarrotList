//
//  Item.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 5/8/23.
//

import Foundation
import UIKit

struct GroceryItem: Hashable {
    let name: String
    let price: Double
    let priceHistory: [Date: Double]
//    let icon: UIImage
}

extension GroceryItem {
    init?(_ groceryItemEntity: GroceryItemEntity) {
        guard
            let name = groceryItemEntity.name,
            let priceHistoryData = groceryItemEntity.priceHistory?.data(using: .utf8),
            let priceHistory = try? JSONDecoder().decode([Date: Double].self, from: priceHistoryData)
//            let icon = groceryItemEntity.icon
        else {
            return nil
        }
        let price = groceryItemEntity.currentPricePerUnit
        self = GroceryItem(name: name, price: price, priceHistory: priceHistory)
    }
}

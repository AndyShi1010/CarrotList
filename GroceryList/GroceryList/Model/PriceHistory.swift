//
//  DateHistory.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 5/11/23.
//

import Foundation

public class PriceHistory: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    var history: [Date: Double]
    
    init(history: [Date: Double]) {
        self.history = history
    }
    
    public func encode(with coder: NSCoder) {
        do {
            let historyData = try! JSONEncoder().encode(history)
            coder.encode(historyData, forKey: "history")
        } catch {
            print(error)
        }
    }
    
    public required init?(coder: NSCoder) {
        guard let historyData = coder.decodeObject(forKey: "history") as? Data,
              let history = try? JSONDecoder().decode([Date: Double].self, from: historyData)
        else {
            return nil
        }
        self.history = history
    }
}


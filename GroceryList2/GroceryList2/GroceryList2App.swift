//
//  GroceryList2App.swift
//  GroceryList2
//
//  Created by JPL-ST-SPRING2022 on 5/15/23.
//

import SwiftUI

@main
struct GroceryList2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

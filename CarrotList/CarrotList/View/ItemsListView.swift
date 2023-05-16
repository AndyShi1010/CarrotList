//
//  HomeView.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 4/17/23.
//

import SwiftUI

struct ItemsListEntry: View {
    
    let groceryItem: GroceryItem
    
    init(_ groceryItem: GroceryItem) {
        self.groceryItem = groceryItem
        _itemPrice = State(initialValue: "")
    }
    
    @State
    private var itemPrice: String
    
    var body: some View {
        HStack{
            Image(systemName: "carrot.fill")
            Text(groceryItem.name)
                .bold()
            Spacer()
            Text(itemPrice)
        }
        .onAppear {
            guard let formattedPrice = formatAsCurrency(groceryItem.price) else {
                return
            }
            itemPrice = formattedPrice
        }
    }
    
    func formatAsCurrency(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let number = NSNumber(value: value)
        return formatter.string(from: number)
    }
}

struct ItemsListView: View {
    
    private let store: CoreDataItemsStore = CoreDataItemsStore()
    
    @State
    private var items: [GroceryItem] = []
    
    @State
    private var showAddItemView = false

    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(items, id: \.name) { item in
                        ItemsListEntry(item)
                    }
//                    ItemsListEntry()
                }
                .onAppear {
                    items = store.fetch()
                }
                .padding(.top, 16)
            }
            .navigationTitle("Items")
            .navigationBarItems(trailing:
                Button(action: {
                    showAddItemView = true
                }, label: {
                    Image(systemName: "plus")
                    Text("Add Item")
                })
            )
            .sheet(isPresented: $showAddItemView, content: {
                AddItemView(showSheet: $showAddItemView) {
                    items = store.fetch()
                }
            })
        }
    }
    
    
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListView()
    }
}

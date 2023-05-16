//
//  ItemDetailsView.swift
//  CarrotList
//
//  Created by JPL-ST-SPRING2022 on 5/15/23.
//

import SwiftUI

struct UpdatePriceView: View {
    
    @Binding var showSheet: Bool
    
    var body: some View {
        Text("Hello World")
    }
}

struct ItemDetailsView: View {
    
    let item: GroceryItem
    
    private let store: CoreDataItemsStore = CoreDataItemsStore()
    
    init(_ groceryItem: GroceryItem) {
        self.item = groceryItem
        _itemPrice = State(initialValue: "")
    }
    
    @State
    private var itemPrice: String
    
    @State
    private var showUpdatePriceView = false
    
    @State
    private var showDeleteItemView = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Text("\(item.id)")
            ScrollView(.horizontal) {
                HStack {
                    ForEach(item.attributes, id: \.self) { attr in
                        Text("\(attr)")
                        .padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .background(.orange)
                        .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 24)
            HStack {
                Text("Current Price")
                Spacer();
                Text(itemPrice)
                .bold()
            }
            .padding(24)
            VStack {
                Button(action: {
                    showUpdatePriceView = true
                }, label: {
                    Image(systemName: "plus")
                    Text("Update Price")
                })
                List {
                    ForEach(item.priceHistory.sorted(by: >), id: \.key) { date, price in
                        HStack {
                            Text(date, style: .date)
                            Spacer()
                            Text(formatAsCurrency(price) ?? "")
                        }
                    }
                       
                }
            }
            
        }
        .onAppear {
            guard let formattedPrice = formatAsCurrency(item.price) else {
                return
            }
            itemPrice = formattedPrice
        }
        .navigationTitle("\(item.name)")
        .navigationBarItems(trailing:
            Button(action: {
                showDeleteItemView = true
            }, label: {
                Image(systemName: "trash")
            })
            .confirmationDialog("Are you sure you want to delete this item?",
                 isPresented: $showDeleteItemView) {
                 Button("Delete item?", role: .destructive) {
                     store.delete(item: item)
                     presentationMode.wrappedValue.dismiss()
                 }
            } message: {
                Text("Are you sure you want to delete this item?")
            }
                            
        )
        .sheet(isPresented: $showUpdatePriceView) {
            UpdatePriceView(showSheet: $showUpdatePriceView)
            .presentationDetents([.height(200)])
        }
    }
    
    func formatAsCurrency(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let number = NSNumber(value: value)
        return formatter.string(from: number)
    }
}

//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}

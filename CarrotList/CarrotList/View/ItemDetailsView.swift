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

struct DeleteItemView: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        
    }
}

struct ItemDetailsView: View {
    let item: GroceryItem
    
    init(_ groceryItem: GroceryItem) {
        self.item = groceryItem
        _itemPrice = State(initialValue: "")
    }
    
    @State
    private var itemPrice: String
    
    @State
    private var showUpdatePriceView = false
    
    var body: some View {
        VStack{
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
                
            }, label: {
                Image(systemName: "trash")
            })
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

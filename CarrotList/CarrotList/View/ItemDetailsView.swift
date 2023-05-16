//
//  ItemDetailsView.swift
//  CarrotList
//
//  Created by JPL-ST-SPRING2022 on 5/15/23.
//

import SwiftUI
import Charts

struct UpdatePriceView: View {
    
    let item: GroceryItem
    
    private let store: CoreDataItemsStore = CoreDataItemsStore()
    
    @Binding var showSheet: Bool
    
    let refresh: () -> Void
    
    @State private var dollars: Int = 0
    @State private var cents: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section("Price") {
                    VStack {
                        HStack{
                            Text("Price")
                            Spacer()
                            Text(formatAsCurrency(dollars, cents) ?? "")
                        }
                        
                        HStack {
                            VStack {
                                Picker(selection: $dollars, label: Text("Dollars")) {
                                    ForEach(0..<100) { dollar in
                                        Text("\(dollar)")
                                    }
                                }.pickerStyle(.wheel)
                            }
                            Text(".")
                            VStack {
                                Picker(selection: $cents, label: Text("Cents")) {
                                    ForEach(0..<100) { cent in
                                        Text("\(cent)")
                                    }
                                }.pickerStyle(.wheel)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Update Price", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Discard") {
                        showSheet = false;
                    },
                trailing:
                    Button("Save") {
                        let priceDouble: Double = Double(dollars) + Double(Double(cents) / 100)
                        store.pushNewPrice(item: item, newPrice: priceDouble)
                        refresh()
                        showSheet = false;
                    }
            )
        }
    }
}

struct ItemDetailsView: View {

    
    private let store: CoreDataItemsStore = CoreDataItemsStore()
    
    init(_ id: UUID) {
        self.itemID = id
        _itemPrice = State(initialValue: "")
        _item = State(initialValue: GroceryItem())
    }
    
    let itemID: UUID
    
    @State
    private var item: GroceryItem
    
    @State
    private var itemPrice: String
    
    @State
    private var showUpdatePriceView = false
    
    @State
    private var showDeleteItemView = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
//            Text("\(item.id)")
            ScrollView(.horizontal) {
                HStack {
                    ForEach(item.attributes, id: \.self) { attr in
                        Text("\(attr)")
                        .padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .background(.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
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
                    Image(systemName: "square.and.pencil")
                    Text("Update Price")
                })
                VStack {
                    Chart {
                        ForEach(item.priceHistory.sorted(by: >), id: \.key) { date, price in
                            LineMark(
                                x: .value("Date", date),
                                y: .value("Price", price)
                            )
                        }
                    }
                    .frame(height: 100)
                    .padding(16)
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
            
        }
        .onAppear {
            guard let updatedItem = store.fetchItem(id: itemID ) else {
                return
            }
            item = updatedItem
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
            UpdatePriceView(item: item, showSheet: $showUpdatePriceView, refresh: {
                guard let updatedItem = store.fetchItem(id: itemID) else {
                    return
                }
                item = updatedItem
                guard let formattedPrice = formatAsCurrency(item.price) else {
                    return
                }
                itemPrice = formattedPrice
            })
            .presentationDetents([.height(400)])
        }
    }
    
}

func formatAsCurrency(_ value: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.currency
    let number = NSNumber(value: value)
    return formatter.string(from: number)
}

func formatAsCurrency(_ main: Int, _ cents: Int) -> String? {
    let price: Double = Double(main) + Double(Double(cents) / 100)
    print(price)
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.currency
    let number = NSNumber(value: price)
    return formatter.string(from: number)
}

//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}

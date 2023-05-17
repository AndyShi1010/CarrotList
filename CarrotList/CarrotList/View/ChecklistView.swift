//
//  ChecklistView.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 4/17/23.
//

import SwiftUI

struct ChecklistView: View {
    
    private let store: CoreDataChecklistStore = CoreDataChecklistStore()
    
    @State
    private var items: [Checklist] = []
    
    @State
    private var showAddListView = false
    
    @State
    private var showDeleteListView = false
    
    @State
    private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                if items.isEmpty {
                    Text("You have no checklists")
                } else {
                    List {
                        ForEach(items, id: \.self) { item in
//                            ChecklistSection(checklist: item)
                            Section(
                                header: Text(item.name),
                                footer:
                                    HStack {
                                        Button(action: {
                                            showDeleteListView = true
//                                            showAlert = true
                                        }, label: {
                                            Image(systemName: "trash")
                                        })
                                        .confirmationDialog("Are you sure you want to delete this checklist?",
                                             isPresented: $showDeleteListView) {
                                             Button("Delete list?", role: .destructive) {
                                                 store.delete(item: item)
                                                 items = store.fetch()
                                                 showDeleteListView = false
                                                 presentationMode.wrappedValue.dismiss()
                                             }
                                        } message: {
                                            Text("Are you sure you want to delete this checklist?")
                                        }
                                        Spacer()
                                        Button(action: {
//                                            showDeleteListView = true
                                            showAlert = true;
                                            
                                        }, label: {
                                            Image(systemName: "plus")
                                            Text("Add Item")
                                        })
                                        .alert(isPresented: $showAlert) {
                                            Alert(
                                                title: Text("Feature Unavailable"),
                                                message: Text("Feature has not been implemented yet.")
                                            )
                                        }
                                    }
                                    
                            )
                            {
                                Text("\(item.id)")
                                
                            }
                            
                        }
                    }
                }
            }
            .onAppear {
                items = store.fetch()
            }
            .navigationTitle("Checklist")
            .navigationBarItems(trailing:
                Button(action: {
                    showAddListView = true
                }, label: {
                    Image(systemName: "plus")
                    Text("Add List")
                })
            )
            .sheet(isPresented: $showAddListView, content: {
//                AddItemView(showSheet: $showAddItemView) {
//                    items = store.fetch()
//                }
                AddChecklistView(showSheet: $showAddListView)
                {
                    items = store.fetch()
                }
                .presentationDetents([.height(200)])
            })
        }
    }
}


struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
    }
}

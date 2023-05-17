//
//  AddChecklistView.swift
//  CarrotList
//
//  Created by JPL-ST-SPRING2022 on 5/16/23.
//

import SwiftUI

struct AddChecklistView: View {
    
    private let store: CoreDataChecklistStore = CoreDataChecklistStore()
    
    @Binding var showSheet: Bool
    @State private var listName: String = ""
    
    let refresh: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField("Name", text: $listName)
                }
            }
            .navigationBarTitle("Add Checklist", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Discard") {
                        showSheet = false;
                    },
                trailing:
                    Button("Save") {
                        store.save(item: Checklist(name: listName))
                        showSheet = false;
                        refresh()
                    }
                    .disabled(self.listName.isEmpty)
            )
        }
        .accentColor(.orange)
    }
}

//struct AddChecklistView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddChecklistView()
//    }
//}

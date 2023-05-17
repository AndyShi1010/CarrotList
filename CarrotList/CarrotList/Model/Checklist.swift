//
//  Checklist.swift
//  CarrotList
//
//  Created by JPL-ST-SPRING2022 on 5/16/23.
//

import Foundation

struct Checklist: Hashable, Identifiable {
    var id = UUID()
    let name: String
}

extension Checklist {
    init?(_ checklistEntity: ChecklistEntity) {
        guard
            let uuid = UUID(uuidString: checklistEntity.id ?? ""),
            let name = checklistEntity.name
        else {
            return nil
        }
        self = Checklist(id: uuid, name: name)
    }
    
}

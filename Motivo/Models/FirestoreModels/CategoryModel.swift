//
//  CategoryModel.swift
//  Motivo
//
//  Created by Aaron Lee on 3/19/25.
//

import Foundation
import FirebaseFirestore

struct CategoryModel: Hashable, Codable {
    @DocumentID var id: String!
    var name: String
    
    // Compare based on documentID `id`
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hash using id (guaranteed to be unique by Firestore)
    func hash(into hasher: inout Hasher) {
        guard let id = id else {
            assertionFailure("CategoryModel must have an ID before being used in a Set or Dictionary")
            return
        }
        hasher.combine(id)
    }
}

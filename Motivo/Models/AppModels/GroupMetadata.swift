//
//  GroupMetadata.swift
//  Motivo
//
//  Created by Arisyia Wong on 4/1/25.
//

import UIKit

struct GroupMetadata {
    var groupID: String
    var image: UIImage?  // Allow for nil and replace with 
    var groupName: String
    var categoryNames: [String]
    var memberCount: Int
    var habitsCount: Int
}

//
//  GroupModel.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//
import FirebaseFirestore

struct GroupModel: Codable {
    @DocumentID var id: String?
    var groupName: String
    // TODO: Add visibility field into model
//    var isGroupPublic: Bool
    var groupCode: String? // TODO: use groupID, later can generate code that expires
    var groupCategoryIDs: [String]
    var creatorUID: String // UID of user who created the group
    // creationTime
}

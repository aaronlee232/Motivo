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
    var groupImageURL: String?
    var isPublic: Bool
    var groupCode: String? // TODO: use groupID, later can generate code that expires
    var groupCategoryIDs: [String]
    var creatorUID: String
    // creationTime
}

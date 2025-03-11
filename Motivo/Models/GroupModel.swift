//
//  GroupModel.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

struct GroupModel: Codable {
    @DocumentID var id: String?
    var groupName: String
    var groupCode: String? // TODO: use groupID, later can generate code that expires
    var creator: String // user who created the group
    // creationTime
}

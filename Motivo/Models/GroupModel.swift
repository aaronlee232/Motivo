//
//  GroupModel.swift
//  Motivo
//
//  Created by Arisyia Wong on 3/10/25.
//

struct GroupModel: Codable {
    var groupID: String // id
    var groupName:String // name
    var groupCode: String? // TODO: use groupID, later can generate code that expires
    var creator: String // user who created the group
    // creationTime
}

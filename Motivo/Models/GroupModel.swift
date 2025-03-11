//
//  GroupModel.swift
//  Motivo
//
//  Created by Aaron Lee on 3/11/25.
//
import FirebaseFirestore

struct GroupModel: Codable {
    @DocumentID var id: String?
    var groupName: String
}

//
//  GroupMembership.swift
//  Motivo
//
//  Created by Aaron Lee on 3/11/25.
//
import FirebaseFirestore

struct GroupMembershipModel: Codable {
    @DocumentID var id: String?
    var groupID: String
    var userUID: String
}

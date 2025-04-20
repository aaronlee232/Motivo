//
//  VoteModel.swift
//  Motivo
//
//  Created by Aaron Lee on 4/18/25.
//

import FirebaseFirestore

enum VoteType: String, Codable {
    case accept
    case reject
}

struct VoteModel: Codable {
    @DocumentID var id: String?
    var voterUID: String
    var habitRecordID: String
    var photoURL: String
    var voteType: VoteType
    var timestamp: String
}

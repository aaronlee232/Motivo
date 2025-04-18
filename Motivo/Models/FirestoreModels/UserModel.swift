//
//  User.swift
//  Motivo
//
//  Created by Aaron Lee on 3/9/25.
//
import FirebaseFirestore

struct UserModel: Codable {
    @DocumentID var id: String!  // Firebase Authentication UID
    var username: String
    var email: String
//    var unverifiedPhotos: Int = 0
    var favoriteUsers: [String] = []
    var hiddenUsers: [String] = []
}

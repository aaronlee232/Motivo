//
//  User.swift
//  Motivo
//
//  Created by Aaron Lee on 3/9/25.
//

struct UserModel: Codable {
    var username: String
    var email: String
    var unverifiedPhotos: Int = 0
    var favoritesUsers: [String] = []
    var hiddenUsers: [String] = []
}

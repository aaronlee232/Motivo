//
//  UserSection.swift
//  Motivo
//
//  Created by Aaron Lee on 3/11/25.
//

struct UserSection {
    var sectionTitle: String
    var users: [UserModel]
    
    init(sectionTitle: String, users: [UserModel]) {
        self.sectionTitle = sectionTitle
        self.users = users
    }
}

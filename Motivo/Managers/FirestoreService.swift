//
//  FirestoreManager.swift
//  Motivo
//
//  Created by Aaron Lee on 3/20/25.
//

import FirebaseFirestore

class FirestoreService {
    // Singleton AuthManager
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    // Uses a User's UID to fetch their UserModel in FireStore
    func fetchUser(uid: String) async throws -> UserModel? {
        let document = try await db.collection(FirestoreCollection.user).document(uid).getDocument()
        
        guard document.exists else {
            print("User document does not exist in Firestore")
            return nil
        }
        
        print("retrieved user")
        
        return try document.data(as: UserModel.self)
    }
    
    // Inserts instance of UserModel into the 'user' collection in Firestore
    func insertUserData(user: UserModel) throws {
        let userDocument = db.collection(FirestoreCollection.user).document(user.id)
        try userDocument.setData(from: user)
    }
}

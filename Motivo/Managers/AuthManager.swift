//
//  AuthManager.swift
//  Motivo
//
//  Created by Aaron Lee on 3/9/25.
//
import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    // Singleton AuthManager
    static let shared = AuthManager()
    
    private init() {}
    
    func signInAsync(email:String, password:String) async throws -> AuthDataResult {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn( withEmail: email, password: password) {
                (authResult,error) in
                if let error = error {
                    continuation.resume(throwing: error) // Login failure. Resume with error
                } else if let authResult = authResult {
                    continuation.resume(returning: authResult) // Login success. Resume with AuthDataResult
                } else {
                    continuation.resume(throwing: NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."]))
                }
            }
        }
    }
    
    func registerAsync(email:String, password:String) async throws -> AuthDataResult {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().createUser(withEmail: email, password: password) {
                (authResult,error) in
                if let error = error {
                    continuation.resume(throwing: error) // Registration failure. Resume with error
                } else if let authResult = authResult {
                    continuation.resume(returning: authResult) // Registration success. Resume with AuthDataResult
                } else {
                    continuation.resume(throwing: NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."]))
                }
            }
        }
    }
    
    func resetPassword(email: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    // Inserts instance of UserModel into the 'user' collection in Firestore
    func insertUserDataAsync(user: UserModel) throws {
        let db = Firestore.firestore()
        let userDocument = db.collection("user").document(user.uid)
        
        do {
            try userDocument.setData(from: user)
//            print("Document successfully written!")
        } catch {
            throw error
            // TODO: Remove successful user registration if document insertion fails
//            let errorText = "\(error.localizedDescription)"
//            self.handleAuthAlerts(title: "User Document Insertion Error", message: errorText)
//            print("Error writing document: \(error)")
        }
    }
    
    func getCurrentUserAuthInstance () -> FirebaseAuth.User? {
        guard let user = Auth.auth().currentUser else { return nil }
        return user
    }
}

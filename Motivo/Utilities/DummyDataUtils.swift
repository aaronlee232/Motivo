//
//  DummyDataUtils.swift
//  Motivo
//
//  Created by Aaron Lee on 3/19/25.
//
import FirebaseFirestore

class DummyDataUtils {
    
    // Declaimer: generated by ChatGPT to generate connections list. Used for debugging only
    // TODO: remove later after finishing social feature implementations
    func populateConnections() {
        print("populate")
        let db = Firestore.firestore()
        let userCollection = db.collection(FirestoreCollection.user)
        let groupCollection = db.collection(FirestoreCollection.group)
        let groupMembershipCollection = db.collection(FirestoreCollection.groupMembership)

        let testUserUID = AuthManager.shared.getCurrentUserAuthInstance()!.uid

        // List of users to create
        let users = [
            UserModel(id: "randomUID1", username: "A1Test", email: "a1test@gmail.com"),
            UserModel(id: "randomUID2", username: "A2Test", email: "a2test@gmail.com"),
            UserModel(id: "randomUID3", username: "B1Test", email: "b1test@gmail.com"),
            UserModel(id: "randomUID4", username: "F1Test", email: "f1test@gmail.com")
        ]

        let userUIDs = users.map { $0.id }
        
        // Step 1: Delete users if they already exist
        userCollection.whereField("uid", in: userUIDs as [Any]).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching existing users: \(error.localizedDescription)")
                return
            }

            let batch = db.batch()
            
            // Delete existing users
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }

            // Commit deletion
            batch.commit { error in
                if let error = error {
                    print("Error deleting users: \(error.localizedDescription)")
                    return
                }

                // Step 2: Add users back
                let newBatch = db.batch()
                var addedUserIDs: [String] = []

                for user in users {
                    let userRef = userCollection.document(user.id)
                    do {
                        try newBatch.setData(from: user, forDocument: userRef)
                        addedUserIDs.append(userRef.documentID)
                    } catch {
                        print("Error encoding user \(user.username): \(error)")
                    }
                }

                newBatch.commit { error in
                    if let error = error {
                        print("Error adding new users: \(error.localizedDescription)")
                        return
                    }

                    print("Users added successfully!")

                    // Step 3: Modify the existing user document
                    let targetUserDocRef = userCollection.document(testUserUID)
                    targetUserDocRef.updateData([
//                        "favoriteUsers": addedUserIDs
                        "favoriteUsers": "randomUID4"
                    ]) { error in
                        if let error = error {
                            print("Error updating favoriteUsers: \(error.localizedDescription)")
                        } else {
                            print("Successfully updated favoriteUsers!")
                        }

                        // Step 4: Create groups
                        self.createGroupsAndAssignUsers(
                            db: db,
                            groupCollection: groupCollection,
                            groupMembershipCollection: groupMembershipCollection,
                            users: users,
                            testUserUID: testUserUID
                        )
                    }
                }
            }
        }
    }

    func createGroupsAndAssignUsers(
        db: Firestore,
        groupCollection: CollectionReference,
        groupMembershipCollection: CollectionReference,
        users: [UserModel],
        testUserUID: String
    ) {
        let group1 = GroupModel(
            id: nil,
            groupName: "Group Alpha",
            isPublic: true,
            groupCode: UUID().uuidString.prefix(6).description,
            groupCategoryIDs: [],
            creatorUID: UUID().uuidString
        )

        let group2 = GroupModel(
            id: nil,
            groupName: "Group Beta",
            isPublic: true,
            groupCode: UUID().uuidString.prefix(6).description,
            groupCategoryIDs: [],
            creatorUID: UUID().uuidString
        )

        let groupNames = ["Group Alpha", "Group Beta"]

        // Delete existing groups
        groupCollection.whereField("groupName", in: groupNames).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching existing groups: \(error.localizedDescription)")
                return
            }

            let batch = db.batch()
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }

            batch.commit { error in
                if let error = error {
                    print("Error deleting groups: \(error.localizedDescription)")
                    return
                }

                // Step 5: Add new groups
                let newBatch = db.batch()
                let group1Ref = groupCollection.document()
                let group2Ref = groupCollection.document()

                do {
                    try newBatch.setData(from: group1, forDocument: group1Ref)
                    try newBatch.setData(from: group2, forDocument: group2Ref)
                } catch {
                    print("Error encoding groups: \(error)")
                    return
                }

                newBatch.commit { error in
                    if let error = error {
                        print("Error adding groups: \(error.localizedDescription)")
                        return
                    }

                    print("Groups added successfully!")

                    // Step 6: Assign users to groups
                    let groupMembershipBatch = db.batch()

                    for (index, user) in users.enumerated() {
                        let assignedGroupRef = index % 2 == 0 ? group1Ref : group2Ref
                        let membership = GroupMembershipModel(
                            id: nil,
                            groupID: assignedGroupRef.documentID,
                            userUID: user.id
                        )

                        let membershipRef = groupMembershipCollection.document()
                        do {
                            try groupMembershipBatch.setData(from: membership, forDocument: membershipRef)
                        } catch {
                            print("Error encoding membership for \(user.username): \(error)")
                        }
                    }

                    // Step 7: Add test user to both groups
                    let testMembership1 = GroupMembershipModel(
                        id: nil,
                        groupID: group1Ref.documentID,
                        userUID: testUserUID
                    )

                    let testMembership2 = GroupMembershipModel(
                        id: nil,
                        groupID: group2Ref.documentID,
                        userUID: testUserUID
                    )

                    let testMembership1Ref = groupMembershipCollection.document()
                    let testMembership2Ref = groupMembershipCollection.document()

                    do {
                        try groupMembershipBatch.setData(from: testMembership1, forDocument: testMembership1Ref)
                        try groupMembershipBatch.setData(from: testMembership2, forDocument: testMembership2Ref)
                    } catch {
                        print("Error encoding test user memberships: \(error)")
                    }

                    groupMembershipBatch.commit { error in
                        if let error = error {
                            print("Error adding group memberships: \(error.localizedDescription)")
                        } else {
                            print("Group memberships added successfully!")
                        }
                    }
                }
            }
        }
    }
}

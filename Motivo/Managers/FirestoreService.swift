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
    let userCollectionRef:CollectionReference
    let groupCollectionRef:CollectionReference
    let groupMembershipCollectionRef:CollectionReference
    let categoryCollectionRef:CollectionReference
    let habitCollectionRef: CollectionReference
    let habitRecordCollectionRef: CollectionReference
    let voteCollectionRef: CollectionReference
    
    init() {
        userCollectionRef = db.collection(FirestoreCollection.user)
        groupCollectionRef = db.collection(FirestoreCollection.group)
        groupMembershipCollectionRef = db.collection(FirestoreCollection.groupMembership)
        categoryCollectionRef = db.collection(FirestoreCollection.category)
        habitCollectionRef = db.collection(FirestoreCollection.habit)
        habitRecordCollectionRef = db.collection(FirestoreCollection.habitRecord)
        voteCollectionRef = db.collection(FirestoreCollection.vote)
    }
    
    enum FirestoreError: Error {
        case multipleMembershipsFound
    }
}

// MARK: - user collection
extension FirestoreService {    
    // Convenience: retrieves a single user by UID
    func fetchUser(forUserUID userUID: String) async throws -> UserModel? {
        return try await fetchUsers(forUserUIDs: [userUID]).first
    }
    
    // Retrieves a list of users for a list of user UIDs
    func fetchUsers(forUserUIDs userUIDs: [String]) async throws -> [UserModel] {
        let snapshot = try await userCollectionRef
            .whereField(FieldPath.documentID(), in: Array(userUIDs))
            .getDocuments()

        return try snapshot.documents.map { document in
            try document.data(as: UserModel.self)
        }
    }
    
    // Inserts instance of UserModel into the 'user' collection in Firestore
    func addUser(user: UserModel) throws {
        let userDocument = userCollectionRef.document(user.id)
        try userDocument.setData(from: user)
    }
}

// MARK: - group collection
extension FirestoreService {
    // Convenience: retrieves a single group by group ID
    func fetchGroup(withGroupID groupID: String) async throws -> GroupModel? {
        return try await fetchGroups(withGroupIDs: [groupID]).first
    }
    
    // Retrieves a list of groups for a list of group IDs
    func fetchGroups(withGroupIDs groupIDs: [String]) async throws -> [GroupModel] {
        let snapshot = try await groupCollectionRef
            .whereField(FieldPath.documentID(), in: groupIDs)
            .getDocuments()

        return try snapshot.documents.map { document in
            try document.data(as: GroupModel.self)
        }
    }
    
    // Retrieves a list of groups with a list of categories
    func fetchGroups(withCategoryIDs categoryIDs: [String]) async throws -> [GroupModel] {
        // Preliminary "containsAny" filter. Used because firestore does not support "arrayContainsAll"
        let snapshot = try await groupCollectionRef
            .whereField("groupCategoryIDs", arrayContainsAny: categoryIDs)
            .getDocuments()
        
        print("preliminary groups (containsAny Categories): \(snapshot.documents)")
        
        // Final "containsAll" filter
        let categoryIDSet = Set(categoryIDs)
        let filteredDocuments = snapshot.documents.filter { document in
            if let categories = document.data()["groupCategoryIDs"] as? [String] {
                return Set(categories) == categoryIDSet
            }
            return false
        }
        print("final groups (containsAll Categories): \(filteredDocuments)")
        
        return try filteredDocuments.map { document in
            try document.data(as: GroupModel.self)
        }
    }
    
    // Inserts an instance of Group Model into the 'group' collection in Firestore. Returns new group documentID
    func addGroup(group: GroupModel) throws -> String {
        return try groupCollectionRef.addDocument(from: group).documentID
    }
    
    // Remove the group document with groupID
    func deleteGroup(withGroupWithID groupID: String) async throws -> [GroupModel] {
        let snapshot = try await groupCollectionRef
            .whereField(FieldPath.documentID(), isEqualTo: groupID)
            .getDocuments()
        
        var deletedGroups: [GroupModel] = []
        
        for document in snapshot.documents {
            let group = try document.data(as: GroupModel.self)
            try await document.reference.delete()
            deletedGroups.append(group)
        }
        
        return deletedGroups
    }
    
    func updateGroup(withGroup group: GroupModel) throws {
        let recordDocument = groupCollectionRef.document(group.id!)
        try recordDocument.setData(from: group, merge: true)
    }

}

// MARK: - groupMembership collection
extension FirestoreService {
    // Fetches a unique GroupMembership document for a user and group pairing
    func fetchGroupMembership(forGroupID groupID: String, userUID: String) async throws -> GroupMembershipModel? {
        let snapshot = try await groupMembershipCollectionRef
            .whereField("groupID", isEqualTo: groupID)
            .whereField("userUID", isEqualTo: userUID)
            .getDocuments()
        
        let documents = snapshot.documents
        if documents.count > 1 {
            throw FirestoreError.multipleMembershipsFound
        }

        guard let document = documents.first else {
            return nil
        }

        return try document.data(as: GroupMembershipModel.self)
    }
    
    // Convenience: retrieves a list of memberships for a single user UID
    func fetchGroupMemberships(forUserUID userUID: String) async throws -> [GroupMembershipModel] {
        return try await fetchGroupMemberships(forUserUIDs: [userUID])
    }
    
    // Retrieves a list of memberships for a list of user UIDs
    func fetchGroupMemberships(forUserUIDs userUIDs: [String]) async throws -> [GroupMembershipModel] {
        let snapshot = try await groupMembershipCollectionRef
            .whereField("userUID", in: userUIDs)
            .getDocuments()

        return try snapshot.documents.map { document in
            try document.data(as: GroupMembershipModel.self)
        }
    }
    
    // Convenience: retrieves a list of memberships for a single group ID
    func fetchGroupMemberships(forGroupID groupID: String) async throws -> [GroupMembershipModel] {
        return try await fetchGroupMemberships(forGroupIDs: [groupID])
    }
    
    // Retrieves a list of memberships for a list of group IDs
    func fetchGroupMemberships(forGroupIDs groupIDs: [String]) async throws -> [GroupMembershipModel] {
        let snapshot = try await groupMembershipCollectionRef
            .whereField("groupID", in: groupIDs)
            .getDocuments()

        return try snapshot.documents.map { document in
            try document.data(as: GroupMembershipModel.self)
        }
    }
    
    // Inserts an instance of Group Membership Model into the group membership collection in Firestore
    func addGroupMembership(membership: GroupMembershipModel) throws {
        let groupMembershipDocument = groupMembershipCollectionRef.document()
        try groupMembershipDocument.setData(from: membership)
    }
    
    // Remove the group membership document that contains userUID and groupID
    func deleteGroupMembership(withUserUID userUID: String, withGroupWithID groupID: String) async throws -> [GroupMembershipModel] {
        let snapshot = try await groupMembershipCollectionRef
            .whereField("userUID", isEqualTo: userUID)
            .whereField("groupID", isEqualTo: groupID)
            .getDocuments()
        
        var deletedMemberships: [GroupMembershipModel] = []
        
        for document in snapshot.documents {
            let membership = try document.data(as: GroupMembershipModel.self)
            try await document.reference.delete()
            deletedMemberships.append(membership)
        }
        
        return deletedMemberships
    }
}


// MARK: - Category collection
extension FirestoreService {
    // Retrieves the list of all categories
    func fetchCategories() async throws -> [CategoryModel] {
        let snapshot = try await categoryCollectionRef
            .getDocuments()
        
        return try snapshot.documents.map { document in
            try document.data(as: CategoryModel.self)
        }
    }
    
    // Convenience: retrieves a category by categoryID
    func fetchCategory(withCategoryID: String) async throws -> CategoryModel? {
        return try await fetchCategories(withCategoryIDs: [withCategoryID]).first
    }
    
    // Retrieve a list of categories that are in the list of categoryIDs
    func fetchCategories(withCategoryIDs: [String]) async throws -> [CategoryModel] {
        let snapshot = try await categoryCollectionRef
            .whereField(FieldPath.documentID(), in: withCategoryIDs)
            .getDocuments()
        
        return try snapshot.documents.map { document in
            try document.data(as: CategoryModel.self)
        }
    }
}


// MARK: - Habit collection
extension FirestoreService {
    // Convenience: Fetch habits that match at least one of the specified categories for a single user
    func fetchHabits(forUserUID userUID: String, forCategoryIDs categoryIDs: [String]) async throws -> [HabitModel] {
        return try await fetchHabits(forUserUIDs: [userUID], forCategoryIDs: categoryIDs)
    }
    
    // Fetch habits that match at least one of the specified categories for all users
    func fetchHabits(forUserUIDs userUIDs: [String], forCategoryIDs categoryIDs: [String]) async throws -> [HabitModel] {
        let snapshot = try await habitCollectionRef
            .whereField("userUID", in: userUIDs)
            .whereField("categoryIDs", arrayContainsAny: categoryIDs)
            .getDocuments()
        
        return try snapshot.documents.map { document in
            try document.data(as: HabitModel.self)
        }
    }
    
    // Convenience: Fetch all habit documents of one userUID
    func fetchHabits(forUserUID userUID: String) async throws -> [HabitModel] {
        return try await fetchHabits(forUserUIDs: [userUID])
    }
    
    // Fetch all habit documents of specified userUIDs
    func fetchHabits(forUserUIDs userUIDs: [String]) async throws -> [HabitModel] {
        let snapshot = try await habitCollectionRef
            .whereField("userUID", in: userUIDs)
            .getDocuments()
        
        return try snapshot.documents.map { document in
            try document.data(as: HabitModel.self)
        }
    }
    
    func addHabit(habit: HabitModel) throws {
        let habitDocument = habitCollectionRef.document()
        try habitDocument.setData(from: habit)
    }
    
    func updateHabit(habit: HabitModel) throws {
        let habitDocument = habitCollectionRef.document(habit.id ?? "")
        try habitDocument.setData(from: habit, merge: true)
    }
    
    func deleteHabit(habitID: String) async throws {
        try await habitCollectionRef.document(habitID).delete()
    }
}

// MARK: - HabitRecord Collection
extension FirestoreService {
    // Convenience: Fetch habit record document with specified habit record id
    func fetchHabitRecord(forHabitRecordID habitRecordID: String) async throws -> HabitRecord? {
        let habitRecord = try await fetchHabitRecords(forHabitRecordIDs: [habitRecordID]).first
        return habitRecord
    }
    
    // Fetch all habit records documents of specified habit record ids
    func fetchHabitRecords(forHabitRecordIDs habitRecordIDs: [String]) async throws -> [HabitRecord] {
        let snapshot = try await habitRecordCollectionRef
            .whereField(FieldPath.documentID(), in: habitRecordIDs)
            .getDocuments()
        
        return try snapshot.documents.map { document in
            try document.data(as: HabitRecord.self)
        }
    }
    
    // Fetch all habit records for a given habit with the given habit id
    func fetchHabitRecords(forHabitID habitID: String) async throws -> [HabitRecord] {
        let snapshot = try await habitRecordCollectionRef
            .whereField("habitID", isEqualTo: habitID)
            .getDocuments()
        
        return try snapshot.documents.map { document in
            try document.data(as: HabitRecord.self)
        }
    }
    
    // Add new habit record
    func addHabitRecord(habitRecord: HabitRecord) async throws -> HabitRecord {
        let documentRef = try habitRecordCollectionRef.addDocument(from: habitRecord)
        let snapshot = try await documentRef.getDocument()
        return try snapshot.data(as: HabitRecord.self)
    }
    
    // Update habitRecord with given habit record
    func updateHabitRecord(withHabitRecord habitRecord: HabitRecord) throws {
        let recordDocument = habitRecordCollectionRef.document(habitRecord.id!)
        try recordDocument.setData(from: habitRecord, merge: true)
    }
}

// MARK: - Vote Collection
extension FirestoreService {
    func fetchVotes(forUserUID userUID: String) async throws -> [VoteModel] {
        let snapshot = try await voteCollectionRef
            .whereField("voterUID", isEqualTo: userUID)
            .getDocuments()
        
        return try snapshot.documents.map { document in
            try document.data(as: VoteModel.self)
        }
    }
    
    func addVote(vote: VoteModel) throws {
        let voteDocument = voteCollectionRef.document()
        try voteDocument.setData(from: vote)
    }
}

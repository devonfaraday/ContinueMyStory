//
//  FirebaseController.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/10/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    static let shared = FirebaseController()
    static let databaseRef = Database.database().reference()
    let db: Firestore = Firestore.firestore()
    static let storageRef = Storage.storage().reference()
    init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
}


protocol FirebaseType {
    var uid: String { get set }
    var collectionPathKey: String { get set }
    var documentData: JSONDictionary { get }
}

extension FirebaseController {
    
    func fetchAllDocuments(fromCollection collectionRef: String, completion: @escaping([JSONDictionary], Error?) -> Void) {
        let collectionRef = db.collection(collectionRef)
        collectionRef.getDocuments { (querySnapshot, error) in
            let documents: [JSONDictionary] = querySnapshot?.documents.compactMap({ $0.data() }) ?? []
            completion(documents, error)
        }
    }
    
    func fetchAllDocuments(fromCollection collectionRef: String, whereField field: String, isEqualTo: Any, completion: @escaping([JSONDictionary], Error?) -> Void) {
        let collectionRef = db.collection(collectionRef)
        collectionRef.whereField(field, isEqualTo: isEqualTo).getDocuments { (querySnapshot, error) in
            let documents: [JSONDictionary] = querySnapshot?.documents.compactMap({ $0.data() }) ?? []
            completion(documents, error)
        }
    }
   
    func fetchDocument(fromCollection collectionRef: String, withUID uid: String, completion: @escaping(JSONDictionary?, Error?) -> Void) {
        let docRef = db.collection(collectionRef).document(uid)
        docRef.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            } else if let document = document, document.exists,
                let documentData: JSONDictionary = document.data() {
                completion(documentData, nil)
            }
        }
    }
    
    func updateData(fromCollection collection: String, inDocument: String, newData: [AnyHashable: Any]) {
        let collectionRef = db.collection(collection).document(inDocument)
        collectionRef.updateData(newData)
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
    func signUp(withEmail email: String, password: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }
    }
    
    func checkAuthentication(completion: @escaping(Bool) -> Void) {
        completion(Auth.auth().currentUser != nil)
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}


extension FirebaseType {
    
    func saveToFirestore() {
        saveToFirestore { (success, error) in
            if let error = error {
                print(error)
            } else if success {
                print("Saved object in collection: \(self.collectionPathKey)")
            } else {
                print("failed to save object in collection: \(self.collectionPathKey)")
            }
        }
    }
    
    func saveToFirestore(completion: @escaping(_ success: Bool, Error?) -> Void) {
        let firebaseController: FirebaseController = FirebaseController()
        firebaseController.db.collection(collectionPathKey).document(uid).setData(documentData) { (error) in
            completion(error == nil, error)
        }
    }
    
    func update(completion: @escaping(_ success: Bool, Error?) -> Void) {
        let firebaseController: FirebaseController = FirebaseController()
        let document: DocumentReference = firebaseController.db.collection(collectionPathKey).document(uid)
        document.updateData(documentData) { (error) in
            completion(error == nil, error)
        }
    }
    
    func update() {
        update { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if success {
                print("Object successfully updated: \(self.collectionPathKey)")
            } else {
                print("Object failed to update: \(self.collectionPathKey)")
            }
        }
    }
    
    func delete() {
        let firebaseController: FirebaseController = FirebaseController()
        firebaseController.db.collection(collectionPathKey).document(uid).delete()
    }
}


//
//extension FirebaseType {
//
//    mutating func save() {
//        var newcollectionPathKey = FirebaseController.databaseRef.child(collectionPathKey)
//        if let identifier = identifier {
//            newcollectionPathKey = newcollectionPathKey.child(identifier)
//        } else {
//            newcollectionPathKey = newcollectionPathKey.childByAutoId()
//            self.identifier = newcollectionPathKey.key
//        }
//        newcollectionPathKey.updateChildValues(dictionaryCopy)
//    }
//
//    mutating func saveSnippet(storyIdentifier: String, storyCategory: StoryCategoryType) {
//        var newcollectionPathKey = FirebaseController.databaseRef.child("\(String.storiescollectionPathKey)/\(String.categorycollectionPathKey)/\(storyCategory.rawValue)/\(storyIdentifier)/\(collectionPathKey)")
//        if let identifier = identifier {
//            newcollectionPathKey = newcollectionPathKey.child(identifier)
//        } else {
//            newcollectionPathKey = newcollectionPathKey.childByAutoId()
//            self.identifier = newcollectionPathKey.key
//        }
//        newcollectionPathKey.updateChildValues(dictionaryCopy)
//    }
//
//
//    mutating func saveStory(toCategory category: StoryCategoryType) {
//        let catPath = category.rawValue
//        var newcollectionPathKey = FirebaseController.databaseRef.child("\(collectionPathKey)/\(String.categorycollectionPathKey)/\(catPath)")
//        if let identifier = identifier {
//            newcollectionPathKey = newcollectionPathKey.child(identifier)
//        } else {
//            newcollectionPathKey = newcollectionPathKey.childByAutoId()
//            self.identifier = newcollectionPathKey.key
//        }
//        newcollectionPathKey.updateChildValues(dictionaryCopy)
//    }
//
//
//    func delete() {
//        guard let identifier = identifier else { return }
//        FirebaseController.databaseRef.child(collectionPathKey).child(identifier).removeValue()
//    }
//}

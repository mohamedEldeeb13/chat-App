//
//  FirestoreManager.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import Foundation
import FirebaseFirestore

class FirestoreManager{
    
    static let shared = FirestoreManager()
    
    func FirestorReference (_ collectionReference: FCollectionRefernce) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func saveUserToFirestore(_ user: User){
        do {
            try FirestorReference(.User).document(user.id).setData(from: user)
        } catch  {
            print(error.localizedDescription)
        }
    }
    func downloadUserFormFirestore(userId: String){
        FirestorReference(.User).document(userId).getDocument { document, error in
            guard let userDecoument = document else{return}
            let result = Result{
                try? userDecoument.data (as: User.self)
            }
            switch result {
            case .success(let userObj):
                if let user = userObj {
                    UserDefaultManager.shared.saveUserLocally(user)
                }else{
                    print("No Document Found")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
//    func downlaodAllUsersFromFireStore(completion: @escaping (_ allUsers: [User]) -> (Void)){
//        var users: [User] = []
//        FirestorReference(.User).getDocuments { snapshot, error in
//            guard let documents = snapshot?.documents else{
//                print("no documents found")
//                return
//            }
//            let UserArray = documents.compactMap { snapshot -> User? in
//                return try? snapshot.data(as: User.self)
//            }
//            for user in UserArray{
//                if FirebaseAuthentication.shared.currntId != user.id{
//                    users.append(user)
//                }
//            }
//            completion(users)
//        }
//        
//    }
//    func downloadUsersFromFBWithID(usersId: [String], completion: @escaping (_ allUsers: [User]) -> (Void)){
//        var count = 0
//        var usersArray: [User] = []
//        for userId in usersId{
//            FirestorReference(.User).document(userId).getDocument { querySnapshot, error in
//                guard let document = querySnapshot else {return}
//                let user = try? document.data(as: User.self)
//                usersArray.append(user!)
//                count += 1
//                if count == usersId.count{
//                    completion(usersArray)
//                }
//            }
//        }
//    }
    
}




enum FCollectionRefernce: String{
    case User
    case Chat
    case Message
    case Typing
}

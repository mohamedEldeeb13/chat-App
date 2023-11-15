//
//  MessageManager.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 05/11/2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


enum MSGType: String{
    case text
    case photo
    case video
    case audio
    case location
    case date
}


class MessageManager {
    static let shared = MessageManager()
    var newMessageListener : ListenerRegistration!
    var updatedMessageListener: ListenerRegistration!
    
    let statusKey = "status"
    let readDateKey = "readDate"
    private init() {}
    
    // to add  messages to firestore
    func addMessagesToFirestore(_ message : LocalMessage , memberId : String) {
        do {
            try FirestoreManager.shared.FirestorReference(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    // to load old message if app is deleted and return used
    
    func getOldMessage(usedId documentId : String , chatId collectionId : String) {
        FirestoreManager.shared.FirestorReference(.Message).document(documentId).collection(collectionId).getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {return}
            var oldMessage = documents.compactMap { snapshot -> LocalMessage? in
                return try? snapshot.data(as: LocalMessage.self)
            }
            oldMessage.sort(by: {$0.date < $1.date})
            for message in oldMessage {
                RealmManager.shared.save(message)
            }
        }
    }
    
    
    // to listen for updates on new messages in firestore
    func listenForNewMessages(usedId documentId : String , chatId collectionId : String , lastmessage : Date ) {
        
        newMessageListener = FirestoreManager.shared.FirestorReference(.Message).document(documentId).collection(collectionId).whereField(MSGType.date.rawValue, isGreaterThan: lastmessage).addSnapshotListener({ (querySnapshot , error) in
            guard let snapshot = querySnapshot else {return}
            for change in snapshot.documentChanges {
                if change.type == .added {
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    switch result {
                    case .success(let success):
                        if let message = success {
                            if message.senderId != FirebaseAuthentication.shared.currntId {
                                RealmManager.shared.save(message)
                            }
                        }
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                    
                }
                
            }
        })
        
    }
    func removeNewMessageListener(){
        self.newMessageListener.remove()
        self.updatedMessageListener.remove()
        
    }
    
    func updateMessageStatus(_ message : LocalMessage , userId : String) {
        let value = [statusKey : readKey , readDateKey : Date()] as [String : Any]
        FirestoreManager.shared.FirestorReference(.Message).document(userId).collection(message.chatRoomId).document(message.id).updateData(value)
    }
    
    func listenForReadStatus(_ documentId : String , collectionId : String , compiletion: @escaping(_ updateMessage : LocalMessage)->(Void)) {
        updatedMessageListener = FirestoreManager.shared.FirestorReference(.Message).document(documentId).collection(collectionId).addSnapshotListener({ querySnapshot, error in
            guard let snapshot = querySnapshot else { return }
            for change in snapshot.documentChanges {
                if change.type == .modified {
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    switch result {
                    
                    case .success( let data):
                        if let message = data {
                            compiletion(message)
                        }
                    case .failure( let error):
                        print(error.localizedDescription)
                    }
                }
            }
        })
    }
    
    
    
}

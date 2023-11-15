//
//  outgoing.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 05/11/2023.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import Gallery


public let sendKey = "✔️"
public let readKey = "✔️✔️"

class Outgoing{
    
     func sendMessage(chatId : String , text : String? , photo : UIImage? , video : Video? , audio : String? , audioDuration : Float = 0.0 , location : String? ,memdersId : [String]){
        
        // 1. create local message from the data we have
        let currentUser = FirebaseAuthentication.shared.currentUser!
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.name
        message.senderInitials = String(currentUser.name.first!)
        message.date = Date()
        message.status = sendKey
        
        
        // 2. check message type
        if text != nil {
            sendText(message : message , text : text! , memberIds : memdersId)
        }
        if photo != nil {
            
            sendPhoto(message: message, photo: photo!, membersId: memdersId)
            
        }
        if video != nil {
            sendVideo(message: message, video: video!, memberIds: memdersId)
            
        }
        if location != nil {
            
            sendLocation(message: message, memberIds: memdersId)
            
        }
        if audio != nil {
            
        }
        
        
        // 3. save message locally
        // 4. save message to firestore
        // 5. upadte chat room
         ChatManager.shared.updateChatRooms(chatRoomId: chatId, lastMessage: message.message)
    }
    
    private func saveMessageToRealm(message: LocalMessage, memberIds: [String]){
        RealmManager.shared.save(message)
    }
    
    private func saveMessageToFirestor(message: LocalMessage, memberIds: [String]){
        for memberId in memberIds {
            MessageManager.shared.addMessagesToFirestore(message, memberId: memberId)
        }
    }
    private func sendText(message : LocalMessage , text : String , memberIds : [String]) {
        message.message = text
        message.type = MSGType.text.rawValue
        
        saveMessageToRealm(message: message, memberIds: memberIds)
        saveMessageToFirestor(message: message, memberIds: memberIds)
    }
    
    func sendPhoto(message : LocalMessage , photo : UIImage , membersId : [String]) {
        message.message = "Photo Message"
        message.type = MSGType.photo.rawValue
        
        let fileName = Date().stringDate()
        let fileDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".png"
        FileDocumentManager.shared.saveFileLocally(fileData: photo.jpegData(compressionQuality:0.6)! as NSData, fileName: fileName)
        FirebaseStorageManager.uploadImage(photo, directory: fileDirectory) { imageLink in
            if imageLink != nil {
                message.pictureUrl = imageLink!
                self.saveMessageToRealm(message: message, memberIds: membersId)
                self.saveMessageToFirestor(message: message, memberIds: membersId)
            }
        }
    }
    
    
    func sendVideo(message: LocalMessage, video: Video, memberIds: [String]){
        message.message = "Video Message"
        message.type = MSGType.video.rawValue
        
        let fileName = Date().stringDate()
        // to save part of video in photo folder to show it as photo
        let thumbnailDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".png"
        // to save video in video folder
        let videoDirectory = "MediaMessages/Video/" + "\(message.chatRoomId)" + "_\(fileName)" + ".mov"
        
        let editor = VideoEditor()
        editor.process(video: video) { video, tempPath in
            if let tempPath = tempPath {
                let thumbnail = FirebaseStorageManager.generateVideoThumbnail(url: tempPath)
                FileDocumentManager.shared.saveFileLocally(fileData: thumbnail.jpegData(compressionQuality: 0.7)! as NSData, fileName: fileName)
                FirebaseStorageManager.uploadImage(thumbnail, directory: thumbnailDirectory) { imageLink in
                    if imageLink != nil {
                        let videoData = NSData(contentsOfFile: tempPath.path)
                        FileDocumentManager.shared.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
                        FirebaseStorageManager.uploadVideo(videoData!, directory: videoDirectory) { videoLink in
                            message.videoUrl = videoLink ?? ""
                            message.pictureUrl = imageLink ?? ""
                            self.saveMessageToRealm(message: message, memberIds: memberIds)
                            self.saveMessageToFirestor(message: message, memberIds: memberIds)
                        }
                    }
                }
            }
        }
    }
    
    func sendLocation(message : LocalMessage , memberIds : [String]) {
        
        let currentLocation = LocationManager.shared.currentLocation
        message.message = "Location Message"
        message.type = MSGType.location.rawValue
        message.latitude = currentLocation?.latitude ?? 0.0
        message.longitude = currentLocation?.longitude ?? 0.0
        saveMessageToRealm(message: message, memberIds: memberIds)
        saveMessageToFirestor(message: message, memberIds: memberIds)
    }
    
    
    
}




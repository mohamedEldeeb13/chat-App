//
//  incoming.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 06/11/2023.
//

import Foundation
import MessageKit
import CoreLocation


class Incoming {
    
    var messageViewController: MessagesViewController
    init(messageViewController: MessagesViewController) {
        self.messageViewController = messageViewController
    }
    
    func createMKMessage(localMessage : LocalMessage) -> MkMessage {
        
        let mkMessage = MkMessage(message: localMessage)
        
        if localMessage.type == MSGType.photo.rawValue{
            let photoItem = PhotoMessage(path: localMessage.pictureUrl)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            FirebaseStorageManager.downloadImage(imageURL: localMessage.pictureUrl) { image in
                mkMessage.photoItem?.image = image
                self.messageViewController.messagesCollectionView.reloadData()
            }
        }
        
        if localMessage.type == MSGType.video.rawValue{
            FirebaseStorageManager.downloadImage(imageURL: localMessage.pictureUrl) { image in
                FirebaseStorageManager.downloadVideo(videoURL: localMessage.videoUrl) { readyToPlay, videoFileName in
                    let videoLink = URL(fileURLWithPath: FileDocumentManager.shared.getFilePath(fileName: videoFileName))
                    let videoItem = VideoMessage(url: videoLink)
                    
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    mkMessage.videoItem?.image = image
                    self.messageViewController.messagesCollectionView.reloadData()
                }
            }
        }
        
        if localMessage.type == MSGType.location.rawValue {
            let locationItem = LocationMessage(location: CLLocation(latitude: localMessage.latitude, longitude: localMessage.longitude))
            mkMessage.kind = MessageKind.location(locationItem)
            mkMessage.locationItem = locationItem
        }
        
        return mkMessage
        
    }
}

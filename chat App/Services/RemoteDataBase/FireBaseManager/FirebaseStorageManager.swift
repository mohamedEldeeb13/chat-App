//
//  FirebaseStorageManager.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import Foundation
import FirebaseStorage
import ProgressHUD
import UIKit
import AVFoundation

class FirebaseStorageManager{
    
    //    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ imageLink: String?) -> (Void)){
    //
    //        let folderPath = "gs://skytalk-1f580.appspot.com"
    //        let storage = Storage.storage()
    //
    //        let storageRef = storage.reference(forURL: folderPath).child(directory)
    //        let imageData = image.pngData()
    //        var task: StorageUploadTask!
    //        task = storageRef.putData(imageData!, completion: { storageMetaData, error in
    //            task.removeAllObservers()
    //            ProgressHUD.dismiss()
    //
    //            if error != nil{
    //                print("Error Uploading Image : " + error!.localizedDescription)
    //            }
    //            storageRef.downloadURL { url, error in
    //                guard let downloadUrl = url else{
    //                    completion(nil)
    //                    return
    //                }
    //                completion(downloadUrl.absoluteString)
    //            }
    //        })
    //        task.observe(StorageTaskStatus.progress) { snapshot in
    //            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
    //            ProgressHUD.showProgress(CGFloat(progress))
    //        }
    //    }
}

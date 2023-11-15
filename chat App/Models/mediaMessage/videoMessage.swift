//
//  videoMessage.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 11/11/2023.
//

import Foundation
import MessageKit

class VideoMessage: NSObject, MediaItem{
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(url: URL?){
        self.url = url
        self.placeholderImage = UIImage(systemName: "photo")!
        self.size = CGSize(width: 240, height: 240)
    }
}

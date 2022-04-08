//
//  ImagesHandler.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import SwiftUI

enum ImageHandlerMode {
    case na
    case loadImages
    case getDetails
}

protocol ImagesHandler {
    var imageInfos: [ImageItem] { get }
    var user: User? { get }
    func getImageInfos()
    func getImageAuthorDetails(imageInfo: ImageItem)
}

final class ImagesHandlerImpl: ImagesHandler, ObservableObject {
    
    @Published var imageInfos: [ImageItem] = []
    var mode: ImageHandlerMode = .na
    @Published var user: User? = nil
    
    init(mode: ImageHandlerMode){
        self.mode = mode
        
        if self.mode == .loadImages {
            self.getImageInfos()
        }
       
    }
    
    func getImageInfos() {
        Database.database().reference().child("pics").observe(.childAdded, with: { (snapshot) -> Void in
            let imageInfo = ImageItem(snapshot: snapshot)
            self.imageInfos.insert(imageInfo!, at: 0)
        })
        
        Database.database().reference().child("pics").observe(.childRemoved, with: { (snapshot) -> Void in
            let imageInfo = ImageItem(snapshot: snapshot)
            self.imageInfos.remove(at: self.imageInfos.firstIndex(where: { $0.fileName == imageInfo!.fileName })!)
        })
    }
    
    func getImageAuthorDetails(imageInfo: ImageItem) {
        Database.database().reference().child("users").child(imageInfo.author).observe(DataEventType.value, with: { snapshot in
            let author = User(snapshot: snapshot)
            self.user = author
          })
    }
}

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

protocol ImagesHandler {
    var imageInfos: [ImageItem] { get }
    func getImages()
}

final class ImagesHandlerImpl: ImagesHandler, ObservableObject {
    
    @Published var imageInfos: [ImageItem] = []
    
    init(){
        self.getImages()
    }
    
    func getImages() {
        Database.database().reference().child("pics").observe(.childAdded, with: { (snapshot) -> Void in
            var imageInfo = ImageItem(snapshot: snapshot)
            let imageRef = Storage.storage().reference(withPath: "images/\(imageInfo!.fileName)")
            imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    print("downloading image error! \(error.localizedDescription)")
                }
//                DispatchQueue.main.async {
//                    
//                    let image = UIImage(data: data!)
//                    
//                                        imageInfo!.image = image
//                    self.imageInfos[self.imageInfos.firstIndex(where: {$0.fileName == imageInfo!.fileName})!] = imageInfo!
//                }
                    
            }
            self.imageInfos.append(imageInfo!)
        })
    }
}

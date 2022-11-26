//
//  ImagesHandler.swift
//  TiszApp
//
//  Created by Szabó Tamás on 2022. 04. 06..
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SwiftUI

enum ImageHandlerMode {
    case na
    case loadImages
    case getDetails
}

final class ImagesViewModel: ObservableObject {
    var teamNum: Int = 0
    
    var mode: ImageHandlerMode = .na
    var checkImages: Bool
    @Published var user: User? = nil
    @Published var scorer: User? = nil
    @Published var detail: ImageItem? = nil
    @Published var imageNames: [ImageItem] = []
    
    
    init(mode: ImageHandlerMode, checkImages: Bool){
        self.mode = mode
        self.checkImages = checkImages
        
        if self.mode == .loadImages {
            self.getImageInfos()
        }
       
    }
    
    func getImageInfos() {
        Database.database().reference().child(checkImages ? "picsToDecide" : "pics").observe(.childAdded, with: { (snapshot) -> Void in
            let imageInfo = ImageItem(snapshot: snapshot)
            guard let imageInfo = imageInfo, imageInfo.author != "noAthor" else { return }
            if self.checkImages {
                self.imageNames.append(imageInfo)
            } else {
                self.imageNames.insert(imageInfo, at: 0)
            }
        })
        
        Database.database().reference().child(checkImages ? "picsToDecide" : "pics").observe(.childRemoved, with: { (snapshot) -> Void in
            let imageInfo = ImageItem(snapshot: snapshot)
            guard let firstIndex = self.imageNames.firstIndex(where: { $0.fileName == imageInfo?.fileName ?? "" }) else { return }
            self.imageNames.remove(at: firstIndex)
        })
        
    }
    
    func setChangeListener(for: ImageItem) {
        self.detail = `for`
        Database.database().reference().child("pics").observe(.childChanged, with: { (snapshot) -> Void in
            let imageInfo = ImageItem(snapshot: snapshot)
            self.detail?.score = imageInfo?.score ?? 0
            self.detail?.scorerUID = imageInfo?.scorerUID ?? "errorNoUidInfo"
            self.getScorer(imageInfo: imageInfo ?? ImageItem())
        })
    }
    
    func getImageAuthorDetails(imageInfo: ImageItem) {
        Database.database().reference().child("users").child(imageInfo.author).observe(DataEventType.value, with: { snapshot in
            let author = User(snapshot: snapshot)
            self.user = author
          })
    }
    
    func acceptImage(imageInfo: ImageItem) {
        Database.database().reference().child("picsToDecide").child(imageInfo.fileName).removeValue()
        
        let imageDetails = ["author" : imageInfo.author,
                         "fileName" : imageInfo.fileName,
                         "title" : imageInfo.title,
                            "score" : -1,
                            "scorerUID" : "none"] as [String: Any]
        
        Database.database().reference().child("pics").child(imageInfo.fileName).setValue(imageDetails)
    }
    
    func giveScoreForPic(imageInfo: ImageItem, score: Int) {
        getImageAuthorDetails(imageInfo: imageInfo)
        
        let imageDetails = ["author" : imageInfo.author,
                         "fileName" : imageInfo.fileName,
                         "title" : imageInfo.title,
                         "score" : score,
                            "scorerUID" : Auth.auth().currentUser?.uid ?? "unknown"] as [String: Any]
        
        Database.database().reference().child("pics").child(imageInfo.fileName).setValue(imageDetails)
        
        if score != 0 {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
            
            //this gives an array of zeros
            var scoresArray = [Int](repeating: 0, count: self.teamNum)
            
            if user != nil {
                scoresArray[(user?.groupNumber ?? 1)-1] = score
            }
            
            let scoreData = ["id" : dateFormatter.string(from: date),
                         "scores" : scoresArray,
                         "name" : "kép: \(imageInfo.title)",
                         "author" : Auth.auth().currentUser?.uid ?? "unknown"] as [String: Any]
            
            Database.database().reference().child("scores").child(dateFormatter.string(from: date)).setValue(scoreData)
        }
        
        
    }
    
    func getScorer(imageInfo: ImageItem) {
        Database.database().reference().child("users").child(imageInfo.scorerUID).observe(DataEventType.value, with: { snapshot in
            let author = User(snapshot: snapshot)
            self.scorer = author
          })
    }

    func uploadImage(title: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        if let imageData = image.jpegData(compressionQuality: 0.2) {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
            let fileName = dateFormatter.string(from: date)

            let imageRef = Storage.storage().reference().child("images/\(fileName)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            imageRef.putData(imageData, metadata: metadata) { (_, err) in
                if let err = err {
                    print("error: \(err.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)

                    //upload to realtime db
                    let imageInfo = ["author" : Auth.auth().currentUser?.uid ?? "unknown",
                                     "fileName" : fileName,
                                     "title" : title.isEmpty ? fileName : title,
                                     "score" : -1,
                                     "scorerUID" : "none"] as [String: Any]

                    Database.database().reference().child("picsToDecide").child(fileName).setValue(imageInfo)
                }
            }
        }
    }

    func deletePic(checkImages: Bool, completion: @escaping () -> Void) {
        Database.database().reference().child(checkImages ? "picsToDecide" : "pics").child(detail?.fileName ?? "noFile").removeValue()
        Storage.storage().reference().child("images/\(detail?.fileName ?? "noFile")").delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
}

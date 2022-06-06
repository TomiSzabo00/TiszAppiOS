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

protocol ImagesHandler {
    var imageInfos: [ImageItem] { get }
    var user: User? { get }
    var detail: ImageItem? { get set }
    var imageNames: [ImageItem] { get }
    func getImageInfos()
    func getImageAuthorDetails(imageInfo: ImageItem)
    func acceptImage(imageInfo: ImageItem)
    func giveScoreForPic(imageInfo: ImageItem, score: Int)
    func getScorer(imageInfo: ImageItem)
    func loadNextPage(from: Int, to: Int)
}

final class ImagesHandlerImpl: ImagesHandler, ObservableObject {
    
    @Published var imageInfos: [ImageItem] = []
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
            self.imageNames.insert(imageInfo!, at: 0)
        })
        
        Database.database().reference().child(checkImages ? "picsToDecide" : "pics").observe(.childRemoved, with: { (snapshot) -> Void in
            let imageInfo = ImageItem(snapshot: snapshot)
            self.imageNames.remove(at: self.imageNames.firstIndex(where: { $0.fileName == imageInfo!.fileName })!)
        })
        
    }
    
    func loadNextPage(from: Int, to: Int) {
        self.imageInfos.removeAll()
        for i in from..<to {
            self.imageInfos.append(self.imageNames[i])
        }
    }
    
    func setChangeListener(for: ImageItem) {
        self.detail = `for`
        Database.database().reference().child("pics").observe(.childChanged, with: { (snapshot) -> Void in
            let imageInfo = ImageItem(snapshot: snapshot)
            self.detail!.score = imageInfo!.score
            self.detail!.scorerUID = imageInfo!.scorerUID
            self.getScorer(imageInfo: imageInfo!)
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
            var scoreData = ["score1" : 0,
                         "score2" : 0,
                         "score3" : 0,
                         "score4" : 0,
                         "name" : "kép",
                         "author" : Auth.auth().currentUser?.uid ?? "unknown"] as [String: Any]
            
            switch user?.groupNumber {
            case 1:
                scoreData = ["score1" : score,
                             "score2" : 0,
                             "score3" : 0,
                             "score4" : 0,
                         "name" : "kép: \(imageInfo.title)",
                             "author" : Auth.auth().currentUser?.uid ?? "unknown"] as [String: Any]
                break
            case 2:
                scoreData = ["score1" : 0,
                             "score2" : score,
                             "score3" : 0,
                             "score4" : 0,
                         "name" : "kép: \(imageInfo.title)",
                             "author" : Auth.auth().currentUser?.uid ?? "unknown"] as [String: Any]
                break
            case 3:
                scoreData = ["score1" : 0,
                             "score2" : 0,
                             "score3" : score,
                             "score4" : 0,
                         "name" : "kép: \(imageInfo.title)",
                             "author" : Auth.auth().currentUser?.uid ?? "unknown"] as [String: Any]
                break
            case 4:
                scoreData = ["score1" : 0,
                             "score2" : 0,
                             "score3" : 0,
                             "score4" : score,
                         "name" : "kép: \(imageInfo.title)",
                             "author" : Auth.auth().currentUser?.uid ?? "unknown"] as [String: Any]
                break
            default:
                break
            }
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMddHHmmssSSS"
            Database.database().reference().child("scores").child(dateFormatter.string(from: date)).setValue(scoreData)
        }
        
    }
    
    func getScorer(imageInfo: ImageItem) {
        Database.database().reference().child("users").child(imageInfo.scorerUID).observe(DataEventType.value, with: { snapshot in
            let author = User(snapshot: snapshot)
            self.scorer = author
          })
    }
}

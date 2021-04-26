//
//  PostData.swift
//  Instagram
//
//  Created by Liu Peiwen on 2021/04/22.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
    //var commentors: [String] = []
    var commentsReceived: [String:CommentStruct] = [:]
    //var commentsSend: [String] = []
    //var comment: String?
    
    var commentCounter: Int?
    //var comments: [CommentStruct]?
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let postDic = document.data()

        self.name = postDic["name"] as? String

        self.caption = postDic["caption"] as? String

        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        
        self.commentCounter = postDic["commentCounter"] as? Int
        
        
//        if let commentors = postDic["commentors"] as? [String] {
//            self.commentors = commentors
//        }
        
        if let commentsReceived = postDic["commentsReceived"] as? [String:CommentStruct]{
            self.commentsReceived = commentsReceived
        }
        
//        if let commentsSend = postDic["commentsSend"] as? [String] {
//            self.commentsSend = commentsSend
//        }
        
        //self.comment = postDic["comment"] as? String

        
        //self.comments = postDic["commentsReceived"] as? [CommentStruct]
        
        
        
        
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }
        
        
        
        
//        postDic["commentsReceived"].getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//
//                let getCommentCount = document.data()?["commentCounter"] as! Int
//                print("getCommentCount: \(getCommentCount)")
//
//
//                // コメントデータを追加する
//                postRef.collection("commentsReceived").document(String(nowCommentCount)).setData(postDic)
//
//                // 毎回コメント後に合計値+1
//                nowCommentCount += 1
//
//                print("DEBUG_PRINT: nowCommentCount after update: \(nowCommentCount)")
//
//                postRef.updateData(["commentCounter" : nowCommentCount])
//
//            } else {
//                print("Document does not exist")
//            }
//        }
        
        
        
        
        
    }
    
    
    
    
}

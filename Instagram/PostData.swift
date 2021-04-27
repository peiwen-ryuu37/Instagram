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
    
    // コメントがサブコレクションとして保存する必要がない
    // 「いいね」ボタンのように文字列の配列として保存すれば良い
    var commentsReceived: [String:CommentStruct] = [:]
    //var commentsReceived: [CommentStruct] = []

    var commentCounter: Int?
    
    // 「いいね」ボタンのようにコメントを保存する
    var commentsArray: [String] = []
    
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
        

        if let commentsReceived = postDic["commentsReceived"] as? [String:CommentStruct]{
            self.commentsReceived = commentsReceived
        }
        
//        if let commentsReceived = postDic["commentsReceived"] as? [CommentStruct]{
//            self.commentsReceived = commentsReceived
//        }
        
        if let commentsArray = postDic["commentsArray"] as? [String] {
            self.commentsArray = commentsArray
        }

        
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねを押していると認識する。
                self.isLiked = true
            }
        }
         
    }
    
    
}

//
//  CommentStruct.swift
//  Instagram
//
//  Created by Liu Peiwen on 2021/04/23.
//

import Foundation
import Firebase

//class CommentStruct {
//    var comment: String?
//    var commentor: String?
//
//    init(document: QueryDocumentSnapshot) {
//
//        let postDic = document.data()
//
//        self.comment = postDic["comment"] as? String
//
//        self.commentor = postDic["commentor"] as? String
//    }
//
//}

struct CommentStruct {
    var comment: String
    var commentor: String
    
    init(comment: String, commentor: String) {
        self.comment = comment
        self.commentor = commentor
    }
}

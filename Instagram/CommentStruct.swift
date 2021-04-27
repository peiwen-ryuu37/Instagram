//
//  CommentStruct.swift
//  Instagram
//
//  Created by Liu Peiwen on 2021/04/23.
//

import Foundation
import Firebase

struct CommentStruct {
    var comment: String
    var commentor: String
    
    init(comment: String, commentor: String) {
        self.comment = comment
        self.commentor = commentor
    }
}

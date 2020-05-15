//
//  PostData.swift
//  Instagram
//
//  Created by 井上真悠子 on 2020/05/13.
//  Copyright © 2020 taro.kirameki. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id:String
    var name:String?
    var caption:String?
    var date:Date?
    var likes:[String] = []
    var isLiked:Bool = false
    var comments:[String] = []//コメントした人のuid:コメントを保存する
    
    
    
    init(document:QueryDocumentSnapshot) {
        self.id = document.documentID
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        
        if let comments = postDic["comments"] as? [String] {//コメントした人のidとコメントを格納する配列
            self.comments = comments
        }
        if let myid = Auth.auth().currentUser?.uid {
            if self.likes.firstIndex(of: myid) != nil {
                self.isLiked = true
            }
        }
    }
    
    
}

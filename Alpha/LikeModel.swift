//
//  LikeModel.swift
//  Alpha
//
//  Created by Ross Miglin on 12/7/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import Foundation

class LikeModel {
    
    var id: String?
    var postID: String?
    var user: String?
    
    init(id: String?, postID: String?, user: String?){
        self.id = id
        self.postID = postID
        self.user = user
    }
}

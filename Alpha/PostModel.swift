//
//  PostModel.swift
//  Alpha
//
//  Created by Karla Padron on 12/1/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import Foundation

class PostModel {
    
    var id: String?
    var user: String?
    var post: String?
    var time: String?

    
    init(id: String?, user: String?, post: String?, time: String?){
        self.id = id
        self.user = user
        self.post = post
        self.time = time

    }
}

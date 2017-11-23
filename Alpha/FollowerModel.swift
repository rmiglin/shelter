//
//  FollowerModel.swift
//  Alpha
//
//  Created by Karla Padron on 11/5/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import Foundation

class FollowerModel {
    
    var id: String?
    var follower: String?
    var currentUser: String?
    var show: String?
    
    init(id: String?, follower: String?, currentUser: String?, show: String?){
        self.id = id
        self.follower = follower
        self.currentUser = currentUser
        self.show = show
    }
}

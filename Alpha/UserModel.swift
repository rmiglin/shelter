//
//  UserModel.swift
//  Alpha
//
//  Created by Karla Padron on 11/5/17.
//  Copyright © 2017 Karla Padron. All rights reserved.
//

import Foundation

class UserModel {
    
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var phoneNumber: String?
    var streetAddress: String?
    var city: String?
    var state: String?
    var zip: String?
    var status: String?
    var shareLocation: String?
    
    init(id: String?, firstName: String?, lastName: String?, email: String?, password: String?, phoneNumber: String?, streetAddress: String?, city: String?, state: String?, zip: String?, status: String?, shareLocation: String?){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zip = zip
        self.status = status
        self.shareLocation = shareLocation
    }
}

//
//  User.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/18/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import Foundation

enum userType {
    case privateUser
    case publicUser
}

class User {
    var id: String
    var name: String
    var email: String = ""
    var type: userType = userType.privateUser
    
    init() {
        self.id = ""
        self.name = ""
        self.email = ""
        self.type = userType.privateUser
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(id: String, name: String, email: String, type: userType) {
        self.id = id
        self.name = name
        self.email = email
        self.type = type
    }
}

//
//  Message.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/22/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import Foundation

enum messageType {
    case currentUserChat
    case otherUserChat
    case joinedUser
    case hasLeftUser
}

enum messageStatus {
    case sending
    case sended
    case error
}

class Message {
    var id: String
    var content: String
    var user: User
    var type: messageType
    
    init() {
        self.id = ""
        self.content = ""
        self.user = User()
        self.type = messageType.currentUserChat
    }
    
    init(id: String, content: String, user: User, type: messageType) {
        self.id = id
        self.content = content
        self.user = user
        self.type = type
    }
}

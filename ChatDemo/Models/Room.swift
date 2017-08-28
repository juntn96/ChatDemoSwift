//
//  Room.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/18/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import Foundation
class Room {
    var id: String
    var name: String
    var maxMember: Int
    var currentMember: Int
    //var listUsers: Array<User>
    
    init() {
        self.id = ""
        self.name = ""
        self.maxMember = 0
        self.currentMember = 0
        //self.listUsers = []
    }
    
    init(id: String, name: String, maxMember: Int, currentMember: Int) {
        self.id = id
        self.name = name
        self.maxMember = maxMember
        self.currentMember = currentMember
        //self.listUsers = listUsers
    }
}

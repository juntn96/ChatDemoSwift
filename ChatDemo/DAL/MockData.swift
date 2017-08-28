//
//  MockRoomList.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/18/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import Foundation
class MockData {
    public static func getMockRoomList() -> ([Room]) {
        var roomList = [Room]()
        let r1 = Room(id: "1", name: "Room Test 1", maxMember: 4, currentMember: 1)
        roomList.append(r1)
        let r2 = Room(id: "2", name: "Room Test 2", maxMember: 6, currentMember: 4)
        roomList.append(r2)
        let r3 = Room(id: "3", name: "Room Test 3", maxMember: 8, currentMember: 6)
        roomList.append(r3)
        let r4 = Room(id: "4", name: "Room Test 4", maxMember: 10, currentMember: 3)
        roomList.append(r4)
        let r5 = Room(id: "5", name: "Room Test 5", maxMember: 12, currentMember: 5)
        roomList.append(r5)
        let r6 = Room(id: "6", name: "Room Test 6", maxMember: 14, currentMember: 7)
        roomList.append(r6)
        let r7 = Room(id: "7", name: "Room Test 7", maxMember: 16, currentMember: 16)
        roomList.append(r7)
        return roomList
    }
}

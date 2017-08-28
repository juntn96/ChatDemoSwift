//
//  RoomDataService.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/22/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import Foundation
import Firebase

enum serviceState {
    case success
    case error
}

struct RoomDataService {
    // MARK: typealias call back
    // def new func with param array or nil and return void
    typealias roomListClosure = (Array<Room>?) -> Void
    typealias serviceCallback = (serviceState) -> Void
    typealias messageEventCallback = (Message?) -> Void
    //typealias addUserJoinedCallBack = (serviceState) -> Void
    
    
    func getRoomList(completionHandler: @escaping roomListClosure) {
        var roomList: Array<Room> = []
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // MARK: performance and optimize code
        ref.child("Room").queryOrderedByKey().observeSingleEvent(of: .value, with: {
            (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let childSnapShot = snapshot.childSnapshot(forPath: rest.key)
                if let roomInfos = childSnapShot.value as? [String:AnyObject], roomInfos.count > 0 {
                    
                    // WARNING: data can nil and crash app because using force unwrap optional
                    let name = roomInfos["name"] as? String
                    let currentMember = roomInfos["currentMember"] as? String
                    let maxMember = roomInfos["maxMember"] as? String
                    let room = Room(id: rest.key, name: name!, maxMember: Int(maxMember!)!, currentMember: Int(currentMember!)!)
                    roomList.append(room)
                }
            }
            
            // MARK: using typecalias closure to callback data
            // using Grand Central Dispatch (GCD) one way to make multi thread
            DispatchQueue.main.async {
                if roomList.isEmpty {
                    completionHandler(nil)
                } else {
                    completionHandler(roomList)
                }
            }
        })
    }
    
    // MARK: add new room
    func addNewRoom(name: String, currentMember: String = "1", maxMember: String, completionHandler: @escaping serviceCallback) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let room = ["name" : name,
                    "currentMember" : currentMember,
                    "maxMember" : maxMember]
        ref.child("Room").childByAutoId().setValue(room) {
            (error, ref) in
            if error != nil {
                completionHandler(serviceState.error)
            } else {
                completionHandler(serviceState.success)
            }
        }
    }
    
    // MARK: add user
    func addUserJoined(room: Room, user: User, completionHandle: @escaping serviceCallback) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let user = ["name" : "\(user.name)"]
        let url = "Room/\(room.id)/User"
        let newUserRef = ref.child(url).childByAutoId()
        newUserRef.setValue(user) {
            (error, ref) in
            if error != nil {
                completionHandle(serviceState.error)
            } else {
                InfoDataHolder.user.id = newUserRef.key
                completionHandle(serviceState.success)
            }
        }
    }
    
    // MARK: add message
    func addMessage(room: Room, message: Message, completionHandler: @escaping serviceCallback) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let message = ["content" : message.content,
                       "userName" : message.user.name,
                       "userID" : message.user.id]
        let url = "Room/\(room.id)/Message"
        ref.child(url).childByAutoId().setValue(message) {
            (error, ref) in
            if error != nil {
                completionHandler(serviceState.error)
            } else {
                completionHandler(serviceState.success)
            }
        }
    }
    
    // MARK: remove user
    func removeUserOut(room: Room, user: User, completionHandler: @escaping serviceCallback) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let url = "Room/\(room.id)/User"
        ref.child(url).child(InfoDataHolder.user.id).removeValue() {
            (error, ref) in
            if error != nil {
                completionHandler(serviceState.error)
            } else {
                completionHandler(serviceState.success)
            }
        }
    }
    
    // MARK: Observe user joined
    func roomUserJoinedObserve (room: Room, completionHandler: @escaping messageEventCallback) {
        let ref: DatabaseReference!
        ref = Database.database().reference()
        var message: Message? = nil
        // MARK: observe join
        let url = "Room/\(room.id)/User"
        ref.child(url).queryLimited(toLast: 1).observe(.childAdded, with: {
            (snapshot) -> Void in
            // TODO:
            if snapshot.key != InfoDataHolder.user.id {
                let messageData = snapshot.value as! Dictionary<String,String>
                if let name = messageData["name"] {
                    let user = User(id: snapshot.key, name: name)
                    message = Message(id: "", content: "", user: user, type: .joinedUser)
                }
                // async callback
                DispatchQueue.main.async {
                    if message == nil {
                        completionHandler(nil)
                    } else {
                        completionHandler(message)
                    }
                }
            }
        })
    }
    
    // MARK: observe user has left
    func roomUserHasLefObserve(room: Room, completionHandler: @escaping messageEventCallback) {
        let ref: DatabaseReference!
        ref = Database.database().reference()
        var message: Message? = nil
        let url = "Room/\(room.id)/User"
        // MARK: observe out
        ref.child(url).observe( .childRemoved, with: {
            (snapshot) -> Void in
            // TODO:
            if snapshot.key != InfoDataHolder.user.id {
                if let messageData = snapshot.value as? Dictionary<String,String> {
                    if let name = messageData["name"] {
                        let user = User(id: snapshot.key, name: name)
                        message = Message(id: "", content: "", user: user, type: .hasLeftUser)
                    }
                }
                // async callback
                DispatchQueue.main.async {
                    if message == nil {
                        completionHandler(nil)
                    } else {
                        completionHandler(message)
                    }
                }
            }
        })
    }
    
    // MARK: message observe
    func messageObsever(room: Room, completionHandler: @escaping messageEventCallback) {
        let ref: DatabaseReference!
        ref = Database.database().reference()
        var message: Message? = nil
        let url = "Room/\(room.id)/Message"
        ref.child(url).queryLimited(toLast: 20).observe(.childAdded, with: {
            (snapshot) in
            if let messageData = snapshot.value as? Dictionary<String,String> {
                if let content = messageData["content"],
                    let userName = messageData["userName"],
                    let userID = messageData["userID"]
                {
                    let user = User(id: userID, name: userName)
                    message = Message(id: snapshot.key, content: content, user: user, type: .otherUserChat)
                    if userID == InfoDataHolder.user.id {
                        message = Message(id: snapshot.key, content: content, user: user, type: .currentUserChat)
                    }
                }
            }
            // async callback
            DispatchQueue.main.async {
                if message == nil {
                    completionHandler(nil)
                } else {
                    completionHandler(message)
                }
            }
        })
    }
}

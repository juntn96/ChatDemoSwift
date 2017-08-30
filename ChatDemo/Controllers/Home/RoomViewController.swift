//
//  RoomViewController.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/22/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import UIKit
import Firebase

class RoomViewController: UIViewController {
    
    var messList: Array<Message> = []
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    var room: Room = Room()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initView()
        self.messageObserve()
        self.observeUserJoined()
        self.observeUserHasLeft()
    }
    
    @IBAction func sendButton(_ sender: Any) {
        let messageContent =  self.messageTextField.text!
        self.messageTextField.text = ""
        let user = User(id: InfoDataHolder.user.id, name: InfoDataHolder.user.name)
        let message = Message(id: "", content: messageContent, user: user, type: .currentUserChat)
        let service = RoomDataService()
        service.addMessage(room: room, message: message) { (callback) in
            if callback == serviceState.error {
                // TODO: show alert here
                
            }
            if callback == serviceState.success {
                // TODO:

            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        let service = RoomDataService()
        
        let progress = MBProgressHUD.showAdded(to: self.view, animated: true)
        progress.isUserInteractionEnabled = false
        
        service.removeUserOut(room: room, user: InfoDataHolder.user) { (callback) in
            if callback == serviceState.success {
                // TODO: do something here
                service.removeCurrentMember(room: self.room) {
                    callback in
                    if callback == serviceState.success {
                        // TODO:
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        // TODO: show alert here
                    }
                }
            }
            if callback == serviceState.error {
                // TODO: show alert here
            }
            progress.hide(animated: true)
        }
    }
    
}

// MARK: init view and data
extension RoomViewController {
    func initView() {
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
    }
}

// MARK: observe server callback
extension RoomViewController {
    func observeUserJoined() {
        let service = RoomDataService()
        service.roomUserJoinedObserve(room: room) {
            (callback) in
            if let temp = callback {
                self.insertMessageRow(withMessage: temp)
            } else {
                // TODO: show alert here
            }
            
        }
    }
    
    func observeUserHasLeft() {
        let service = RoomDataService()
        service.roomUserHasLefObserve(room: room) {
            (callback) in
            if let temp = callback {
                self.insertMessageRow(withMessage: temp)
            } else {
                // TODO: show alert here
            }
        }
    }
    
    func messageObserve() {
        let service = RoomDataService()
        service.messageObsever(room: room) {
            (callback) in
            if let temp = callback {
                self.insertMessageRow(withMessage: temp)
                service.removeMessage(room: self.room, message: temp)
//                self.messList.remove(at: 0)
            } else {
                // TODO: show alert here
            }
        }
    }
    
    func insertMessageRow(withMessage: Message) {
        self.messList.append(withMessage)
        self.messageTableView.beginUpdates()
        self.messageTableView.insertRows(at: [IndexPath(row: self.messList.count - 1, section: 0)], with: .automatic)
        self.messageTableView.endUpdates()
        let lastRow: Int = self.messageTableView.numberOfRows(inSection: 0) - 1
        let indexPath = IndexPath(row: lastRow, section: 0);
        self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension RoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

extension RoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mes = messList[indexPath.row]
        var cellIndentifier = ""
        
        // WARNING: respone data can nil
        switch mes.type {
        case messageType.currentUserChat:
            //
            cellIndentifier = "CurrentUserChat"
            guard let temp = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? CurrentUserChatTableViewCell else {
                fatalError(StringMessage.errorMessage)
            }
            temp.userNameLabel.text = mes.user.name
            temp.messageLabel.text = mes.content
            return temp
        case messageType.otherUserChat:
            //
            cellIndentifier = "OtherUserChat"
            guard let temp = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? OtherUserChatTableViewCell else {
                fatalError(StringMessage.errorMessage)
            }
            temp.userNameLabel.text = mes.user.name
            temp.messageLabel.text = mes.content
            return temp
        case messageType.joinedUser:
            //
            cellIndentifier = "JoinedUser"
            guard let temp = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? JoinedUserChatTableViewCell else {
                fatalError(StringMessage.errorMessage)
            }
            temp.userNameLabel.text = "\(mes.user.name) joined the room !!! have fun"
            return temp
        case messageType.hasLeftUser:
            //
            cellIndentifier = "JoinedUser"
            guard let temp = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? JoinedUserChatTableViewCell else {
                fatalError(StringMessage.errorMessage)
            }
            temp.userNameLabel.text = "\(mes.user.name) has left the room !!!"
            temp.userNameLabel.textColor = UIColor.red
            return temp
        }
    }
    
}

//
//  HomeViewController.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/18/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //public var privateName: String = ""
    var roomList: Array<Room> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getRoomData()
    }
    
    func getRoomData() {
        self.addButton.isEnabled = false
        let service = RoomDataService()
        let progress = MBProgressHUD.showAdded(to: self.view, animated: true)
        progress.label.text = "Loading"
        progress.isUserInteractionEnabled = false
        service.getRoomList(completionHandler: { (data) in
            if let temp = data {
                self.roomList = temp
                progress.hide(animated: true)
                self.homeTableView.reloadData()
                self.addButton.isEnabled = true
            }
            
        })
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        if (InfoDataHolder.user.type == .publicUser) {
            let service = UserDataService()
            service.logout(id: InfoDataHolder.user.id) {
                callback in
                if callback != nil {
                    if !(callback?.value(forKey: "error") as! Bool) {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        // TODO: error
                    }
                } else {
                    // TODO: error
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        InfoDataHolder.user = User()
    }
    
    @IBAction func addButton(_ sender: Any) {
        let addView = self.storyboard?.instantiateViewController(withIdentifier: "AddView") as! AddViewController
        self.addChildViewController(addView)
        addView.view.frame = self.view.frame
        self.view.addSubview(addView.view)
        addView.didMove(toParentViewController: self)
    }
    
    @IBAction func searchTextField(_ sender: Any) {
        
    }
    
}

// MARK: - Custom Method
extension HomeViewController {
    func initUI() {
        // Setting Tableview
        homeTableView.delegate = self
        homeTableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.isNavigationBarHidden = true
        self.nameLabel.text =  "Hi \(InfoDataHolder.user.name) !!!"
        
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndentifier = "RoomTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? RoomTableViewCell else {
            fatalError(StringMessage.errorMessage)
        }
        let room = roomList[indexPath.row]
        cell.roomNameLabel.text = room.name
        cell.roomNumberLabel.text = "\(room.currentMember)/\(room.maxMember)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = roomList[indexPath.row]
        // Add user to room
        let service = RoomDataService()
        
        let progress = MBProgressHUD.showAdded(to: self.view, animated: true)
        progress.isUserInteractionEnabled = false
        // MARK: 1- get current member from server
        service.getCurrentMember(room: room) {
            callback in
            
            // MARK: 2- check room is full or not
            if let currentMember = callback {
                room.currentMember = currentMember
                
                // MARK: 2.1- room full
                if currentMember == room.maxMember {
                    
                    // toast alert when room full
                    self.view.makeToast("This room is full")
                }
                else {
                    // MARK 2.2- room not full
                    // request server to add user into room
                    service.addUserJoined(room: room, user: InfoDataHolder.user) { (callback) in
                        if callback == serviceState.success {
                            
                            // on request success
                            // request server  +1 current member
                            service.addCurrentMember(room: room) {
                                callback in
                                if callback == serviceState.success {
                                    
                                    // on requesr success
                                    let roomView = self.storyboard?.instantiateViewController(withIdentifier: "RoomView") as! RoomViewController
                                    roomView.room = room
                                    self.navigationController?.pushViewController(roomView, animated: true)
                                } else {
                                    // on request failed
                                    // TODO: show alert here
                                }
                            }
                        }
                        if callback == serviceState.error {
                            // on request failed
                            // TODO: show alert here
                        }
                    }
                }
            }
            progress.hide(animated: true)
        }
    }
}


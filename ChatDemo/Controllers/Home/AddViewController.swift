//
//  AddViewController.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/23/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var numberStepper: UIStepper!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initView()
    }
    
    @IBAction func addNumberMember(_ sender: UIStepper) {
        numberTextField.text = Int(sender.value).description
    }
    
    @IBAction func addButton(_ sender: Any) {
        let service = RoomDataService()
        let progress = MBProgressHUD.showAdded(to: self.view, animated: true)
        progress.label.text = "Adding"
        service.addNewRoom(name: nameTextField.text!, maxMember: numberTextField.text!) { (callback) in
            if callback == serviceState.error {
                // TODO: show alert
            }
            if callback == serviceState.success {
                // TODO: move to room
            }
            progress.hide(animated: true)
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}

// MARK: init view and data
extension AddViewController {
    func initView() {
        
    }
}

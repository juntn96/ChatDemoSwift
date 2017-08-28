//
//  LoginViewController.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/18/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
//    var name: String?
//    var email: String?
//    var password: String?
//    var confirmPwd: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let name = userNameTextField.text
        let pwd = passwordTextField.text
        let service = UserDataService()
        service.login(name: name!, password: pwd!) {
            callback in
            if callback != nil {
                if !(callback?.value(forKey: "error") as! Bool) {
                    let userData = callback?.value(forKey: "user") as! NSDictionary
                    // getting user value
                    let id = userData.value(forKey: "id") as! Int
                    let name = userData.value(forKey: "name") as! String
                    let email = userData.value(forKey: "email") as! String
                    InfoDataHolder.user = User(id: "\(id)", name: name, email: email, type: .publicUser)
                } else {
                    // TODO: error
                }
            } else {
                // TODO: Error
            }
        }
    }

    @IBAction func buttonForgot(_ sender: Any) {
    }
}

extension LoginViewController {

}

//
//  LoginViewController.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/18/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import UIKit
import Alamofire

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
        let encodePwd = pwd?.toBase64()
        service.login(name: name!, password: encodePwd!) {
            callback in
            if callback != nil {
                if !(callback?.value(forKey: "error") as! Bool) {
                    let userData = callback?.value(forKey: "user") as! NSDictionary
                    // getting user value
                    let id = userData.value(forKey: "id") as! Int
                    let name = userData.value(forKey: "name") as! String
                    let email = userData.value(forKey: "email") as! String
                    
                    // WARNING: hold info by static
                    InfoDataHolder.user = User(id: "\(id)", name: name, email: email, type: .publicUser)
                    
                    let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    let viewIndentifier = "HomeView"
                    guard let home = storyBoard.instantiateViewController(withIdentifier: viewIndentifier) as? HomeViewController else {
                        fatalError(StringMessage.errorMessage)
                    }
                    self.navigationController?.pushViewController(home, animated: true)
                } else {
                    // TODO: error
                    let message = callback?.value(forKey: "message") as! String
                    self.view.makeToast(message)
                }
            } else {
                // TODO: error
                
            }
        }
    }

    @IBAction func buttonForgot(_ sender: Any) {
    }
}

extension LoginViewController {

}

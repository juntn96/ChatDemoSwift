//
//  RegisterViewController.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/28/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        let name = nameTextField.text!
        let email = emailTextField.text!
        let pwd = passwordTextField.text!
        let cfPwd = confirmPwdTextField.text!
        
        if pwd != cfPwd {
            self.view.makeToast(StringMessage.errorConfirmPwd)
            return
        }
        
        if !isValidEmail(testStr: email) {
            self.view.makeToast(StringMessage.errorEmail)
            return
        }
        
        let pwdLength = pwd.trimmingCharacters(in: .whitespacesAndNewlines).characters.count
        
        if pwdLength < 6 {
            self.view.makeToast(StringMessage.errorPwd)
            return
        }
        
        let nameLength = name.trimmingCharacters(in: .whitespacesAndNewlines).characters.count
        
        if nameLength < 3 {
            self.view.makeToast(StringMessage.errorName)
            return
        }
        
        let encodePwd = pwd.toBase64()
        
        let service = UserDataService()
        service.insertUser(name: name, email: email, password: encodePwd) {
            (callback) in
            if callback != nil {
                let error = callback?.value(forKey: "error") as! Bool
                if !error {
                    let id = callback?.value(forKey: "id") as! Int
                    let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    let viewIndentifier = "HomeView"
                    guard let home = storyBoard.instantiateViewController(withIdentifier: viewIndentifier) as? HomeViewController else {
                        self.view.makeToast(StringMessage.errorMessage)
                        return
                    }
                    
                    InfoDataHolder.user = User(id: "\(id)", name: name, email: email, type: userType.publicUser)
                    self.navigationController?.pushViewController(home, animated: true)
                } else {
                    let message = callback?.value(forKey: "message") as! String
                    self.view.makeToast(message)
                }
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

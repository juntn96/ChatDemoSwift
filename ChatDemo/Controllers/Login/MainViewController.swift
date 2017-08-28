//
//  ViewController.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/17/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private var screenWidth: Double = 0
    private var screenHeight: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        screenWidth = Double(self.view.frame.width)
        screenHeight = Double(self.view.frame.height)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let customBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = customBackButton
    }

    @IBAction func btnPrivate(_ sender: Any) {
        let nameLength = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count
        if let length = nameLength, length < 3 {
            self.view.makeToast("Please enter name")
            return
        }
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let viewIndentifier = "HomeView"
        guard let home = storyBoard.instantiateViewController(withIdentifier: viewIndentifier) as? HomeViewController else {
            fatalError(StringMessage.errorMessage)
        }
        
        // holder private user
        InfoDataHolder.user = User(id: "", name: nameTextField.text!, email: "", type: userType.privateUser)
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
    }
}


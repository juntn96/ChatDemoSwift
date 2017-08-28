//
//  UserDataService.swift
//  ChatDemo
//
//  Created by Lam Ngoc Khanh on 8/22/17.
//  Copyright © 2017 Lam Ngoc Khanh. All rights reserved.
//
import Foundation
import  Alamofire
// TODO:
class UserDataService {
    
    let urlLogin = "http://10.16.23.247/ChatDemo/api/login.php"
    let urlInsert = "http://10.16.23.247/ChatDemo/api/insert.php"
    
    // default value to stored user data
    //let defaultValue = UserDefaults.standard
    
    //typealias userDataCallback = (User) -> Void
    typealias serverCallback = (NSDictionary?) -> Void
    
    func login(name: String, password: String, completionHandler: @escaping serverCallback) {
        
        // getting params
        let parameters: Parameters = ["name" : name, "password" : password]
        
        // request to url
        Alamofire.request(urlLogin, method: .post, parameters: parameters).responseJSON {
            response in
            //
            print(response)
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                completionHandler(jsonData)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func insertUser(name: String, email: String, password: String, completionHandler: @escaping serverCallback) {
        // getting params
        let params: Parameters = ["name" : name, "email" : email, "password" : password]
        
        //request url 
        Alamofire.request(urlInsert, method: .post, parameters: params).responseJSON {
            response in
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                completionHandler(jsonData)
            } else {
                completionHandler(nil)
            }
        }
    }
}

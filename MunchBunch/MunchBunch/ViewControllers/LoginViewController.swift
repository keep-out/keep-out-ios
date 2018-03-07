//
//  LoginViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/14/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ChameleonFramework
import Validator
import SwiftKeychainWrapper
import SwiftyBeaver

class LoginViewController: UIViewController {
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBAction func didTouchLogin(_ sender: Any) {
        // TODO: add form validation and error handling
        let username: String = textFieldUsername.text!
        let password: String = textFieldPassword.text!
        
        let parameters = [
            "username":username,
            "password":password
        ]
        
        Alamofire.request(SERVER_URL + AUTHENTICATE, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                log.info("Auth successful")
                
                // Save username, password to Keychain
                KeychainWrapper.standard.set(username, forKey: "username")
                KeychainWrapper.standard.set(password, forKey: "password")
                
                let json = JSON(data)
                if let code = json["code"].int {
                    if code == 200 {
                        if let token = json["data"]["token"].string {
                            self.defaults.set(token, forKey: "token")
                        }
                        if let userId = json["data"]["id"].int {
                            self.defaults.set(userId, forKey: "userId")
                        }
                        // Segue to home view controller
                        self.performSegue(withIdentifier: "loginSegue", sender: sender)
                    }
                }
            case .failure(let error):
                log.error(error)
            }
        }
    }
    
    @IBAction func didTouchSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpSegue", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = GradientColor(UIGradientStyle.leftToRight, frame: view.frame, colors: [FlatLime(), FlatGreen()])
        textFieldUsername.setBottomLine(borderColor: FlatWhite(), placeholderText: "Username")
        textFieldPassword.setBottomLine(borderColor: FlatWhite(), placeholderText: "Password")
        buttonLogin.setBorder(borderColor: FlatWhite(), radius: 5.0, width: 2.0)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)  // Allows dismissal of keyboard on tap anywhere on screen besides the keyboard itself
        
        // MARK - POC of validation on input change
        var rules = ValidationRuleSet<String>()
        let testRule = ValidationRuleLength(min: 5, error: ValidationError(message: "😫"))
        rules.add(rule: testRule)
        textFieldUsername.addValidation(rules: rules)
        textFieldPassword.addValidation(rules: rules)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


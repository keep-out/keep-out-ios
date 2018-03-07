//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController {
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldRepeatedPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    @IBAction func didTouchSignUp(_ sender: Any) {
        // TODO: add form validation and error handling
        let username: String = textFieldUsername.text!
        let password: String = textFieldPassword.text!
        let repeatedPassword: String = textFieldRepeatedPassword.text!
        
        if password != repeatedPassword {
            // Passwords don't match!
        } else {
            let parameters = [
                "username":username,
                "hashed_password":password,
                ] as [String : Any]
            
            Alamofire.request(SERVER_URL + REGISTER, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let code = json["code"].int {
                        if code == 201 {
                            // Save username, password to Keychain
                            KeychainWrapper.standard.set(username, forKey: "username")
                            KeychainWrapper.standard.set(password, forKey: "password")
                            
                            if let token = json["data"]["token"].string {
                                self.defaults.set(token, forKey: "token")
                            }
                            if let userId = json["data"]["id"].int {
                                self.defaults.set(userId, forKey: "userId")
                            }
                            self.performSegue(withIdentifier: "homeSegue", sender: sender)
                        }
                    }
                case .failure(let error):
                    log.error(error)
                }
            }
        }
    }
    
    @IBAction func didTouchCancel(_ sender: Any) {
        performSegueToReturnBack()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)  // Allows dismissal of keyboard on tap anywhere on screen besides the keyboard itself
        
        // Do any additional setup after loading the view.
        view.backgroundColor = GradientColor(UIGradientStyle.leftToRight, frame: view.frame, colors: [FlatLime(), FlatGreen()])
        textFieldUsername.setBottomLine(borderColor: FlatWhite(), placeholderText: "Username")
        textFieldPassword.setBottomLine(borderColor: FlatWhite(), placeholderText: "Password")
        textFieldRepeatedPassword.setBottomLine(borderColor: FlatWhite(), placeholderText: "Repeat password")
        buttonSignUp.setBorder(borderColor: FlatWhite(), radius: 5.0, width: 2.0)
        
        // TODO: refactor and rethink necessary rules for each field
        var rules = ValidationRuleSet<String>()
        let testRule = ValidationRuleLength(min: 5, error: ValidationError(message: "😫"))
        rules.add(rule: testRule)
        textFieldUsername.addValidation(rules: rules)
        textFieldPassword.addValidation(rules: rules)
        textFieldPassword.addValidation(rules: rules)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


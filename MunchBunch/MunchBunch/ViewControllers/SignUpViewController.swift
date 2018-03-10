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
import SwiftKeychainWrapper
import SwiftyBeaver

class SignUpViewController: UIViewController {
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldRepeatedPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    @IBAction func didTouchSignUp(_ sender: Any) {
        // TODO: add form validation and error handling
        let fname: String = textFieldFirstName.text!
        let lname: String = textFieldLastName.text!
        // Remove whitespaces from email string (in case of auto-complete)
        let email: String = textFieldEmail.text!.trimmingCharacters(in: .whitespaces)
        let username: String = textFieldUsername.text!
        let password: String = textFieldPassword.text!
        let repeatedPassword: String = textFieldRepeatedPassword.text!
        
        // Passwords don't match!
        if password != repeatedPassword {
            // TODO: display message saying paswords don't match
            return;
        } else if fname.count == 0 || fname.count > 30 {
            // TODO: display message saying fname isn't present or too long
            return;
        } else if lname.count == 0 || lname.count > 30 {
            // TODO: display message saying lname isn't present or too long
            return;
        } else if username.count < 5 || username.count > 30 {
            // TODO: display message saying username is too short or too long
            return;
        } else if password.count < 5 || password.count > 30 {
            // TODO: display message saying password too short or too long
            return;
        } else { // Validation ok
            let parameters = [
                "email":email,
                "username":username,
                "hashed_password":password,
                "first_name":fname,
                "last_name":lname
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
                // TODO: Fix backend logic to return fail conditions
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
        textFieldFirstName.setBottomLine(borderColor: FlatWhite(), placeholderText: "First name")
        textFieldLastName.setBottomLine(borderColor: FlatWhite(), placeholderText: "Last name")
        textFieldEmail.setBottomLine(borderColor: FlatWhite(), placeholderText: "Email")
        textFieldUsername.setBottomLine(borderColor: FlatWhite(), placeholderText: "Username")
        textFieldPassword.setBottomLine(borderColor: FlatWhite(), placeholderText: "Password")
        textFieldRepeatedPassword.setBottomLine(borderColor: FlatWhite(), placeholderText: "Repeat password")
        buttonSignUp.setBorder(borderColor: FlatWhite(), radius: 5.0, width: 2.0)
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


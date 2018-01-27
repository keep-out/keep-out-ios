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

class SignUpViewController: UIViewController {
    
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
        let email: String = textFieldEmail.text!
        let username: String = textFieldUsername.text!
        let password: String = textFieldPassword.text!
        let repeatedPassword: String = textFieldRepeatedPassword.text!
        
        if password != repeatedPassword {
            // Passwords don't match!
        } else {
            let parameters = [
                "username":username,
                "hash":password,
                "fname":fname,
                "lname":lname,
                "email":email,
                "hasTruck":false
                ] as [String : Any]
            
            Alamofire.request(SERVER_URL + REGISTER, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    print("User creation successful")
                    
                    let json = JSON(data)
                    let token = json["data"]["token"].string
                    self.defaults.set(token, forKey: "token")
                    self.performSegue(withIdentifier: "homeSegue", sender: sender)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func didTouchCancel(_ sender: Any) {
        performSegueToReturnBack()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = GradientColor(UIGradientStyle.leftToRight, frame: view.frame, colors: [FlatLime(), FlatGreen()])
        textFieldFirstName.setBottomLine(borderColor: FlatWhite(), placeholderText: "First name")
        textFieldLastName.setBottomLine(borderColor: FlatWhite(), placeholderText: "Last name")
        textFieldUsername.setBottomLine(borderColor: FlatWhite(), placeholderText: "Username")
        textFieldEmail.setBottomLine(borderColor: FlatWhite(), placeholderText: "Email")
        textFieldPassword.setBottomLine(borderColor: FlatWhite(), placeholderText: "Password")
        textFieldRepeatedPassword.setBottomLine(borderColor: FlatWhite(), placeholderText: "Repeat password")
        buttonSignUp.setBorder(borderColor: FlatWhite(), radius: 5.0, width: 2.0)
        
        // TODO: refactor and rethink necessary rules for each field
        var rules = ValidationRuleSet<String>()
        let testRule = ValidationRuleLength(min: 5, error: ValidationError(message: "😫"))
        rules.add(rule: testRule)
        textFieldFirstName.addValidation(rules: rules)
        textFieldLastName.addValidation(rules: rules)
        textFieldUsername.addValidation(rules: rules)
        textFieldEmail.addValidation(rules: rules)
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


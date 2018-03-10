//
//  SettingsViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 3/9/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework
import SwiftyJSON
import SwiftyBeaver
import SwiftKeychainWrapper
import FontAwesomeKit
import Moya

class SettingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    @IBAction func logoutButtonTouched(_ sender: Any) {
        // TODO: Display a confirmation modal to user
        
        // Remove token, userId from user defaults
        defaults.removeObject(forKey: "token")
        defaults.removeObject(forKey: "userId")
        // Remove username, password from keychain
        KeychainWrapper.standard.removeObject(forKey: "username")
        KeychainWrapper.standard.removeObject(forKey: "password")
        
        // TODO: Segue to login
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Options"
        view.backgroundColor = FlatWhite()
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

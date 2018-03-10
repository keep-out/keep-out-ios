//
//  ProfileViewController.swift
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

class ProfileViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var provider: MoyaProvider<Service>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Profile"
        view.backgroundColor = FlatWhite()
        
        self.navigationItem.rightBarButtonItem?.image = FAKFontAwesome.ellipsisHIcon(withSize: 25).image(with: CGSize(width: 30, height: 30))
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

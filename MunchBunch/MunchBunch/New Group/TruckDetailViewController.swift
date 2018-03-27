//
//  TruckDetailViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 3/26/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import ChameleonFramework
import SwiftyJSON
import SwiftyBeaver
import SwiftKeychainWrapper
import Kingfisher
import Moya

class TruckDetailViewController: UIViewController {
    // Outlets
    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var truckTitle: UILabel!
    // Data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = FlatWhite()
        truckImage.contentMode = UIViewContentMode.scaleAspectFill
        truckImage.clipsToBounds = true
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

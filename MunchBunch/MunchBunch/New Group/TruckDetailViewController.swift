//
//  TruckDetailViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 3/26/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import MapKit
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
    @IBOutlet weak var truckHandle: UIButton!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    
    // Data
    var imageURL: URL!
    var titleString: String!
    var handleString: String!
    var coordinate: CLLocationCoordinate2D!
    var address1String: String!
    var address2String: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        truckImage.contentMode = UIViewContentMode.scaleAspectFill
        truckImage.clipsToBounds = true
        truckImage.kf.setImage(with: imageURL)
        truckImage.alpha = 0.75
        truckTitle.text = titleString
        truckHandle.setTitle(handleString!, for: .normal)
        address1.text = address1String
        address2.text = address2String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getDirectionsTouched(_ sender: Any) {
        // Get directions to truck in maps app
        log.info("TODO: get directions to (\(coordinate.latitude), \(coordinate.longitude))")
        let regionDistance: CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(titleString!)"
        mapItem.openInMaps(launchOptions: options)
    }
}

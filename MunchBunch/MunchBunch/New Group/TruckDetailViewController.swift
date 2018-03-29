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
import FontAwesomeKit
import TwitterKit

class TruckDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var truckTitle: UILabel!
    @IBOutlet weak var truckPhone: UIButton!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var twitterFeedContainer: UIView!
    @IBOutlet weak var thumbsUp: UIButton!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var thumbsDown: UIButton!
    
    // Data
    var imageURL: URL!
    var titleString: String!
    var handleString: String!
    var phoneString: String!
    var rawPhoneString: String!
    var coordinate: CLLocationCoordinate2D!
    var address1String: String!
    var address2String: String!
    var ratingVal: Double!
    var locationManager: CLLocationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 10000
    let defaults = UserDefaults.standard
    var twitterViewController: TwitterViewController!
    
    // Thumbs up/down icons
    let thumbsUpIcon: UIImage = FAKFontAwesome.thumbsOUpIcon(withSize: 20).image(with: CGSize(width: 30, height: 30))
    let thumbsDownIcon: UIImage = FAKFontAwesome.thumbsODownIcon(withSize: 20).image(with: CGSize(width: 30, height: 30))
    let thumbsUpIconSelected: UIImage = FAKFontAwesome.thumbsUpIcon(withSize: 20).image(with: CGSize(width: 30, height: 30))
    let thumbsDownIconSelected: UIImage = FAKFontAwesome.thumbsDownIcon(withSize: 20).image(with: CGSize(width: 30, height: 30))
    var thumbsUpSelected: Bool = false
    var thumbsDownSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = UIColor(red:0.88, green:0.91, blue:0.91, alpha:1.0)
        
        // Top view
        topView.layer.cornerRadius = 3
        topView.clipsToBounds = true
        
        // Middle view
        middleView.layer.cornerRadius = 3
        middleView.clipsToBounds = true
        
        // Twitter feed view
        twitterFeedContainer.layer.cornerRadius = 3
        twitterFeedContainer.clipsToBounds = true
        
        getDirectionsButton.layer.cornerRadius = 3
        truckImage.contentMode = UIViewContentMode.scaleAspectFill
        truckImage.clipsToBounds = true
        truckImage.kf.setImage(with: imageURL)
        truckImage.alpha = 0.85
        truckTitle.text = titleString
        if phoneString != nil {
            truckPhone.setTitle(phoneString!, for: .normal)
        } else {
            truckPhone.setTitle("No phone available", for: .normal)
        }
        address1.text = address1String
        address2.text = address2String
        thumbsUp.setImage(thumbsUpIcon, for: .normal)
        thumbsUp.tintColor = FlatGreen()
        thumbsDown.setImage(thumbsDownIcon, for: .normal)
        thumbsDown.tintColor = FlatRed()
        rating.text = "\(Int(ratingVal * 100))%"
        if ratingVal < 0.69 {
            rating.textColor = FlatRed()
        } else {
            rating.textColor = FlatGreen()
        }
        
        // Twitter init
        twitterViewController = TwitterViewController(handle: handleString!)
        self.addChildViewController(twitterViewController)
        self.twitterFeedContainer.addSubview(twitterViewController.view)
        twitterViewController.view.frame = CGRect(x: 0, y: 0, width: twitterFeedContainer.frame.width, height: twitterFeedContainer.frame.height)
        twitterViewController.didMove(toParentViewController: self)
        
        // mapView init
        mapView.delegate = self
        mapView.showsUserLocation = false
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
        }
        let annotation: SimpleTruck = SimpleTruck(latitude: coordinate.latitude, longitude: coordinate.longitude)
        annotation.title = titleString!
        if phoneString != nil {
            annotation.subtitle = phoneString!
        }
        mapView.addAnnotation(annotation)
        let location: CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        centerMapOnLocation(location, mapView: mapView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func getDirectionsTouched(_ sender: Any) {
        // Get directions to truck in maps app
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
    
    @IBAction func phoneButtonTouched(_ sender: Any) {
        // Call phone number
        if phoneString != nil {
            log.info("Phone call initiated")
            guard let number = URL(string: "tel://\(rawPhoneString)") else { return }
            UIApplication.shared.open(number)
        }
    }
    
    @IBAction func thumbsUpTouched(_ sender: Any) {
        if (!thumbsUpSelected) {
            thumbsUp.setImage(thumbsUpIconSelected, for: .normal)
            thumbsUpSelected = true;
            // TODO: Add thumbs up
            // Check if thumbs down selected (if so, then undo thumbs down)
            if (thumbsDownSelected) {
                thumbsDown.setImage(thumbsDownIcon, for: .normal)
                thumbsDownSelected = false
                // TODO: Undo thumbs down
            }
        } else {
            thumbsUp.setImage(thumbsUpIcon, for: .normal)
            thumbsUpSelected = false;
            // TODO: Undo thumbs up
        }
    }
    
    @IBAction func thumbsDownTouched(_ sender: Any) {
        if (!thumbsDownSelected) {
            thumbsDown.setImage(thumbsDownIconSelected, for: .normal)
            thumbsDownSelected = true;
            // TODO: Add thumbs down
            // Check if thumbs up selected (if so, then undo thumbs up)
            if (thumbsUpSelected) {
                thumbsUp.setImage(thumbsUpIcon, for: .normal)
                thumbsUpSelected = true
                // TODO: Undo thumbs up
            }
        } else {
            thumbsDown.setImage(thumbsDownIcon, for: .normal)
            thumbsDownSelected = false;
            // Undo thumbs down
        }
    }
}

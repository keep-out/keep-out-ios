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

class TruckDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var truckTitle: UILabel!
    @IBOutlet weak var truckPhone: UIButton!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var truckHandle: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var twitterFeed: UITableView!
    
    // Data
    var imageURL: URL!
    var titleString: String!
    var handleString: String!
    var phoneString: String!
    var rawPhoneString: String!
    var coordinate: CLLocationCoordinate2D!
    var address1String: String!
    var address2String: String!
    var locationManager: CLLocationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 10000
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        truckHandle.text = handleString
        
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
    
}

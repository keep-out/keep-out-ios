//
//  MapViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/15/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation
import SwiftyJSON
import SwiftyBeaver

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    let regionRadius: CLLocationDistance = 40000
    
    let defaults = UserDefaults.standard
    
    var trucks: [Truck] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Map"
        
        // Initialize mapView, get nearby trucks, annotate mapView
        // TODO: Set to user's current location
        let initialLocation = CLLocation(latitude: 34.0224, longitude: -118.2851)
        centerMapOnLocation(location: initialLocation)
        mapView.addAnnotations(Trucks.trucks)
        
//        if let token = defaults.object(forKey: "token") as? String {
//
//            // Create auth header
//            let headers: HTTPHeaders = [ "x-access-token":token ]
//
//            Alamofire.request(SERVER_URL + TRUCKS, method: .get, headers: headers).responseJSON {
//                response in
//                // Parse trucks response
//                switch response.result {
//                case .success(let data):
//                    print("Get trucks successful")
//                    let json = JSON(data)
//                    let trucksJSON: [JSON] = json["data"].arrayValue
//                    // TODO: Remove this when tested
//                    for i in 0..<trucksJSON.count {
//                        let truck = trucksJSON[i]["name"].string!
//                        print(truck)
//                    }
//                    // Parse truck json data into Truck objects
//                    // self.trucks = self.parseTrucks(trucksJSON: trucksJSON)
//                    // self.addTrucksToMapView(trucks: self.trucks)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func parseTrucks(trucksJSON: [JSON]) -> [Truck] {
//        var trucks: [Truck] = []
//        for i in 0..<trucksJSON.count {
//            let id = trucksJSON[i]["id"].int!
//            let name = trucksJSON[i]["name"].string!
//            let phone = trucksJSON[i]["phone"].string!
//            
//            // TODO: Check if truck is currently broadcasting location
//            let latitude = trucksJSON[i]["coordinate"]["latitude"].double!
//            let longitude = trucksJSON[i]["coordinate"]["longitude"].double!
//            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
//            let truck = Truck(id: id, name: name, phone: phone, coordinate: coordinate)
//            trucks.append(truck)
//        }
//        return trucks
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion (center:  location,span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
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

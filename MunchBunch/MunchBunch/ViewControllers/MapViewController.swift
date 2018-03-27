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

private let kTruckAnnotationName = "kTruckAnnotationName"

class MapViewController: UIViewController, CLLocationManagerDelegate,
MKMapViewDelegate, TruckDetailMapViewDelegate {
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // Data
    var locationManager: CLLocationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 10000
    var selectedTruck: Truck?
    
    let defaults = UserDefaults.standard
    
    var trucks: [Truck] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(Trucks.trucks)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Map"
        
        // Initialize mapView, get nearby trucks, annotate mapView
        // TODO: Set to user's current location
        
        // mapView.register(TruckView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 10000, 10000)
        mapView.setRegion(viewRegion, animated: false)
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion (center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
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

extension MapViewController {
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        let visibleRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000)
//        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: kTruckAnnotationName)
        
        if annotationView == nil {
            annotationView = TruckView(annotation: annotation, reuseIdentifier: kTruckAnnotationName)
            (annotationView as! TruckView).truckDetailDelegate = self
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        // performSegue(withIdentifier: "amazeBowlSegue", sender: self)
        let location = view.annotation as! Truck
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func detailsRequestedForTruck(truck: Truck) {
        self.selectedTruck = truck
    }
    
}

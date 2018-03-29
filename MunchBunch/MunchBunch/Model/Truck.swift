//
//  Truck.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/17/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import Contacts

class Truck: NSObject, MKAnnotation {

    let id: Int
    let handle: String
    let url: URL
    let name: String
    let phone: String
    var address1: String
    var address2: String
    let rating: Double
    let dateOpen: String
    let timeOpen: String
    let broadcasting: Bool
    let title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(id: Int, handle: String?, url: String?, name: String, phone: String?, rating: Double, dateOpen: String?, timeOpen: String?, broadcasting: Bool, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.handle = handle == nil ? "No twitter account" : "@\(handle!)"
        self.url = url == nil ? URL(string: "https://s3-us-west-1.amazonaws.com/api.truck-profile-images.munch-bunch/not-available.png")! : URL(string: url!)!
        self.name = name
        self.phone = phone == nil ? "No phone number available" : phone!
        self.address1 = ""
        self.address2 = ""
        self.rating = rating
        self.dateOpen = dateOpen == nil ? "" : dateOpen!
        self.timeOpen = timeOpen == nil ? "" : dateOpen!
        self.broadcasting = broadcasting
        self.title = name
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return phone
    }
    
    // Update the coordinate
    func updateCoordinate(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

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

class Truck: NSObject, MKAnnotation {

    let id: Int
    let handle: String
    let url: URL
    let name: String
    let phone: String
    let address: String
    let dateOpen: String
    let timeOpen: String
    let broadcasting: Bool
    let title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(id: Int, handle: String, url: URL, name: String, phone: String, address: String,
         dateOpen: String, timeOpen: String, broadcasting: Bool, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.handle = handle
        self.url = url
        self.name = name
        self.phone = phone == "" ? "No phone number available" : phone
        self.address = address
        self.dateOpen = dateOpen
        self.timeOpen = timeOpen
        self.broadcasting = broadcasting
        self.title = name
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
    
    // Update the coordinate
    func updateCoordinate(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

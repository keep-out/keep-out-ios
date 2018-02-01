//
//  Truck.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/17/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation
import MapKit

// class Truck: NSObject, MKAnnotation {
class Truck: NSObject {
    
    let id: Int
    let name: String
    let phone: String
    let address: String
    let city: String
    let state: String
    let zip: Int
    // let coordinate: CLLocationCoordinate2D
    
    init(id: Int, name: String, phone: String, address: String,
         city: String, state: String, zip: Int) {
        self.id = id
        self.name = name
        self.phone = phone == "" ? "No phone number available" : phone
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        
        // let addr = "\(address), \(city), \(state) \(zip)"
        // let temp = addrToCoord(address: addr)
        // self.coordinate = temp! == nil ? temp! : CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        super.init()
    }
}

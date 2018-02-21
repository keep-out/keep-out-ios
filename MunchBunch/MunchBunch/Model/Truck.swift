//
//  Truck.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/17/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation
import MapKit

//truck_id SERIAL,
//twitter_handle TEXT,
//url TEXT,
//name TEXT NOT NULL,
//phone TEXT,
//address TEXT,
//date_open DATE,
//time_open TIME,
//time_range INTEGER,
//broadcasting BOOLEAN NOT NULL,
//CONSTRAINT trucks_pkey PRIMARY KEY (truck_id)

// class Truck: NSObject, MKAnnotation {
class Truck: NSObject {
    
    let id: Int
    let handle: String
    let url: URL
    let name: String
    let phone: String
    let address: String
    let dateOpen: String
    let timeOpen: Int
    let broadcasting: Bool
    // let coordinate: CLLocationCoordinate2D
    
    init(id: Int, handle: String, url: URL, name: String, phone: String, address: String,
         dateOpen: String, timeOpen: Int, broadcasting: Bool) {
        self.id = id
        self.handle = handle
        self.url = url
        self.name = name
        self.phone = phone == "" ? "No phone number available" : phone
        self.address = address
        self.dateOpen = dateOpen
        self.timeOpen = timeOpen
        self.broadcasting = broadcasting
        
        // let addr = "\(address), \(city), \(state) \(zip)"
        // let temp = addrToCoord(address: addr)
        // self.coordinate = temp! == nil ? temp! : CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        super.init()
    }
}

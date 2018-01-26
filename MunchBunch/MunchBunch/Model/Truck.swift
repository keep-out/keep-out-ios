//
//  Truck.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/17/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation
import MapKit

class Truck: NSObject, MKAnnotation {
    
    let id: Int
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(id: Int, name: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        
        super.init()
    }
}

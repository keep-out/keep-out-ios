//
//  SimpleTruck.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 3/28/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class SimpleTruck: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        
        super.init()
    }
}

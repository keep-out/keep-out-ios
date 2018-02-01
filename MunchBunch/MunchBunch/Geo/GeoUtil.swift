//
//  GeoUtil.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/30/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation
import CoreLocation

func addrToCoord(address: String) -> CLLocationCoordinate2D? {
    var coordinate: CLLocationCoordinate2D?
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) {
        placemarks, error in
        let placemark = placemarks?.first
        let lat = placemark?.location?.coordinate.latitude
        let lon = placemark?.location?.coordinate.longitude
        if (lat != nil && lon != nil) {
            coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        }
    }
    return coordinate
}

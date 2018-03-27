//
//  TruckDetailMapView.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 3/25/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import ChameleonFramework
import Kingfisher

protocol TruckDetailMapViewDelegate: class {
    func detailsRequestedForTruck(truck: Truck)
}

class TruckDetailMapView: UIView {
    // Outlets

    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var truckTitle: UILabel!
    @IBOutlet weak var truckPhone: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    // Data
    var truck: Truck!
    weak var delegate: TruckDetailMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
    func configureWithTruck(truck: Truck) {
        self.truck = truck
        
        // Set up rest of view
        truckImage.contentMode = UIViewContentMode.scaleAspectFill
        truckImage.clipsToBounds = true
        truckImage.kf.setImage(with: truck.url)
        truckTitle.text = truck.name
        truckPhone.text = formatPhone(phoneNumber: truck.phone)
    }
    
    func formatPhone(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    @IBAction func detailButtonPressed(_ sender: Any) {
        // TODO: Segue to truck detail view
    }
    //    // MARK: - Hit test. We need to override this to detect hits in our custom callout
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        // Check if it hit our annotation detail view components
//        // TODO: Add button to segue to other detail view
//
//        // Fallback to our background content view
//        // TODO: Figure this out
//        return nil
//    }
}

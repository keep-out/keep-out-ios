//
//  TruckView.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 3/24/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation
import MapKit
import SpriteKit

private let kTruckMapPinImage = UIImage(named: "mapPin512")!
private let kTruckMapAnimationTime = 0.300

class TruckView: MKAnnotationView {
    // Data
    weak var truckDetailDelegate: TruckDetailMapViewDelegate?
    weak var customCalloutView: TruckDetailMapView?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        
        let nodeTexture = SKTexture(imageNamed: "mapPin512")
        nodeTexture.filteringMode = .nearest
        let node = SKSpriteNode(texture: nodeTexture)
        let image = UIImage(cgImage: (node.texture?.cgImage())!)
        self.image = resizeImage(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false
        
        let nodeTexture = SKTexture(imageNamed: "mapPin512")
        nodeTexture.filteringMode = .nearest
        let node = SKSpriteNode(texture: nodeTexture)
        let image = UIImage(cgImage: (node.texture?.cgImage())!)
        self.image = resizeImage(image: image)
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let tempImage = kTruckMapPinImage
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        tempImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    // MARK: - callout showing and hiding
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.customCalloutView?.removeFromSuperview() // Remove old custome callout (if any)
            
            if let newCustomCalloutView = loadTruckDetailMapView() {
                // Fix location from top-left to its right place
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // Set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                // Animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: kTruckMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // Fade out animation, then remove it
                    UIView.animate(withDuration: kTruckMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else {
                    self.customCalloutView!.removeFromSuperview() // Just remove it
                }
            }
        }
    }
    
    func loadTruckDetailMapView() -> TruckDetailMapView? {
        if let views = Bundle.main.loadNibNamed("TruckDetailMapView", owner: self, options: nil) as? [TruckDetailMapView], views.count > 0 {
            let truckDetailMapView = views.first!
            truckDetailMapView.delegate = self.truckDetailDelegate
            if let truck = annotation as? Truck {
                truckDetailMapView.configureWithTruck(truck: truck)
            }
            return truckDetailMapView
        }
        return nil
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else { // Test in our custom callout
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else { return nil }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}

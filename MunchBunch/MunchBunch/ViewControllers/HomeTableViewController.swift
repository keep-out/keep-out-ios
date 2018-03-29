//
//  HomeTableViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/28/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import ChameleonFramework
import SwiftyJSON
import SwiftyBeaver
import SwiftKeychainWrapper
import Kingfisher
import CRRefresh
import Moya

struct Trucks {
    static var trucks: [Truck] = []
}

class HomeTableViewController: UITableViewController, TruckTableViewCellDelegate,
    CLLocationManagerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let defaults = UserDefaults.standard
    var provider: MoyaProvider<Service>?
    let locationManager = CLLocationManager()
    
    // Empty array of trucks that will be filled on load and on
    // table view refresh
    var images: [UIImage] = []
    // Bookmarked truckIds
    var bookmarkIds: [Int] = []
    
    var offset: Int = 0
    var lastItems: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        self.navigationItem.title = "Home"
        view.backgroundColor = FlatWhite()
        self.tableView.rowHeight = 80
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.separatorInset = .zero
        self.tableView.separatorColor = FlatWhite()
        
        isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
        
        if let lat = defaults.object(forKey: "latitude") as? Float {
            if let long = defaults.object(forKey: "longitude") as? Float {
                self.tableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
                    // TODO: Make network request to update trucks
                    Trucks.trucks.removeAll()
                    self?.bookmarkIds.removeAll()
                    self?.offset = 0
                    self?.lastItems = false
                    // Get JWT or refresh if expired
                    if let token = self?.defaults.object(forKey: "token") as? String {
                        self?.provider = MoyaProvider<Service>(plugins: [AuthPlugin(token: token)])
                        // loadTrucks(token: token)
                        let userId: Int! = self!.defaults.object(forKey: "userId") as? Int
                        self?.provider!.request(.getAllBookmarks(id: userId)) { result in
                            switch result {
                            case let .success(response):
                                let bookmarks = JSON(response.data)
                                let bookmarksArray: [JSON] = bookmarks["data"].arrayValue
                                for i in 0..<bookmarksArray.count {
                                    self?.bookmarkIds.append(bookmarksArray[i]["truck_id"].int!)
                                }
                            case let .failure(error):
                                log.error(error)
                            }
                        }
                        self?.provider!.request(.getLocalTrucks(lat: lat, long: long, radius: 8000, offset: (self?.offset)!)) { result in
                            switch result {
                            case let .success(response):
                                let json = JSON(response.data)
                                let jsonArray: [JSON] = json["data"].arrayValue
                                Trucks.trucks = (self?.parseTrucks(trucksJSON: jsonArray))!
                                DispatchQueue.main.async {
                                    self?.tableView.reloadData()
                                }
                            case let .failure(error):
                                log.error(error)
                            }
                        }
                    } else {
                        // Get new JWT
                        let username: String = KeychainWrapper.standard.string(forKey: "username")!
                        let password: String = KeychainWrapper.standard.string(forKey: "password")!
                        let parameters = [
                            "username":username,
                            "password":password
                        ]
                        Alamofire.request(SERVER_URL + AUTHENTICATE, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                            switch response.result {
                            case .success(let data):
                                log.info("JWT refreshed")
                                
                                let json = JSON(data)
                                let token = json["data"]["token"].string
                                self?.defaults.set(token, forKey: "token")
                                
                            // Need to handle network error - user will not be able to access page
                            case .failure(let error):
                                log.error(error)
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self?.tableView.reloadData()
                        self?.tableView.cr.endHeaderRefresh()
                        self?.tableView.cr.resetNoMore()
                    })
                }
                self.tableView.cr.beginHeaderRefresh()
                // Adds edit bar button item to the nav bar
                // self.navigationItem.rightBarButtonItem = self.editButtonItem
            }
        }
    }
    
    func parseTrucks(trucksJSON: [JSON]) -> [Truck] {
        var trucks: [Truck] = []
        for i in 0..<trucksJSON.count {
            let id = trucksJSON[i]["truck_id"].int!
            let handle = trucksJSON[i]["twitter_handle"].string
            let url = trucksJSON[i]["url"].string
            let name = trucksJSON[i]["name"].string!
            let phone = trucksJSON[i]["phone"].string
            // TODO: Get address from coordinates
//            let address = trucksJSON[i]["address"].string
            let latitude = trucksJSON[i]["latitude"].double!
            let longitude = trucksJSON[i]["longitude"].double!
            let rating = trucksJSON[i]["rating"].double!
            let dateOpen = trucksJSON[i]["date_open"].string
            let timeOpen = trucksJSON[i]["time_open"].string
            let broadcasting = trucksJSON[i]["broadcasting"].bool!
            let location = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
            
            // Create the truck object
            let truck = Truck(id: id, handle: handle, url: url, name: name,
                              phone: phone, rating: rating, dateOpen: dateOpen,
                              timeOpen: timeOpen, broadcasting: broadcasting, coordinate: location)
            trucks.append(truck)
            
            geocode(latitude: truck.coordinate.latitude, longitude: truck.coordinate.longitude) {
                placemark, error in
                guard let placemark = placemark, error == nil else { return }
                DispatchQueue.main.async {
                    truck.address1 = "\(placemark.subThoroughfare ?? "") \(placemark.thoroughfare ?? "")"
                    truck.address2 = "\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")"
                }
            }
        
        }
        return trucks
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        defaults.set(locValue.latitude, forKey: "latitude")
        defaults.set(locValue.longitude, forKey: "longitude")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
    func addressFromString(address: String, completion: @escaping (CLLocationCoordinate2D!) -> () ) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            completion(location.coordinate)
        }
    }
    
    // MARK - POC of DZEmptyDataSet
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No nearby trucks"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = ""
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Refresh Data"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        if let lat = defaults.object(forKey: "latitude") as? Float {
            if let long = defaults.object(forKey: "longitude") as? Float {
                self.provider!.request(.getLocalTrucks(lat: lat, long: long, radius: 8000, offset: self.offset)) { result in
                    switch result {
                    case let .success(response):
                        let json = JSON(response.data)
                        let jsonArray: [JSON] = json["data"].arrayValue
                        Trucks.trucks = (self.parseTrucks(trucksJSON: jsonArray))
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case let .failure(error):
                        log.error(error)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Table view data source
extension HomeTableViewController {
    
    // Helper method to reverse geocode a coordinate to a readable address string
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    // If we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Trucks.trucks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "localTruckCell", for: indexPath) as! TruckTableViewCell
        cell.truckTableViewCellDelegate = self
        cell.tag = indexPath.row
        let truck: Truck = Trucks.trucks[indexPath.row]
        let truckId: Int = truck.id
        if (bookmarkIds.contains(truckId)) {
            cell.setSelected()
        }
        cell.selectionStyle = .none
        cell.nameLabel.text = truck.name
        cell.address1Label.text = truck.address1
        cell.address2Label.text = truck.address2
        
        cell.distanceLabel.text = "\(String(format: "%.01f", getDistanceToTruck(truck: truck))) mi"
        cell.truckImage.kf.setImage(with: truck.url)
        return cell
    }
    
    // Cell tapped, create and show truck detail view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination: TruckDetailViewController = TruckDetailViewController() // Truck detail view
        let truck: Truck = Trucks.trucks[indexPath.row]
        destination.imageURL = truck.url
        destination.titleString = truck.name
        destination.handleString = truck.handle
        destination.phoneString = formatPhone(phoneNumber: truck.phone)
        destination.rawPhoneString = truck.phone.digits
        destination.coordinate = truck.coordinate
        destination.address1String = truck.address1
        destination.address2String = truck.address2
        destination.ratingVal = truck.rating
        navigationController?.pushViewController(destination, animated: true)

    }
    
    func getDistanceToTruck(truck: Truck) -> Double {
        let userLat = defaults.object(forKey: "latitude") as! Double
        let userLong = defaults.object(forKey: "longitude") as! Double
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
        let truckLocation = CLLocation(latitude: truck.coordinate.latitude, longitude: truck.coordinate.longitude)
        let distanceInMeters = userLocation.distance(from: truckLocation)
        return distanceInMeters / 1609.34 // Convert to miles
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = Trucks.trucks.count - 1
        // Scrolled to last item in current view
        if indexPath.row == lastElement && !lastItems {
            self.offset += 10
            let lat: Float = defaults.object(forKey: "latitude") as! Float
            let long: Float = defaults.object(forKey: "longitude") as! Float
            // Load more trucks
            self.provider!.request(.getLocalTrucks(lat: lat, long: long, radius: 8000, offset: self.offset)) { result in
                switch result {
                case let .success(response):
                    let json = JSON(response.data)
                    let jsonArray: [JSON] = json["data"].arrayValue
                    if (jsonArray.count < 10) {
                        // Reached the end, set end flag to true
                        self.lastItems = true
                    }
                    Trucks.trucks.append(contentsOf: self.parseTrucks(trucksJSON: jsonArray))
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case let .failure(error):
                    log.error(error)
                }
            }
        }
    }
    
    func didPressButton(_ tag: Int, _ followed: Bool) {
        let truck: Truck = Trucks.trucks[tag]
        // Get truckId and userId
        let truckId: Int = truck.id
        let userId: Int = (defaults.object(forKey: "userId") as? Int)!
        if (followed) {
            // Add bookmark
            provider!.request(.addBookmark(userId: userId, truckId: truckId)) { result in
                switch result {
                case .success(_):
                    log.info("added bookmark")
                case let .failure(error):
                    log.error(error)
                }
            }
        } else {
            // Delete bookmark
            provider!.request(.deleteBookmark(userId: userId, truckId: truckId)) { result in
                switch result {
                case .success(_):
                    log.info("deleted bookmark")
                case let .failure(error):
                    log.error(error)
                }
            }
        }
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
}

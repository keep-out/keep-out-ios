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

class HomeTableViewController: UITableViewController, TruckTableViewCellDelegate {
    
    let defaults = UserDefaults.standard
    var provider: MoyaProvider<Service>?
    
    // Empty array of trucks that will be filled on load and on
    // table view refresh
    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        view.backgroundColor = FlatWhite()
        self.tableView.rowHeight = 80
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.separatorInset = .zero
        self.tableView.separatorColor = FlatWhite()
        
        self.tableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            print("Refresh")
            // TODO: Make network request to update trucks
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.tableView.reloadData()
                self?.tableView.cr.endHeaderRefresh()
                self?.tableView.cr.resetNoMore()
            })
        }
    
        // Get JWT or refresh if expired
        if let token = defaults.object(forKey: "token") as? String {
            provider = MoyaProvider<Service>(plugins: [AuthPlugin(token: token)])
            // loadTrucks(token: token)
            provider!.request(.getAllTrucks) { result in
                switch result {
                case let .success(response):
                    let json = JSON(response.data)
                    let jsonArray: [JSON] = json["data"].arrayValue
                    Trucks.trucks = self.parseTrucks(trucksJSON: jsonArray)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
                    self.defaults.set(token, forKey: "token")
                
                // Need to handle network error - user will not be able to access page
                case .failure(let error):
                    print(error)
                }
            }
        }

        // Adds edit bar button item to the nav bar
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func parseTrucks(trucksJSON: [JSON]) -> [Truck] {
        var trucks: [Truck] = []
        for i in 0..<trucksJSON.count {
            let id = trucksJSON[i]["truck_id"].int!
            let handle = trucksJSON[i]["twitter_handle"].string!
            let url = URL(string: trucksJSON[i]["url"].string!)
            let name = trucksJSON[i]["name"].string!
            let phone = trucksJSON[i]["phone"].string!
            let address = trucksJSON[i]["address"].string!
            let dateOpen = trucksJSON[i]["date_open"].string!
            let timeOpen = trucksJSON[i]["time_open"].string!
            let broadcasting = trucksJSON[i]["broadcasting"].bool!
            let location = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
            // Create the truck object
            let truck = Truck(id: id, handle: handle, url: url!, name: name,
                              phone: phone, address: address, dateOpen: dateOpen,
                              timeOpen: timeOpen, broadcasting: broadcasting, coordinate: location)
            trucks.append(truck)
            
            addressFromString(address: address, completion: {
                coordinate in
                truck.updateCoordinate(coordinate: coordinate)
            })
        
        }
        log.info("Done parsing trucks")
        return trucks
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Table view data source
extension HomeTableViewController {
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
        cell.selectionStyle = .none
        cell.nameLabel.text = truck.name
        cell.address1Label.text = truck.address
        cell.truckImage.kf.setImage(with: truck.url)
        return cell
    }
    
    func didPressButton(_ tag: Int, _ followed: Bool) {
        let truck: Truck = Trucks.trucks[tag]
        // Get truckId and userId
        let truckId: Int = truck.id
        let userId: Int = (defaults.object(forKey: "userId") as? Int)!
        print("truckId: \(truckId), userId: \(userId)")
    }
}

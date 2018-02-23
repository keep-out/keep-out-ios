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

struct Trucks {
    static var trucks: [Truck] = []
}

class HomeTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    // Empty array of trucks that will be filled on load and on
    // table view refresh
    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        view.backgroundColor = FlatWhite()
        self.tableView.rowHeight = 90
    
        // Get JWT or refresh if expired
        if let token = defaults.object(forKey: "token") as? String {
            loadTrucks(token: token)
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadTrucks(token: String) {
        log.info("Token: \(token)")
        let headers: HTTPHeaders = [ "x-access-token":token ]
        Alamofire.request(SERVER_URL + TRUCKS, method: .get, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let data):
                log.info("Get trucks successful")
                let json = JSON(data)
                let trucksJSON: [JSON] = json["data"].arrayValue
                Trucks.trucks = self.parseTrucks(trucksJSON: trucksJSON)
                // TODO: Pull truck images from S3
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
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
            var coordinate = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
                }
                coordinate = location.coordinate
            }
            
            // Create the truck object
            let truck = Truck(id: id, handle: handle, url: url!, name: name,
                phone: phone, address: address, dateOpen: dateOpen,
                timeOpen: timeOpen, broadcasting: broadcasting, coordinate: coordinate)
            trucks.append(truck)
        }
        log.info("Done parsing trucks")
        return trucks
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log.info("# of trucks: \(Trucks.trucks.count)")
        return Trucks.trucks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "localTruckCell", for: indexPath) as! TruckTableViewCell
        
        let truck: Truck = Trucks.trucks[indexPath.row]
        
        cell.selectionStyle = .none
        cell.nameLabel.text = truck.name
        cell.address1Label.text = truck.address
        cell.truckImage.kf.setImage(with: truck.url)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

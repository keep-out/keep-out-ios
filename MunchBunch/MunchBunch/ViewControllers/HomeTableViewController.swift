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

class HomeTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    // Empty array of trucks that will be filled on load and on
    // table view refresh
    var trucks: [Truck] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        view.backgroundColor = FlatWhite()
        
        if let token = defaults.object(forKey: "token") as? String {
            loadTrucks(token: token)
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                self.trucks = self.parseTrucks(trucksJSON: trucksJSON)
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
            let id = trucksJSON[i]["id"].int!
            let name = trucksJSON[i]["name"].string!
            let phone = trucksJSON[i]["phone"].string!
            
            // TODO: Check if truck is currently broadcasting location
            let latitude = trucksJSON[i]["latitude"].double!
            let longitude = trucksJSON[i]["longitude"].double!
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let truck = Truck(id: id, name: name, phone: phone, coordinate: coordinate)
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        log.info("# of trucks: \(trucks.count)")
        return trucks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "localTruckCell", for: indexPath) as! TruckTableViewCell
        
        let truck: Truck = trucks[indexPath.row]
        
        cell.textLabel?.text = truck.name + " " + truck.phone

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

//
//  ProfileViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/30/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import Alamofire
import ChameleonFramework
import SwiftyJSON
import SwiftyBeaver
import CoreLocation

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.width/2
            profileImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followedLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    let defaults = UserDefaults.standard
    var userId: Int = 0
    var trucks: [Truck] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        view.backgroundColor = FlatWhite()
        self.profileTableView.rowHeight = 100;
        self.usernameLabel.textColor = FlatGreen()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let token = defaults.object(forKey: "token") as? String {
            userId = (defaults.object(forKey: "userId") as? Int)!
            loadUserInfo(token: token)
        }
    }
    
    func loadUserInfo(token: String) {
        if (userId != 0) {
            let url: String = SERVER_URL + USERS + "/" + String(userId)
            let headers: HTTPHeaders = [ "x-access-token":token ]
            Alamofire.request(url, method: .get, headers: headers).responseJSON {
                response in
                switch response.result {
                case .success(let data):
                    log.info("Got user info")
                    let json = JSON(data)
                    self.usernameLabel.text = "@\(json["data"]["username"].string!)"
                    self.nameLabel.text =
                        "\(json["data"]["first_name"].string!) \(json["data"]["last_name"].string!)"
                    self.followedLabel.text = "\(BookmarkedTrucks.trucks.count) trucks followed"
                    self.profileImageView.image = #imageLiteral(resourceName: "defaultUser")
                    self.profileImageView.layer.borderWidth = 3
                    self.profileImageView.layer.borderColor = FlatGray().cgColor
                case .failure(let error):
                    log.error(error)
                }
            }
        }
    }
    
    // TODO: Refactor code to keep networking logic in separate file for better reuse
//    func loadTrucks(token: String) {
//        log.info("Token: \(token)")
//        let headers: HTTPHeaders = [ "x-access-token":token ]
//        Alamofire.request(SERVER_URL + TRUCKS, method: .get, headers: headers).responseJSON {
//            response in
//            switch response.result {
//            case .success(let data):
//                log.info("Get trucks successful")
//                let json = JSON(data)
//                let trucksJSON: [JSON] = json["data"].arrayValue
//                self.trucks = self.parseTrucks(trucksJSON: trucksJSON)
//                DispatchQueue.main.async {
//                    self.profileTableView.reloadData()
//                }
//                self.view.hideSkeleton()
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    func parseTrucks(trucksJSON: [JSON]) -> [Truck] {
//        var trucks: [Truck] = []
//        for i in 0..<trucksJSON.count {
//            let id = trucksJSON[i]["id"].int!
//            let name = trucksJSON[i]["name"].string!
//            let phone = trucksJSON[i]["phone"].string!
//            
//            // TODO: Check if truck is currently broadcasting location
//            let latitude = trucksJSON[i]["latitude"].double!
//            let longitude = trucksJSON[i]["longitude"].double!
//            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
//            let truck = Truck(id: id, name: name, phone: phone, coordinate: coordinate)
//            trucks.append(truck)
//        }
//        log.info("Done parsing trucks")
//        return trucks
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trucks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        cell.cellTitle.text = "\(trucks[indexPath.row].name)"
        cell.cellDescription.text = "\(trucks[indexPath.row].phone)"
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

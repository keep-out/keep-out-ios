//
//  BookmarksTableViewController.swift
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

struct BookmarkedTrucks {
    static var trucks: [Truck] = []
}

class BookmarksTableViewController: UITableViewController, TruckTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    let defaults = UserDefaults.standard
    var provider: MoyaProvider<Service>?
    
    // Empty array of trucks that will be filled on load and on
    // table view refresh
    var images: [UIImage] = []
    // Bookmarked truckIds
    var bookmarkIds: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        self.navigationItem.title = "Bookmarks"
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
            let userId: Int! = self.defaults.object(forKey: "userId") as? Int
            provider!.request(.getAllBookmarks(id: userId)) { result in
                switch result {
                case let .success(response):
                    let bookmarks = JSON(response.data)
                    let bookmarksArray: [JSON] = bookmarks["data"].arrayValue
                    for i in 0..<bookmarksArray.count {
                        self.bookmarkIds.append(bookmarksArray[i]["truck_id"].int!)
                    }
                case let .failure(error):
                    log.error(error)
                }
            }
            provider!.request(.getAllTrucks) { result in
                switch result {
                case let .success(response):
                    let json = JSON(response.data)
                    let jsonArray: [JSON] = json["data"].arrayValue
                    Trucks.trucks = self.parseTrucks(trucksJSON: jsonArray)
                    self.filterTrucks()
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
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    func filterTrucks() {
        for i in 0..<Trucks.trucks.count {
            if (bookmarkIds.contains(Trucks.trucks[i].id)) {
                BookmarkedTrucks.trucks.append(Trucks.trucks[i])
                print("Adding truck")
            }
        }
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
    
    // MARK - POC of DZEmptyDataSet
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Looks like you haven't followed any trucks yet."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Follow food trucks by tapping the bookmark icon to see them here."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "temp_food_truck")
    }
    
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
    //        let str = "Add Grokkleglob"
    //        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
    //        return NSAttributedString(string: str, attributes: attrs)
    //    }
    //
    //    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
    //        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
    //        ac.addAction(UIAlertAction(title: "Hurray", style: .default))
    //        present(ac, animated: true)
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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

// MARK: - Table view data source
extension BookmarksTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookmarkedTrucks.trucks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "localTruckCell", for: indexPath) as! TruckTableViewCell
        cell.truckTableViewCellDelegate = self
        cell.tag = indexPath.row
        let truck: Truck = BookmarkedTrucks.trucks[indexPath.row]
        cell.setSelected()
        cell.selectionStyle = .none
        cell.nameLabel.text = truck.name
        cell.address1Label.text = truck.address
        cell.address2Label.text = ""
        cell.truckImage.kf.setImage(with: truck.url)
        return cell
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
}

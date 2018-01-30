//
//  ProfileViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/30/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import SkeletonView
import ChameleonFramework

class ProfileViewController: UIViewController, UITableViewDelegate, SkeletonTableViewDataSource {

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
    
    override func viewDidAppear(_ animated: Bool) {
        view.showAnimatedSkeleton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        self.profileTableView.rowHeight = 100;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        cell.cellTitle.text = "Title \(indexPath.row)"
        cell.cellDescription.text = "Description \(indexPath.row)"
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdenfierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "profileCell"
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

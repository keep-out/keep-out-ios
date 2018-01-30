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

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make profileImageView circular
        initImageView(imageView: profileImageView)
        
        self.view.isSkeletonable = true
        profileImageView.isSkeletonable = true
        usernameLabel.isSkeletonable = true
        nameLabel.isSkeletonable = true
        
        self.view.showAnimatedSkeleton()
        
    }
    
    func initImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = profileImageView.frame.width / 2
        imageView.clipsToBounds = true
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

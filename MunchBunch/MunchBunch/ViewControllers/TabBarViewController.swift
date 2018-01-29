//
//  TabBarViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/28/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import ChameleonFramework
import FontAwesomeKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // Tab bar icons
    let tabIcons: [UIImage] = [
        FAKFontAwesome.homeIcon(withSize: 20)
            .image(with: CGSize(width: 30, height: 30)),
        FAKFontAwesome.mapIcon(withSize: 20)
            .image(with: CGSize(width: 30, height: 30)),
        FAKFontAwesome.bookmarkIcon(withSize: 20)
            .image(with: CGSize(width: 30, height: 30)),
        FAKFontAwesome.userIcon(withSize: 20)
            .image(with: CGSize(width: 30, height: 30))
    ]
    
    let homeIcon = FAKFontAwesome.homeIcon(withSize: 20)
    let mapIcon = FAKFontAwesome.mapIcon(withSize: 20)
    let bookmarkIcon = FAKFontAwesome.bookmarkIcon(withSize: 20)
    let userIcon = FAKFontAwesome.userIcon(withSize: 20)
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBar.tintColor = FlatGreen()
        if var tabBarItems = tabBar.items {
            for i in 0..<tabBarItems.count {
                tabBarItems[i].image = tabIcons[i]
            }
        }
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

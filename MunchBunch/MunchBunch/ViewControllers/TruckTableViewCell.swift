//
//  TruckTableViewCell.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/29/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import ChameleonFramework
import FontAwesomeKit

class TruckTableViewCell: UITableViewCell {

    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var followIcon: UIButton!
    
    // Follow icon
    let followIconUnselected: UIImage = FAKFontAwesome.bookmarkOIcon(withSize: 20).image(with: CGSize(width: 30, height: 30))
    let followIconSelected: UIImage =
        FAKFontAwesome.bookmarkIcon(withSize: 20).image(with:
            CGSize(width: 30, height: 30))
    var select: Bool = false;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        truckImage.layer.masksToBounds = true
        truckImage.layer.cornerRadius = 2
        nameLabel.textColor = FlatGreenDark()
        address1Label.textColor = FlatGrayDark()
        address2Label.textColor = FlatGrayDark()
        followIcon.setImage(followIconUnselected, for: .normal)
        followIcon.tintColor = FlatGreenDark()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func followIconTouched(_ sender: Any) {
        if (!select) {
            followIcon.setImage(followIconSelected, for: .normal)
            select = true;
        } else {
            followIcon.setImage(followIconUnselected, for: .normal)
            select = false;
        }
    }
    
}

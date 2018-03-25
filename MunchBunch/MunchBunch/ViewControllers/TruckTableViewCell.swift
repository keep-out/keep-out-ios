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
import Alamofire
import Moya

protocol TruckTableViewCellDelegate: class {
    func didPressButton(_ tag: Int, _ followed: Bool)
}

class TruckTableViewCell: UITableViewCell {

    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var followIcon: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    weak var truckTableViewCellDelegate: TruckTableViewCellDelegate?
    
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
    
    func setSelected() {
        followIcon.setImage(followIconSelected, for: .normal)
        select = true;
    }
    
    @IBAction func followIconTouched(_ sender: UIButton) {
        if (!select) {
            followIcon.setImage(followIconSelected, for: .normal)
            select = true;
            truckTableViewCellDelegate?.didPressButton(self.tag, true)
        } else {
            followIcon.setImage(followIconUnselected, for: .normal)
            select = false;
            truckTableViewCellDelegate?.didPressButton(self.tag, false)
        }
    }
    
}

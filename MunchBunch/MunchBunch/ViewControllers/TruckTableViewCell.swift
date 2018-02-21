//
//  TruckTableViewCell.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/29/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import ChameleonFramework

class TruckTableViewCell: UITableViewCell {

    @IBOutlet weak var truckImage: UIImageView!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        separatorLabel.backgroundColor = FlatWhite()
        nameLabel.textColor = FlatGreenDark()
        address1Label.textColor = FlatGrayDark()
        address2Label.textColor = FlatGrayDark()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

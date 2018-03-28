//
//  TwitterViewController.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 3/28/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import UIKit
import SwiftyBeaver
import TwitterKit

class TwitterViewController: TWTRTimelineViewController {

    convenience init(handle: String) {
        let client = TWTRAPIClient()
        let dataSource = TWTRUserTimelineDataSource(screenName: handle, apiClient: client)
        
        self.init(dataSource: dataSource)
    }
    
    override required init(dataSource: TWTRTimelineDataSource?) {
        super.init(dataSource: dataSource)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func formatHandle(handle: String) -> String {
        var result = handle
        result.removeFirst()
        return result
    }

}

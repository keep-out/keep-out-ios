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
        let dataSource = TWTRUserTimelineDataSource(screenName: handle, userID: nil, apiClient: client, maxTweetsPerRequest: 10, includeReplies: false, includeRetweets: false)
        self.init(dataSource: dataSource)
    }
    
    override required init(dataSource: TWTRTimelineDataSource?) {
        super.init(dataSource: dataSource)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func formatHandle(handle: String) -> String {
        var result = handle
        result.removeFirst()
        return result
    }
}

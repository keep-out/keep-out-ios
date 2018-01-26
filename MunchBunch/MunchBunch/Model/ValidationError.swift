//
//  ValidationError.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/18/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation

struct ValidationError: Error {
    public let message: String
    
    public init(message m: String) {
        message = m
    }
}

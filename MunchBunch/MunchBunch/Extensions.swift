//
//  Extensions.swift
//  MunchBunch
//
//  Created by Kevin Nguyen on 1/15/18.
//  Copyright © 2018 munch-bunch-app. All rights reserved.
//

import Foundation
import UIKit
import Validator

extension UITextField {
    func setBottomLine(borderColor: UIColor, placeholderText: String) {
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 2.0
        log.info(self.frame.width)
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
        
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
}

extension UIButton {
    func setBorder(borderColor: UIColor, radius: CGFloat, width: CGFloat) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
    }
}

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension UITextField {
    func addValidation(rules: ValidationRuleSet<String>) {
        self.validationRules = rules
        self.validationHandler = { result in
            switch result {
            case .valid:
                print("😀")
            case .invalid(let failures):
                let err: ValidationError = failures.first! as! ValidationError
                print(err.message)
            }
        }
        self.validateOnInputChange(enabled: true)
    }
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

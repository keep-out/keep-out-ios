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

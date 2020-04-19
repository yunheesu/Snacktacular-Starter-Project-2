//
//  UIView+addBorder.swift
//  Snacktacular
//
//  Created by Heesu Yun on 4/19/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBorder(width: CGFloat, radius: CGFloat, color: UIColor) {
        self.layer.borderWidth = width //self = the view (the nameField) as we called as an extension of nameField
        self.layer.borderColor = color.cgColor //cgColor converts to kind of color we need for border
        self.layer.cornerRadius = radius
    }
    
    func noBorder() {
        self.layer.borderWidth = 0.0
        
    }
}

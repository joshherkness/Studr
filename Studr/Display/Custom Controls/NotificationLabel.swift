//
//  NotificationLabel.swift
//  Studr
//
//  Created by Joshua Herkness on 11/5/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class NotificationLabel: UILabel {
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        var f = frame
        if (f.size.width < f.size.height){
            f.size.width = f.size.height
        }
        super.init(frame: f)
        
        self.textAlignment = NSTextAlignment.Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

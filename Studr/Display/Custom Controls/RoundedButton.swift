//
//  RoundedButton.swift
//  Studr
//
//  Created by Joseph Herkness on 11/2/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedButton : UIButton{
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.whiteColor(){
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
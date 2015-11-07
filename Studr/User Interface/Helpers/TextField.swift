//
//  TextField.swift
//  Studr
//
//  Created by Joseph Herkness on 11/5/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TextField: UITextField {

    @IBInspectable var borderWidth : CGFloat = 2.0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 5.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.grayColor(){
        didSet{
            self.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var activeColor : UIColor = UIColor.blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
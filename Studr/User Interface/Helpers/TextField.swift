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
    
    @IBInspectable var borderColorUnFocused : UIColor = UIColor.grayColor(){
        didSet{
            self.layer.borderColor = borderColorUnFocused.CGColor
        }
    }
    
    @IBInspectable var backgroundColorUnFocused : UIColor = UIColor.grayColor(){
        didSet{
            self.backgroundColor = backgroundColorUnFocused
        }
    }
    
    @IBInspectable var backgroundAlphaUnFocused : CGFloat = 1.0{
        didSet{
            self.backgroundColor = self.backgroundColor?.colorWithAlphaComponent(backgroundAlphaUnFocused)
        }
    }
    
    @IBInspectable var textColorUnFocused : UIColor = UIColor.grayColor(){
        didSet{
            self.textColor = textColorUnFocused
        }
    }
    
    @IBInspectable var borderColorFocused : UIColor = UIColor.grayColor()
    
    @IBInspectable var backgroundColorFocused : UIColor = UIColor.grayColor()
    
    @IBInspectable var backgroundAlphaFocused : CGFloat = 1.0
    
    
    @IBInspectable var textColorFocused : UIColor = UIColor.grayColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#F8F8F8")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(hexString: "#F8F8F8")
    }
}
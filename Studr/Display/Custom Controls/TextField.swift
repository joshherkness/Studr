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
    
    @IBInspectable var cornerRadius : CGFloat = 5.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var inset: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#F8F8F8")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(hexString: "#F8F8F8")
    }
}

class PasswordTextField : TextField {
    
    var passwordButton : UIButton = UIButton()
    
    @IBInspectable var showPasswordImage: UIImage? {
        didSet{
            passwordButton.setImage(showPasswordImage, forState: UIControlState.Normal)
        }
    }
    
    @IBInspectable var hidePasswordImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPasswordButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPasswordButton()
    }
    
    func setupPasswordButton(){
        passwordButton = UIButton(frame: CGRectMake(0, 0, self.frame.size.height, self.frame.size.height))
        showPasswordImage = UIImage(named: "ic_visibility")
        passwordButton.addTarget(self, action: "togglePasswordVisible", forControlEvents: .TouchUpInside)
        self.rightView = passwordButton
        passwordButton.tintColor = UIColor(hexString: "C7C7CD")
        self.rightViewMode = .Always
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupPasswordButton()
    }
    
    func togglePasswordVisible(){
        if(self.secureTextEntry){
            self.secureTextEntry = false
            passwordButton.setImage(hidePasswordImage, forState: UIControlState.Normal)
        }else{
            self.secureTextEntry = true
            passwordButton.setImage(showPasswordImage, forState: UIControlState.Normal)
        }
    }
}

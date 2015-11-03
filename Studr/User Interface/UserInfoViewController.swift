
//
//  UserInfoViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/1/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView

class UserInfoViewController : UIViewController {
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150), type: NVActivityIndicatorType.BallPulseSync, color: UIColorFromHex(0x63d297))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create activity indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.userInteractionEnabled = false
        
        // Add activity indicator
        view.addSubview(self.activityIndicator)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Mark: Actions
}

//
//  ResetPasswordViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/1/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ChameleonFramework

class ResetPasswordViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var emailField: UITextField!
    
    // MARK: Instance Variables
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150), type: NVActivityIndicatorType.BallPulseSync, color: UIColor(hexString: "63d297"))
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Reset Password"
        
        // Create activity indicator
        self.activityIndicator.center = self.view.center
        self.activityIndicator.userInteractionEnabled = false
        
        // Add activity indicator
        view.addSubview(self.activityIndicator)
    
        setNeedsStatusBarAppearanceUpdate()

    }
    
    /**
     Resigns the keyboard when the user touches the view
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // Mark: Actions
}

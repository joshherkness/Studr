//
//  PushUpSegueUnwind.swift
//  Studr
//
//  Created by Joseph Herkness on 11/7/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit

class PushUpSegueUnwind: UIStoryboardSegue {

    override func perform() {
        // Assign the source and destination views to local variables.
    
        let secondVCView : UIView
        if(self.sourceViewController.navigationController != nil){
            secondVCView = self.sourceViewController.navigationController!.view as UIView!
        }else{
            secondVCView = self.sourceViewController.view as UIView!
        }
        let firstVCView : UIView
        if(self.destinationViewController.navigationController != nil){
            firstVCView = self.destinationViewController.navigationController!.view as UIView!
        }else{
            firstVCView = self.destinationViewController.view as UIView!
        }
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Specify the initial position of the destination view.
        firstVCView.frame = CGRectMake(0.0, -screenHeight, screenWidth, screenHeight)
        
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(firstVCView, aboveSubview: secondVCView)
        
        // Animate the transition.
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, screenHeight)
            secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, screenHeight)
            
            }) { (Finished) -> Void in
                
                self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
}

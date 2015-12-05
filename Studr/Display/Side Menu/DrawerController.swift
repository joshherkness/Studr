//
//  DrawerController.swift
//  Studr
//
//  Created by Joshua Herkness on 12/4/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import MMDrawerController

public class DrawerController: MMDrawerController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Set some defaults for every drawer controller
        shouldStretchDrawer = false
        showsShadow = false
        centerHiddenInteractionMode = .Full
        closeDrawerGestureModeMask = .All
        openDrawerGestureModeMask = .All
        animationVelocity = 2000.0
    }
}
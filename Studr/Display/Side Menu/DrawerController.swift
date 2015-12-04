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
        self.shouldStretchDrawer = false
        self.showsShadow = false
        self.centerHiddenInteractionMode = .Full
        self.closeDrawerGestureModeMask = .All
        self.openDrawerGestureModeMask = .All
    }
}
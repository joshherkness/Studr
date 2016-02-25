//
//  MainTabBarController.swift
//  Studr
//
//  Created by Joshua Herkness on 12/6/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: Instance Variables
    
    private var controllerArray: [UIViewController] = []
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        
        delegate = self
        
        UITabBar.appearance().translucent = false
        UITabBar.appearance().barTintColor = Color.barTintColor
        
        // Lets the user see the groups that they are a part of
        let myGroupsNavigationController = UINavigationController(rootViewController: GroupsViewController())
        let myGroupsTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_dashboard"), selectedImage: nil)
        myGroupsTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        myGroupsTabBarItem.selectedImage = myGroupsTabBarItem.image?.imageWithColor(Color.selectedTabColor).imageWithRenderingMode(.AlwaysOriginal)
        myGroupsTabBarItem.image = myGroupsTabBarItem.image?.imageWithColor(Color.deselectedTabColor).imageWithRenderingMode(.AlwaysOriginal)
        myGroupsNavigationController.tabBarItem = myGroupsTabBarItem
        controllerArray.append(myGroupsNavigationController)
        
        
        // Lets the user to find groups around their university
        let groupNavigationController = UINavigationController(rootViewController: MapViewController())
        let groupTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_event"), selectedImage: nil)
        groupTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        groupTabBarItem.selectedImage = groupTabBarItem.image?.imageWithColor(Color.selectedTabColor).imageWithRenderingMode(.AlwaysOriginal)
        groupTabBarItem.image = groupTabBarItem.image?.imageWithColor(Color.deselectedTabColor).imageWithRenderingMode(.AlwaysOriginal)
        groupNavigationController.tabBarItem = groupTabBarItem
        controllerArray.append(groupNavigationController)
    
        
        // Lets the user see and add friends
        let friendNavigationController = UINavigationController(rootViewController: FriendsViewController())
        let friendTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_group"), selectedImage: nil)
        friendTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        friendTabBarItem.selectedImage = friendTabBarItem.image?.imageWithColor(Color.selectedTabColor).imageWithRenderingMode(.AlwaysOriginal)
        friendTabBarItem.image = friendTabBarItem.image?.imageWithColor(Color.deselectedTabColor).imageWithRenderingMode(.AlwaysOriginal)
        friendNavigationController.tabBarItem = friendTabBarItem
        controllerArray.append(friendNavigationController)
        
        
        // Lets the user change application settings
        let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())
        let settingsTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_settings"), selectedImage: nil)
        settingsTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        settingsTabBarItem.selectedImage = settingsTabBarItem.image?.imageWithColor(Color.selectedTabColor).imageWithRenderingMode(.AlwaysOriginal)
        settingsTabBarItem.image = settingsTabBarItem.image?.imageWithColor(Color.deselectedTabColor).imageWithRenderingMode(.AlwaysOriginal)
        settingsNavigationController.tabBarItem = settingsTabBarItem
        controllerArray.append(settingsNavigationController)
        
        self.viewControllers = controllerArray
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
    }
    
}

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UITabBar {
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50
        return sizeThatFits
    }
}
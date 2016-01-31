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
    
    override func viewDidLoad() {
        
        delegate = self
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = Constants.Color.primaryTabBar
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(Constants.Color.secondaryTabBar, size: CGSizeMake(tabBar.frame.width/5, tabBar.frame.height))
        var controllerArray: [UIViewController] = []
        
        
        // Lets the user see the groups that they are a part of
        let myGroupsNavigationController = UINavigationController(rootViewController: MyGroupsViewController())
        let myGroupTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_dashboard"), selectedImage: nil)
        myGroupTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        myGroupsNavigationController.tabBarItem = myGroupTabBarItem
        controllerArray.append(myGroupsNavigationController)
        
        
        // Lets the user to find groups around their university
        let groupNavigationController = UINavigationController(rootViewController: GroupsViewController())
        let groupTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_event"), selectedImage: nil)
        groupTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        groupNavigationController.tabBarItem = groupTabBarItem
        controllerArray.append(groupNavigationController)
        
        
        // Lets the user to create their own groups
        let createGroupNavigationController = UINavigationController(rootViewController: CreateGroupViewController())
        let createTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_add"), selectedImage: nil)
        createTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        createGroupNavigationController.tabBarItem = createTabBarItem
        controllerArray.append(createGroupNavigationController)
        
        
        // Lets the user see and add friends
        let friendNavigationController = UINavigationController(rootViewController: FriendViewController())
        let friendTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_group"), selectedImage: nil)
        friendTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        friendNavigationController.tabBarItem = friendTabBarItem
        controllerArray.append(friendNavigationController)
        
        
        // Lets the user change application settings
        let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())
        let settingsTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_settings"), selectedImage: nil)
        settingsTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        settingsNavigationController.tabBarItem = settingsTabBarItem
        controllerArray.append(settingsNavigationController)
        
        self.viewControllers = controllerArray
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if let navigationController = viewController as? UINavigationController {
            if let _ = navigationController.viewControllers.first as? CreateGroupViewController {
                let actualNav = UINavigationController(rootViewController: CreateGroupViewController())
                presentViewController(actualNav, animated: true, completion: nil)
                return false
            }
        }
        
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if let navigationController = viewController as? UINavigationController {
            if let _ = navigationController.viewControllers.first as? CreateGroupViewController {
                let actualNav = UINavigationController(rootViewController: CreateGroupViewController())
                presentViewController(actualNav, animated: true, completion: nil)
            }
        }
    }
    
}

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
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
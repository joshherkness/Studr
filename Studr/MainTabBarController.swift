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
        
        tabBar.barTintColor = UIColor(hexString: "F5F5F5")
        tabBar.tintColor = Constants.Color.secondary
        
        var controllerArray: [UIViewController] = []
        
        let groupNavigationController = UINavigationController(rootViewController: GroupsViewController())
        let groupTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_event"), selectedImage: nil)
        groupTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        groupNavigationController.tabBarItem = groupTabBarItem
        controllerArray.append(groupNavigationController)
        
        let friendNavigationController = UINavigationController(rootViewController: FriendsTableViewController())
        let friendTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_group"), selectedImage: nil)
        friendTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        friendNavigationController.tabBarItem = friendTabBarItem
        controllerArray.append(friendNavigationController)
        
        let createGroupNavigationController = UINavigationController(rootViewController: CreateGroupViewController())
        let createTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_add"), selectedImage: nil)
        createTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        createGroupNavigationController.tabBarItem = createTabBarItem
        controllerArray.append(createGroupNavigationController)
        
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
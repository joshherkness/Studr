//
//  SideTableViewController.swift
//  Studr
//
//  Created by Joshua Herkness on 11/2/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse
import ChameleonFramework

class SideTableViewController: UITableViewController{
    
    var data: [[MenuItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the drawer view controller
        // Create menu items
        addMenuItem("Create Group",color: UIColor(hexString: "#56D289"), selector: "showNewEventViewController", section: 0)
        addMenuItem("Groups", color: UIColor(hexString: "#56D289"), selector: nil, section: 0)
        addMenuItem("Scan QR", color: FlatYellow(), selector: nil, section: 0)
        addMenuItem("Friends", color: FlatMagenta(), selector: nil, section: 1)
        addMenuItem("Profile", color: FlatSkyBlue(), selector: nil, section: 1)
        addMenuItem("Settings", color: FlatSkyBlue(), selector: nil, section: 1)
        addMenuItem("About", color: FlatSkyBlue(), selector: nil, section: 1)
        addMenuItem("Logout", color: FlatRed(), selector: "logOut", section: 2)
        
        // Hide all empty table view cells
        tableView.tableFooterView = UIView()
        view.backgroundColor = UIColorFromHex(0x121212)
        
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row
        
        let menuItem: MenuItem = data[section][row]
        
        // Perform some action
        performSelector(menuItem.selector)
        
        // Close the drawer
        let drawerViewController: DrawerViewController = self.view.window!.rootViewController as! DrawerViewController
        drawerViewController.setPaneState(.Closed, animated: true, allowUserInterruption: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0) {
            return 0
        }
        
        return 30
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = UIView()
        headerView.backgroundColor = UIColorFromHex(0x121212)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    //MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideTableViewCell", forIndexPath: indexPath) as! SideTableViewCell
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    
    /**
     Configures the apearence of a table view cell at a give index in the table
     
     - parameter cell:              <#cell description#>
     - parameter forRowAtIndexPath: <#forRowAtIndexPath description#>
     */
    func configureCell(cell: SideTableViewCell, forRowAtIndexPath: NSIndexPath) {
        
        let section = forRowAtIndexPath.section
        let row = forRowAtIndexPath.row
        
        let menuItem: MenuItem = data[section][row]
        
        cell.mainLabel?.text = menuItem.title
        cell.cellTagView.backgroundColor = menuItem.color
        
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = menuItem.color
        selectedBackgroundView.backgroundColor = menuItem.color
        cell.selectedBackgroundView = selectedBackgroundView
        
        if (menuItem.selector == nil) {
            cell.userInteractionEnabled = false
        }

    }
    
    func logOut(){
        
        PFUser.logOut()
        
        // Return user to login view
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let logInViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LogInViewController")
        
        self.presentViewController(logInViewController, animated: true, completion: {
            appDelegate.window?.rootViewController = logInViewController
        })
    }
    
    func showNewEventViewController(){
        
        // Get the new event view controller
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let newEventViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("NewEventViewController")
        let newEventNavigationController:UINavigationController = UINavigationController(rootViewController: newEventViewController)
        
        // Set the color of the navigation bar
        newEventNavigationController.navigationBar.barTintColor = UIColor(hexString: "#56D289")
        newEventNavigationController.setStatusBarStyle(.LightContent)
        
        // Set the center panel to the new event view controller
        let drawerViewController: DrawerViewController = self.parentViewController as! DrawerViewController
        drawerViewController.setPaneViewController(newEventNavigationController, animated: false, completion: nil)
        
    }
    
    func addMenuItem(title: String, color: UIColor, selector: Selector, section: Int){
        while(section >= data.count ){
            data.append([])
        }
        data[section].append(MenuItem(title: title, color: color, selector: selector))
    }
}

class MenuItem {
    
    var title: String
    var color: UIColor
    var selector: Selector
    
    init(title: String, color: UIColor, selector: Selector){
        
        self.title = title
        self.color = color
        self.selector = selector
    }
}










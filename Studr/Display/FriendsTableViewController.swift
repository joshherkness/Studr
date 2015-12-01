//
//  FriendsTableViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewController : UITableViewController {
    private let sections = ["Invites", "My Friends"]
    private var friends : [[PFUser]] = [[], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Edit navigation bar apearence
        self.navigationController?.navigationBar.barTintColor = STColor.blue()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Friends"
        
        // Add dismiss button
        let menuImage = UIImage(named: "ic_menu")
        let menuButton = UIBarButtonItem(image: menuImage, style: .Plain, target: self, action: "menu:")
        navigationItem.leftBarButtonItem = menuButton

        
        // Remove the hairline between the cells
        self.tableView.separatorStyle = .None
        
        // Register cell for table
        tableView.registerNib(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
    
        loadFriends()
    }
    
    /**
     Populates the friends array with the current users pending friends and accepted friends
     */
    func loadFriends(){
        Database.getFriendRequestsForUser(PFUser.currentUser()!) { (friendRequests, error) -> Void in
            for request in friendRequests! {
                
                // Determine the friend
                let fromUser = request["from"] as! PFUser
                let toUser = request["to"] as! PFUser
                var friend: PFUser
                if(fromUser.objectId == PFUser.currentUser()?.objectId){
                    friend = toUser
                }else{
                    friend = fromUser
                }
                
                // Determine the status
                let status: String = request["status"] as! String
                if (status == "accepted") {
                    self.friends[1].append(friend)
                } else if (status == "pending") {
                    self.friends[0].append(friend)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // Mark - TableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends[section].count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return friends.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user : PFUser = friends[indexPath.section][indexPath.row] 
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell", forIndexPath: indexPath) as! FriendTableViewCell
        
        // Set the cell's user
        cell.setUser(user)
        
        // Change the selected background view
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = STColor.green().colorWithAlphaComponent(0.03)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    func menu(sender: UIBarButtonItem){
        
        // Present the side menu of the drawer view controller
        let drawerViewController: DrawerViewController = self.navigationController?.parentViewController as! DrawerViewController
        drawerViewController.setPaneState(.Open, animated: true, allowUserInterruption: true, completion: nil)
    }
}
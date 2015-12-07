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
        self.navigationController?.navigationBar.barTintColor = Constants.Color.secondary
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        if let _ = self.mm_drawerController {
            // Add menu button
            let image = UIImage(named: "ic_menu")
            let button = UIBarButtonItem(image: image, style: .Plain, target: self, action: "toggleSideMenu:")
            navigationItem.leftBarButtonItem = button
        } else {
            // Add dismiss button
            let image = UIImage(named: "ic_clear")
            let button = UIBarButtonItem(image: image, style: .Plain, target: self, action: "dismiss:")
            navigationItem.leftBarButtonItem = button
        }

        
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
        Database.getFriendshipsForUser(PFUser.currentUser()!) { (friendships, error) -> Void in
            for friendship in friendships! {
                
                // Determine the friend
                let fromUser = friendship["from"] as! PFUser
                let toUser = friendship["to"] as! PFUser
                var friend: PFUser
                if(fromUser.objectId == PFUser.currentUser()?.objectId){
                    friend = toUser
                }else{
                    friend = fromUser
                }
                
                // Determine the status
                let status: String = friendship["status"] as! String
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
        selectedBackgroundView.backgroundColor = Constants.Color.secondary.colorWithAlphaComponent(0.03)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    // MARK: Actions
    
    func toggleSideMenu(sender: UIBarButtonItem) {
        if let drawerController = self.mm_drawerController {
            drawerController.toggleDrawerSide(.Left, animated: true, completion: nil)
        }
    }
    
    func dismiss(sender: UIBarButtonItem){
        // Dismiss view controller
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
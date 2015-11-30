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
    private var friends : [[PFObject]] = [[]]
    
    override func viewDidLoad() {
        let friendsRelation = PFUser.currentUser()?.relationForKey("friendRequests")
        let query = friendsRelation?.query()
        query?.whereKey("status", equalTo: "accepted")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.friends.append(objects!)
            self.tableView.reloadData()
        })
        
        let query2 = friendsRelation?.query()
        query2?.whereKey("status", equalTo: "pending")
        query2?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.friends.append(objects!)
            self.tableView.reloadData()
        })
    }
    
    // Mark - TableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends[section].count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return friends.count
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user : PFUser = friends[indexPath.section][indexPath.row] as! PFUser
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell", forIndexPath: indexPath) as! FriendTableViewCell
        
        // Users Profile Image
        cell.profileImageView.image = imageFromString((user.email)!, size: CGSizeMake(80, 80))
        cell.profileImageView.layer.cornerRadius = 4.0
        cell.profileImageView.clipsToBounds = true
        
        cell.usernameLabel.text = user.username
        
        let firstName = user["firstName"] as? String
        let lastName = user["lastName"] as? String
        cell.nameLabel.text = firstName! + " " + lastName!

        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
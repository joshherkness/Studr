//
//  FriendsTableViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse

class MyFriendsTableViewController : UITableViewController {
    
    // MARK: Instance Variables
    private let sections = ["Added Me", "My Friends"]
    private var friends: [[PFUser]] = [[], []]
    private var query: PFQuery?
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Friends"
        
        // Remove the hairline between the cells
        self.tableView.separatorStyle = .None
        
        // Register the table view's cells
        tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        tableView.registerClass(FriendshipCell.self, forCellReuseIdentifier: "FriendshipCell")
        
        // Finally we load the dataset
        loadFriends()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadFriends()
        tableView.reloadData()
    }
    /**
     Populates the friends array with the current users pending friends and accepted friends
     */
    // TODO: Cache the latest list of friends and load from that cache while the query occurs
    // TODO: Add pull to refresh that calls this method
    func loadFriends(){
        
        // Ensures that the query doesn't repeat
        query?.cancel()
        
        // Clear the list of friends
        friends[0].removeAll()
        friends[1].removeAll()
        
        // Retrieve an updated list of friends
        Database.getFriendshipsForUser(PFUser.currentUser()!) { (friendships, error) -> Void in
            for friendship in friendships! {
                
                // Identify the reciever, sender, and status
                let fromUser = friendship["from"] as! PFUser
                let toUser = friendship["to"] as! PFUser
                let status = friendship["status"] as! String
                // We are just going o ignore friend requests sent by the current user
                if(fromUser.objectId == PFUser.currentUser()?.objectId && status == FriendshipStatus.Pending.rawValue){
                    continue
                }
                
                // Determine the other user in the relationship
                var friend: PFUser
                if(fromUser.objectId == PFUser.currentUser()?.objectId){
                    friend = toUser
                }else{
                    friend = fromUser
                }
                
                // Determine the status of the friendship
                switch status{
                case FriendshipStatus.Accepted.rawValue:
                    self.friends[1].append(friend)
                    break
                case FriendshipStatus.Pending.rawValue:
                    self.friends[0].append(friend)
                    break
                default: break
                    
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // Used to hash the index path so we can distinguish between cells
    func getTagFromIndexPath(indexPath: NSIndexPath) -> Int {
        return indexPath.row + 500 * indexPath.section
    }
    
    // Used to get a index path from a cell's tag
    func getIndexPathFromTag(tag: Int) -> NSIndexPath {
        let row = tag % 500
        let section = tag / 500
        return NSIndexPath(forRow: row, inSection: section)
    }
    
    // MARK: Selectors
    
    func addFriend(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        
        // TODO: This code adds a friendship, it probably needs to be cleaned
        let otherUser = friends[indexPath.section][indexPath.row]
        let currentUser = PFUser.currentUser()
        
        let predicate = NSPredicate(format: "(from = %@ AND to = %@) OR (from = %@ AND to = %@)", currentUser!, otherUser, otherUser, currentUser!)
        let query = PFQuery(className: "Friendship", predicate: predicate)
        query.getFirstObjectInBackgroundWithBlock { (friendship, error) -> Void in
            if(error == nil){
                let status = friendship!["status"] as! String
                if(status == FriendshipStatus.Pending.rawValue){
                    friendship?.setValue(FriendshipStatus.Accepted.rawValue, forKey: "status")
                    friendship?.saveInBackgroundWithBlock({ (saved, error) -> Void in
                        if(saved){
                            self.friends[1].append(otherUser)
                            self.friends[0].removeAtIndex(indexPath.row)
                            self.tableView.reloadData()
                        }else{
                            print(error)
                        }
                    })
                }
            }else{
                print(error)
            }
        }
        
    }
    
    // MARK: TableViewDatasource
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.friendTableViewCellHeight
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (friends[section].count > 0) ? 30 : 0
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        cell.accessoryType = .DisclosureIndicator
        cell.setUser(user)
        cell.acceptButton.tag = getTagFromIndexPath(indexPath)
        cell.acceptButton.addTarget(self, action: "addFriend:", forControlEvents: .TouchUpInside)
        
        // Changes what kind of cell should be displayed
        if(indexPath.section == 0){
            cell.type = .Accept
        }else if(indexPath.section == 1){
            cell.type = .None
        }
        
        // Change the selected background view
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = Constants.Color.grey.colorWithAlphaComponent(0.5)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
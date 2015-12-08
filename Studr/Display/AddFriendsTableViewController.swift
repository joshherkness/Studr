//
//  FriendsTableViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse

class AddFriendsTableViewController : UITableViewController, UISearchBarDelegate{
    private var query: PFQuery?
    
    private var users: [PFUser] = []
    private var searchBar = UISearchBar()
    
    private var friends: [PFUser] = []
    private var pendingFriends: [PFUser] = []
    private var rejectedFriends: [PFUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Edit navigation bar apearence
        navigationController?.navigationBar.barTintColor = Constants.Color.secondary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.title = "Add Friends"
        
        // Setup search bar controller
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar
        searchBar.searchBarStyle = .Minimal
        
        // Remove the hairline between the cells
        tableView.separatorStyle = .None
        
        // Register cell for table
        tableView.registerNib(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        
        loadFriendships()
    }
    // Mark - TableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell", forIndexPath: indexPath) as! FriendTableViewCell
        
        // Set the cell's user
        cell.setUser(user)
        
        // Change the selected background view
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = Constants.Color.secondary.colorWithAlphaComponent(0.03)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    func loadFriendships(){
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
                
                // Determine the status of the friendship
                switch friendship["status"] as! String {
                case FriendshipStatus.Accepted.rawValue:
                    self.friends.append(friend)
                    break
                case FriendshipStatus.Pending.rawValue:
                    self.pendingFriends.append(friend)
                    break
                case FriendshipStatus.Rejected.rawValue:
                    self.rejectedFriends.append(friend)
                    break
                default: break
                    
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        query?.cancel()
        if(searchText == ""){
            self.users.removeAll()
            self.tableView.reloadData()
            return
        }
        let searchTextArray = searchText.componentsSeparatedByString(" ")
        var predicate: NSPredicate?
        if(searchTextArray.count > 1){
            predicate = NSPredicate(format: "objectId != %@ AND (username BEGINSWITH %@ OR firstName BEGINSWITH %@ OR lastName BEGINSWITH %@ OR lastname BEGINSWITH %@)", PFUser.currentUser()!.objectId!, searchText.lowercaseString, searchTextArray[0], searchTextArray[0], searchTextArray[1])
        }else{
            predicate = NSPredicate(format: "objectId != %@ AND (username BEGINSWITH %@ OR username BEGINSWITH %@ OR firstName BEGINSWITH %@ OR lastName BEGINSWITH %@)", PFUser.currentUser()!.objectId!, searchText.lowercaseString, searchTextArray[0], searchTextArray[0], searchTextArray[0])
        }
        query = PFUser.queryWithPredicate(predicate)!
        query?.findObjectsInBackgroundWithBlock { (users, error) -> Void in
            if(error == nil){
                self.users = users as! [PFUser]
                self.tableView.reloadData()
            }else{
                print(error)
            }
        }
        
    }
}
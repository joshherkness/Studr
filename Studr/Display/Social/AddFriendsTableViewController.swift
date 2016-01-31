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
    
    // MARK: Instance Variables
    
    private var query: PFQuery?
    private var users: [PFUser] = []
    private var friends: [String:FriendshipStatus] = [:]
    var searchBar = UISearchBar()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the navigation bar appearance
        navigationController?.navigationBar.barTintColor = Constants.Color.primary
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.hidesNavigationBarHairline = true;
        navigationController?.navigationBar.topItem?.title = "Friends"
        
        // Setup the search bar
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar
        searchBar.searchBarStyle = .Minimal
        
        // Remove the hairline between the cells
        tableView.separatorStyle = .None
        
        // Register cell for table
        tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        // Dismisses the keyboard when the user taps the view
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Load all the friendships
        loadFriendships()
    }
    
    /**
     Resigns the keyboard when the user touches the view
     */
    func dismissKeyboard() {
        view.endEditing(true)
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
                    self.friends.updateValue(FriendshipStatus.Accepted, forKey: friend.objectId!)
                    break
                case FriendshipStatus.Pending.rawValue:
                    self.friends.updateValue(FriendshipStatus.Pending, forKey: friend.objectId!)
                    break
                case FriendshipStatus.Rejected.rawValue:
                    self.friends.updateValue(FriendshipStatus.Rejected, forKey: friend.objectId!)
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
        
        // Get the index of the user
        let indexPath = getIndexPathFromTag(button.tag)
        
        // Add the friendship
        let otherUser = users[indexPath.row]
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
                            // Friendship was accepted
                            self.friends.updateValue(FriendshipStatus.Accepted, forKey: otherUser.objectId!)
                            self.tableView.reloadData()
                        }else{
                            print(error)
                        }
                    })
                }
            }else if(error?.code == 101){
                PFCloud.callFunctionInBackground("addFriendship", withParameters: ["from": (currentUser?.objectId)!, "to": otherUser.objectId!], block: { (id, error) -> Void in
                    if(error == nil){
                        //Friendship was sent
                        self.friends.updateValue(FriendshipStatus.Pending, forKey: otherUser.objectId!)
                        self.tableView.reloadData()
                    }else{
                        print(error)
                    }
                })
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
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(users.count <= 0){
            
            // Set the tables background view to a placeholder if there are no results
            let label = UILabel(frame: tableView.frame)
            label.text = "You can search for your friends here"
            label.textAlignment = .Center
            label.textColor = UIColor(hexString: "#777777")
            tableView.backgroundView = label
            
        }else{
            tableView.backgroundView = nil
        }
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        cell.accessoryType = .DisclosureIndicator
        cell.setUser(user)
        cell.addFriendButton.tag = getTagFromIndexPath(indexPath)
        cell.addFriendButton.addTarget(self, action: "addFriend:", forControlEvents: .TouchUpInside)
        cell.acceptButton.tag = getTagFromIndexPath(indexPath)
        cell.acceptButton.addTarget(self, action: "addFriend:", forControlEvents: .TouchUpInside)
        
        // Changes what kind of cell should be displayed
        let index = friends.indexForKey(user.objectId!)
        if(index != nil){
            if(friends.values[index!] == FriendshipStatus.Accepted){
                cell.type = .None
            }else if(friends.values[index!] == FriendshipStatus.Pending){
                cell.type = .Sent
            }else if(friends.values[index!] == FriendshipStatus.Rejected){
                cell.type = .Rejected
            }
        }else{
            cell.type = .Send
        }
        
        // Change the selected background view
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = Constants.Color.grey.colorWithAlphaComponent(0.5)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    // Mark: - SearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        // First we start by canceling the previous query
        query?.cancel()
        
        // Next we empty the array of users if no text has been entered
        if(searchText.isEmpty){
            users.removeAll()
            tableView.reloadData()
            return
        }
        
        // If there is to much text, we are not going to bother querying for users
        if(searchText.characters.count > 25){
            return
        }
        
        //We then begin our query for the users that match the entered text
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
    
    // MARK: TableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}
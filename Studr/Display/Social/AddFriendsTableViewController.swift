//
//  FriendsTableViewController.swift
//  Studr
//
//  Created by Joseph Herkness on 11/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Firebase

class AddFriendsTableViewController : UITableViewController, UISearchBarDelegate{
    
    // MARK: Instance Variables
    
    private var users = [User]()
    private var friends = [String:FriendshipStatus]()
    var searchBar = UISearchBar()
    private var searchRequestQuery = FQuery()
    private var friendshipRemovedHandle = FirebaseHandle()
    
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
        
        // Setup the table view
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
        let myId = Database.BASE_REF.authData!.uid
        let myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(myId)
        
        // Query for all friendships where the current user and other user are members
        myFriendshipsRef.queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            self.friends.updateValue(FriendshipStatus(rawValue: status)!, forKey: theirId)
            
            self.tableView.reloadData()
        })
        
        // Query for all friendships where the current user is the sender or receiver
        myFriendshipsRef.queryOrderedByKey().observeEventType(.ChildChanged, withBlock: { snapshot in
            let theirId = snapshot.key
            let status = snapshot.value as! String
            self.friends.updateValue(FriendshipStatus(rawValue: status)!, forKey: theirId)
            
            self.tableView.reloadData()
        })
        
        // Create listener and store handle
        friendshipRemovedHandle = myFriendshipsRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let theirId = snapshot.key
            self.friends.removeValueForKey(theirId)
            
            self.tableView.reloadData()
        })
        
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
    
    func addFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        let theirId = users[indexPath.row].key
    
        // First we decide where to add the friendship
        let myId = Database.BASE_REF.authData!.uid
        let myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(myId)
        let theirFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(theirId)
        
        // Now we add the appropriate friendship for each user
        myFriendshipsRef.childByAppendingPath(theirId).setValue(FriendshipStatus.PendingSent.rawValue)
        theirFriendshipsRef.childByAppendingPath(myId).setValue(FriendshipStatus.PendingReceived.rawValue)
    }

    func acceptFriendship(button: UIButton){
        let indexPath = getIndexPathFromTag(button.tag)
        let theirId = users[indexPath.row].key
        
        // First we decide where to add the friendship
        let myId = Database.BASE_REF.authData!.uid
        let myFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(myId)
        let theirFriendshipsRef = Database.FRIENDSHIP_REF.childByAppendingPath(theirId)
        
        myFriendshipsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children.allObjects as! [FDataSnapshot] {
                let u = child.key
                if(u == theirId){
                    child.ref.setValue(FriendshipStatus.Accepted.rawValue)
                }
            }
        })
        
        theirFriendshipsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children.allObjects as! [FDataSnapshot] {
                let u = child.key
                if(u == myId){
                    child.ref.setValue(FriendshipStatus.Accepted.rawValue)
                }
            }
        })
    }
    
    // MARK: TableViewDatasource
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.userCellHeight
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
        cell.configureCell(user)
        cell.addButton.tag = getTagFromIndexPath(indexPath)
        cell.addButton.addTarget(self, action: "addFriendship:", forControlEvents: .TouchUpInside)
        cell.acceptButton.tag = getTagFromIndexPath(indexPath)
        cell.acceptButton.addTarget(self, action: "acceptFriendship:", forControlEvents: .TouchUpInside)
        
        // Determine and set the cells type
        if let index = friends.indexForKey(user.key){
            switch friends.values[index] {
            case .PendingReceived: cell.setType(.PendingReceived); break
            case .PendingSent: cell.setType(.PendingSent); break
            case .Accepted: cell.setType(.Accepted); break
            case .Rejected: cell.setType(.Rejected); break
            default: cell.setType(.None); break
            }
        }else{
            cell.setType(.Send)
        }
        
        return cell
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Display a popup with information about the selected user
        let user = users[indexPath.row]
        let alertController = UIAlertController(title: user.username, message:
            "Here it will display a popup with information about the selected user", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Mark: - SearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // Next we empty the array of users if no text has been entered
        if(searchText.isEmpty){
            users.removeAll()
            tableView.reloadData()
            return
        }
        
        // If there is to much text, we are not going to bother querying for users
        if(searchText.characters.count > 15){
            return
        }
        
        // Now we look for users matching this text
        Database.USER_REF.queryLimitedToFirst(25).observeEventType(.Value, withBlock: { snapshot in
            self.users.removeAll()
            for snap in snapshot.children.allObjects as! [FDataSnapshot]{
                let key = snap.key
                let dictionary = snap.value as! [String: AnyObject]
                let user = User(key: key, dictionary: dictionary)
                
                // If the user is the current user, do not add them
                if(user.key == Database.BASE_REF.authData.uid){
                    continue
                }
                if user.firstname.lowercaseString.hasPrefix(searchText.lowercaseString){
                    self.users.append(user)
                }else if(user.lastname.lowercaseString.hasPrefix(searchText.lowercaseString)){
                    self.users.append(user)
                }else if(user.username.lowercaseString.hasPrefix(searchText.lowercaseString)){
                    self.users.append(user)
                }
            }
            
            self.users.sortInPlace({ $0.lastname > $1.lastname })
            self.tableView.reloadData()
        })
    }
}
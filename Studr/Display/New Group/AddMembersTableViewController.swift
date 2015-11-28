//
//  AddMembersTableViewController.swift
//  Studr
//
//  Created by Robin Onsay on 11/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Foundation
import Parse
import ParseUI
import Eureka

public class AddMembersTableViewController: PFQueryTableViewController , UISearchBarDelegate, TypedRowControllerType {
    
    // Variables used for eureka row reference and callback
    public var row: RowOf<Set<PFUser>>!
    public var completionCallback : ((UIViewController) -> ())?
    
    public var parseRelationName: String?
  
    // Array of current selected friends within the table
    public var selectedFriends = [PFObject]()
    
    // The current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            //oldValue?.cancel()
        }
    }
    
    convenience public init(_ callback: (UIViewController) -> ()){
        self.init(nibName: nil, bundle: nil)
        completionCallback = callback
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell for table
        tableView.registerNib(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
        
        placeholderImage = UIImage(named: "placeholder_profile_male")
        imageKey = "profileImage"
        textKey = "username"

        // Preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
        
        // Allows selection of multiple cells in tableview
        tableView.allowsMultipleSelection = true
        
        // Add completion button
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "tappedDone:")
        button.title = "Done"
        navigationItem.leftBarButtonItem = button
        
        // Load the existing selected users into the array
        selectedFriends = Array(row.value!)
        
        // Reload the data of the table
        loadObjects()
        
    }
    
    func tappedDone(sender: UIButton){
        
        // Set the new value of selected friends
        var selectedFriendsSet = Set<PFUser>()
        for s in selectedFriends {
            selectedFriendsSet.insert(s as! PFUser)
        }
        row.value = selectedFriendsSet
        
        // Return to previouse view controller
        self.navigationController?.popViewControllerAnimated(true)
    }

    //MARK: UITableViewDelegate
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // To be called when a cell is seclected
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? FriendTableViewCell
        let object = self.objectAtIndexPath(indexPath)!
        
        selectedFriends.append(object)
        cell?.accessoryType = .Checkmark
        cell?.friendName.textColor = STColor.blue()
    }
    
    public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? FriendTableViewCell
        let object = self.objectAtIndexPath(indexPath)!
        
        let filteredSelectedFriends: [PFObject] = selectedFriends.filter({ $0.objectId == object.objectId })
        let filteredSelectedFriendsObject = filteredSelectedFriends.first
        
        selectedFriends.removeAtIndex(selectedFriends.indexOf(filteredSelectedFriendsObject!)!)
        cell?.accessoryType = .None
        cell?.friendName.textColor = UIColor.blackColor()
        
        print(selectedFriends)
    }
    
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    public override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    public override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    public override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return super.tableView(tableView, viewForHeaderInSection: section)
    }
    
    public override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return super.tableView(tableView, viewForFooterInSection: section)
    }
    
    //MARK: UITableViewDataSource
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell", forIndexPath: indexPath) as! FriendTableViewCell
        
        cell.friendName.text = object![textKey!] as? String
        cell.profilePic.image = object![imageKey!] != nil ? object![imageKey!] as? UIImage : placeholderImage
        
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.03)
        cell.selectedBackgroundView = selectedBackgroundView
        
        // Determine if the friend should be selected
        let results: [PFObject] = selectedFriends.filter({ $0.objectId == object!.objectId })
        
        if !results.isEmpty {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        }

        cell.accessoryType = cell.selected ? .Checkmark : .None
        cell.friendName.textColor = cell.selected ? STColor.blue() : UIColor.blackColor()
        cell.tintColor = STColor.blue()
        
        return cell
    }
    
    
    // Mark - PFQueryTableViewController
    
    public override func queryForTable() -> PFQuery {
        
        let friendsRelation = PFUser.currentUser()?.relationForKey("friend")
        query = friendsRelation?.query()
        query?.orderByAscending("username")
        
        return query!
    }

}

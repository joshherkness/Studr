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
import CryptoSwift

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
        cell?.nameLabel.textColor = STColor.green()
    }
    
    public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? FriendTableViewCell
        let object = self.objectAtIndexPath(indexPath)!
        
        let filteredSelectedFriends: [PFObject] = selectedFriends.filter({ $0.objectId == object.objectId })
        let filteredSelectedFriendsObject = filteredSelectedFriends.first
        
        selectedFriends.removeAtIndex(selectedFriends.indexOf(filteredSelectedFriendsObject!)!)
        cell?.accessoryType = .None
        cell?.nameLabel.textColor = UIColor.blackColor()
    }
    
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
        
        cell.nameLabel.text = object![textKey!] as? String
        cell.profileImageView.image = object![imageKey!] != nil ? object![imageKey!] as? UIImage : placeholderImage
        
        let selectedBackgroundView: UIView = UIView()
        selectedBackgroundView.backgroundColor = STColor.green().colorWithAlphaComponent(0.03)
        cell.selectedBackgroundView = selectedBackgroundView
        
        // Determine if the friend should be selected
        let results: [PFObject] = selectedFriends.filter({ $0.objectId == object!.objectId })
        
        if !results.isEmpty {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
        }

        cell.accessoryType = cell.selected ? .Checkmark : .None
        cell.nameLabel.textColor = cell.selected ? STColor.green() : UIColor.blackColor()
        cell.tintColor = STColor.green()
        
        // Users Profile Image
        let user = object as? PFUser
        cell.profileImageView.image = imageFromString((user?.email)!, size: CGSizeMake(80, 80))
        cell.profileImageView.layer.cornerRadius = 4.0
        cell.profileImageView.clipsToBounds = true
        
        cell.usernameLabel.text = user?.username
        
        let firstName = user!["firstName"] as? String
        let lastName = user!["lastName"] as? String
        cell.nameLabel.text = firstName! + " " + lastName!
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

//
//  FriendTableViewCell.swift
//  Studr
//
//  Created by Joseph Herkness on 11/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserCell: PFTableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var sentButton: RoundedButton!
    @IBOutlet weak var acceptButton: RoundedButton!
    
    // MARK: Instance Variables
    
    var type: UserCellType = .None{
        didSet{
            //Change the cell's appearance when its type changes
            addFriendButton.hidden = true
            acceptButton.hidden = true
            sentButton.hidden = true
            
            switch type{
            case .None:break
            case .Send:
                addFriendButton.hidden = false
                break
            case .Reject: break
            case .Accept:
                acceptButton.hidden = false
                break
            case .Sent:
                sentButton.hidden = false
                break
            case .Rejected: break
            case .Accepted: break
            }
        }
    }
    
    /**
     Changes the appearance of the cell based on a given user
    */
    func setUser(user: PFUser){
        // Set the dafault image
        profileImageView.image = placeholderImageForUser(user)
            
        // Set the profile image
        getProfileImageForUser(user) { (image) -> () in
            self.profileImageView.image = image
        }
        
        // Set the labels
        let firstName = user["firstName"] as? String
        let lastName = user["lastName"] as? String
        nameLabel.text = firstName! + " " + lastName!
        usernameLabel.text = user.username
    }
}

enum UserCellType {
    case None
    case Send
    case Reject
    case Accept
    case Sent
    case Rejected
    case Accepted
}
//
//  FriendTableViewCell.swift
//  Studr
//
//  Created by Joseph Herkness on 11/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var rejectButton: RoundedButton!
    @IBOutlet weak var sentButton: RoundedButton!
    @IBOutlet weak var acceptButton: RoundedButton!
    
    // MARK: Instance Variables
    
    var type: UserCellType = .None {
        didSet{
            //Change the cell's appearance when its type changes
            addButton.hidden = true
            acceptButton.hidden = true
            sentButton.hidden = true
            rejectButton.hidden = true
            
            switch type{
            case .None:break
            case .Send:
                addButton.hidden = false
                break
            case .PendingSent:
                sentButton.hidden = false
                break
            case .PendingReceived:
                acceptButton.hidden = false
                rejectButton.hidden = false
                break
            case .Rejected:
                 addButton.hidden = false
                break
            case .Accepted: break
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Change the selected background view
        let view: UIView = UIView()
        view.backgroundColor = Constants.Color.grey.colorWithAlphaComponent(0.5)
        selectedBackgroundView = view
        
        // Hide all the buttons
        addButton.hidden = true
        acceptButton.hidden = true
        sentButton.hidden = true
        rejectButton.hidden = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Change the selected background view
        let view: UIView = UIView()
        view.backgroundColor = Constants.Color.grey.colorWithAlphaComponent(0.5)
        selectedBackgroundView = view
    }
    
    /**
     Changes the appearance of the cell based on a given user
    */
    func setUser(id: String){
        let userRef = Constants.ref.childByAppendingPath("users").childByAppendingPath(id)
        
        userRef.observeEventType(.Value, withBlock: { snapshot in
            
            // Set cells appearance
            let firstName = snapshot.value.valueForKey("first_name") as! String
            let lastName = snapshot.value.valueForKey("last_name") as! String
            let email = snapshot.value.valueForKey("email") as! String
            let username = snapshot.value.valueForKey("username") as! String
            
            self.nameLabel.text = firstName + " " + lastName
            self.usernameLabel.text = username
            
            // Get the profile image for the user
            self.profileImageView.image = placeholderImage(email)
            getProfileImageForUser(snapshot.key, email: email, onSuccess: { image in
                self.profileImageView.image = image
            })
            
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    /**
     Changes the appearance of the cell based on a given user
     */
    func setType(type: UserCellType){
        
        // Hide all the buttons
        addButton.hidden = true
        acceptButton.hidden = true
        sentButton.hidden = true
        rejectButton.hidden = true
        
        if(type == UserCellType.Send){
            addButton.hidden = false
        }else if(type == UserCellType.PendingReceived){
            acceptButton.hidden = false
            rejectButton.hidden = false
        }else if(type == UserCellType.PendingSent){
            sentButton.hidden = false
        }else if(type == UserCellType.Rejected){
            addButton.hidden = false
        }else if(type == UserCellType.Accepted){
            return
        }else if(type == UserCellType.None){
            return
        }
        
    }
    
    // MARK : UITableViewCell
    override func setSelected(selected: Bool, animated: Bool) {
        let addFriendButtonBackgroundColor = addButton.backgroundColor
        let sentButtonBackgroundColor = sentButton.backgroundColor
        let acceptButtonBackgroundColor = acceptButton.backgroundColor
        
        super.setSelected(selected, animated: animated)
        
        if(selected){
            addButton.backgroundColor = addFriendButtonBackgroundColor
            sentButton.backgroundColor = sentButtonBackgroundColor
            acceptButton.backgroundColor = acceptButtonBackgroundColor
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let addFriendButtonBackgroundColor = addButton.backgroundColor
        let sentButtonBackgroundColor = sentButton.backgroundColor
        let acceptButtonBackgroundColor = acceptButton.backgroundColor
        
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted){
            addButton.backgroundColor = addFriendButtonBackgroundColor
            sentButton.backgroundColor = sentButtonBackgroundColor
            acceptButton.backgroundColor = acceptButtonBackgroundColor
        }
    }
}
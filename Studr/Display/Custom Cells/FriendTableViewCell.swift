//
//  FriendTableViewCell.swift
//  Studr
//
//  Created by Robin Onsay on 11/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FriendTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    private var user : PFUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUser(user: PFUser){
        self.user = user
        
        //Sets the dafault image
        profileImageView.image = faceImageFromString("3", size: CGSize(width: 80,height: 80))
            
        // Set the profile image
        getProfileImageForUser(user) { (image) -> () in
            self.profileImageView.image = image
        }
        
        // Set the name label
        let firstName = user["firstName"] as? String
        let lastName = user["lastName"] as? String
        nameLabel.text = firstName! + " " + lastName!
        
        // Set the username label
        usernameLabel.text = user.username
    }
}


class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.width / 2.0
    }
}
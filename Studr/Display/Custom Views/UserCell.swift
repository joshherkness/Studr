//
//  FriendTableViewCell.swift
//  Studr
//
//  Created by Joseph Herkness on 11/8/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

enum UserCellType {
    case None
    case Send
    case PendingSent
    case PendingReceived
    case Accepted
    case Rejected
}

class UserCell: UITableViewCell {
    
    // MARK: Instance Variables
    
    var profileImageView: RoundedImageView!
    var nameLabel: UILabel!
    var usernameLabel: UILabel!
    var addButton: RoundedButton!
    var rejectButton: RoundedButton!
    var sentButton: RoundedButton!
    var acceptButton: RoundedButton!
    
    var labelContainer: UIView!
    var buttonContainer: UIView!
    
    // MARK: UITableViewCell
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupCell()
    }

    func setupCell(){
        
        // Setup Image View
        profileImageView = RoundedImageView()
        addSubview(profileImageView)
        
        // Setup Labels
        labelContainer = UIView()
        addSubview(labelContainer)
        
        nameLabel = UILabel()
        nameLabel.textColor = UIColor(hexString: "3D4247")
        nameLabel.font = UIFont.systemFontOfSize(17, weight: 0.2)
        labelContainer.addSubview(nameLabel)
        
        usernameLabel = UILabel()
        usernameLabel.textColor = UIColor(hexString: "90979E")
        usernameLabel.font = UIFont.systemFontOfSize(15)
        labelContainer.addSubview(usernameLabel)
        
        // Setup Buttons
        buttonContainer = UIView()
        addSubview(buttonContainer)
        
        addButton = RoundedButton()
        addButton.setImage(UIImage(named: "ic_add"), forState: .Normal)
        addButton.backgroundColor = Constants.Color.lightGreyBackground
        addButton.tintColor = UIColor.whiteColor()
        addButton.cornerRadius = 5.0
        buttonContainer.addSubview(addButton)
        
        rejectButton = RoundedButton()
        rejectButton.setImage(UIImage(named: "ic_clear"), forState: .Normal)
        rejectButton.backgroundColor = Constants.Color.lightGreyBackground
        rejectButton.tintColor = UIColor.whiteColor()
        rejectButton.cornerRadius = 5.0
        buttonContainer.addSubview(rejectButton)
        
        sentButton = RoundedButton()
        sentButton.setImage(UIImage(named: "ic_direction"), forState: .Normal)
        sentButton.backgroundColor = Constants.Color.primary
        sentButton.tintColor = UIColor.whiteColor()
        sentButton.cornerRadius = 5.0
        buttonContainer.addSubview(sentButton)
        
        acceptButton = RoundedButton()
        acceptButton.setImage(UIImage(named: "ic_done"), forState: .Normal)
        acceptButton.backgroundColor = Constants.Color.primary
        acceptButton.tintColor = UIColor.whiteColor()
        acceptButton.cornerRadius = 5.0
        buttonContainer.addSubview(acceptButton)
        
        // Change the selected background view
        let view: UIView = UIView()
        view.backgroundColor = UIColor(hexString: "F4F5F6")
        selectedBackgroundView = view
        
        // Hide all the buttons
        addButton.hidden = true
        acceptButton.hidden = true
        sentButton.hidden = true
        rejectButton.hidden = true
        
        updateConstraints()
    }
    
    // MARK: Constraints
    
    override func updateConstraints() {
        
        profileImageView.snp_makeConstraints(closure: { make in
            make.left.top.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.width.equalTo(profileImageView.snp_height)
        })
        
        labelContainer.snp_makeConstraints(closure: { make in
            make.centerY.equalTo(self)
            make.left.equalTo(profileImageView.snp_right).offset(8)
            make.right.equalTo(buttonContainer.snp_left)
        })
        
        nameLabel.snp_makeConstraints(closure: { make in
            make.top.right.left.equalTo(labelContainer)
            make.bottom.equalTo(usernameLabel.snp_top)
        })
        
        usernameLabel.snp_makeConstraints(closure: { make in
            make.top.equalTo(nameLabel.snp_bottom)
            make.bottom.right.left.equalTo(labelContainer)
        })
        
        buttonContainer.snp_makeConstraints(closure: { make in
            make.right.top.bottom.equalTo(self)
            make.left.equalTo(acceptButton.snp_left)
        })
        addButton.snp_makeConstraints(closure: { make in
            make.size.equalTo(profileImageView).multipliedBy(0.8)
            make.centerY.equalTo(buttonContainer)
            make.right.equalTo(buttonContainer).offset(-8)
        })
        
        rejectButton.snp_makeConstraints(closure: { make in
            make.size.equalTo(profileImageView).multipliedBy(0.8)
            make.centerY.equalTo(buttonContainer)
            make.right.equalTo(buttonContainer).offset(-8)
        })
        
        acceptButton.snp_makeConstraints(closure: { make in
            make.size.equalTo(profileImageView).multipliedBy(0.8)
            make.centerY.equalTo(buttonContainer)
            make.right.equalTo(rejectButton.snp_left).offset(-8)
        })
        
        sentButton.snp_makeConstraints(closure: { make in
            make.size.equalTo(profileImageView).multipliedBy(0.8)
            make.centerY.equalTo(buttonContainer)
            make.right.equalTo(buttonContainer).offset(-8)
        })
        
        super.updateConstraints()
    }
    
    // Mark: Configuration
    
    func configureCell(user: User){
        nameLabel.text = user.firstname + " " + user.lastname
        usernameLabel.text = user.username
        getProfileImageForUser(user.uid, email: user.email, onSuccess: { image in
            self.profileImageView.image = image
        })
    }
    
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
    
    // Prevents the background color of subviews from changing when the cell is selected
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
    
    // Prevents the background color of subviews from changing when the cell is highlighted
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
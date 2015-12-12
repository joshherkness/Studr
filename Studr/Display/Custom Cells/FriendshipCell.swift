//
//  FriendshipCell.swift
//  Studr
//
//  Created by Joseph Herkness on 12/11/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import UIKit

class FriendshipCell : UserCell {
    var friendshipObjectId: String?
    var status: FriendshipStatus?
    
    func setFriendship(id: String, status: FriendshipStatus){
        self.friendshipObjectId = id
        self.status = status
        
        if(status == .Accepted){
            backgroundColor = UIColor.greenColor()
        }else if(status == .Pending){
            backgroundColor = UIColor.yellowColor()
        }else if(status == .Rejected){
            backgroundColor = UIColor.redColor()
        }
    }
}
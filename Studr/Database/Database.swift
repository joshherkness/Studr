//
//  Database.swift
//  Studr
//
//  Created by Joseph Herkness on 2/14/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import Firebase

class Database {
    
    static var BASE_REF = Firebase(url: "https://studr.firebaseio.com")
    static var USER_REF = Firebase(url: "https://studr.firebaseio.com/users")
    static var FRIENDSHIP_REF = Firebase(url: "https://studr.firebaseio.com/friendships")
    static var MEMBERSHIP_REF = Firebase(url: "https://studr.firebaseio.com/memberships")
    static var GROUP_REF = Firebase(url: "https://studr.firebaseio.com/groups")

    static func userFromId(id: String, completion: (user: User) -> Void){
        let userRef = Database.USER_REF.childByAppendingPath(id)
        
        userRef.observeEventType(.Value, withBlock: { snapshot in
            let key = snapshot.key
            let dictionary = snapshot.value as! [String: AnyObject]
            let user = User(key: key, dictionary: dictionary)
            completion(user: user)
        })
    }
}
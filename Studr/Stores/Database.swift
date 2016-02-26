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
    static var VOTES_REF = Firebase(url: "https://studr.firebaseio.com/votes")

    static func getUser(id: String, completion: (user: User) -> Void){
        
        let userRef = Database.USER_REF.childByAppendingPath(id)
        userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                print("Error: User \(snapshot.key) not found...")
            }else{
                let dictionary = snapshot.value as! [String: AnyObject]
                let key = snapshot.key
                let user = User(uid: key, dictionary: dictionary)
                completion(user: user)
            }
        })
    }
    
    static func getGroup(key: String, completion: (group: Group) -> Void){
        
        let groupRef = Database.GROUP_REF.childByAppendingPath(key)
        groupRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                print("Error: Group \(snapshot.key) not found...")
            }else{
                let dictionary = snapshot.value as! [String: AnyObject]
                let key = snapshot.key
                let group = Group(key: key, dictionary: dictionary)
                completion(group: group)
            }
        })
    }
    
    static func addFriendship(sender: User, reciever: User){
        
    }
    
    static func getProfileImageForUser(user: User, completionHandler: (image: UIImage) -> Void){
        
    }
}
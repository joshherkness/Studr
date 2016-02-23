//
//  User.swift
//  Studr
//
//  Created by Joseph Herkness on 2/14/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import Firebase

public class User: Hashable{
    
    // MARK: Instance Variables
    
    var ref: Firebase!
    var uid: String!
    var firstname = String()
    var lastname = String()
    var username = String()
    var email = String()
    
    // MARK: Hashable
    
    public var hashValue: Int {
        return self.uid.hashValue
    }
    
    // MARK: Constructors
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        
        if let firstname = dictionary["first_name"] as? String {
            self.firstname = firstname
        }
        
        if let lastname = dictionary["last_name"] as? String {
            self.lastname = lastname
        }
        
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        
        ref = Database.USER_REF.childByAppendingPath(uid)
    }
}

// MARK: Equatable

public func ==(lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}
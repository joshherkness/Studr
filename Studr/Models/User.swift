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
    
    var ref: Firebase!
    var uid = String()
    var firstname = String()
    var lastname = String()
    var username = String()
    var email = String()
    
    // MARK: Hashable
    
    public var hashValue: Int {
        return self.uid.hashValue
    }
    
    // MARK: Constructors
    
    init(){}
    
    init(uid: String, dictionary: Dictionary<String, AnyObject>) {
        self.uid = uid
        ref = Database.USER_REF.childByAppendingPath(uid)
        firstname = dictionary["first_name"] as? String ?? ""
        lastname = dictionary["last_name"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
    }
}

// MARK: Equatable

public func ==(lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
    && lhs.email == rhs.email
    && lhs.firstname == rhs.firstname
    && lhs.lastname == rhs.lastname
    && lhs.username == rhs.username
}
//
//  Group.swift
//  Studr
//
//  Created by Joseph Herkness on 2/14/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import Firebase

class Group {
    
    var ref: Firebase!
    var key: String!
    var name: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        
        self.key = key
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        ref = Database.GROUP_REF.childByAppendingPath(key)
    }
    
}
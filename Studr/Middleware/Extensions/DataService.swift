//
//  DataService.swift
//  Studr
//
//  Created by Joseph Herkness on 2/14/16.
//  Copyright © 2016 JJR. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static private var _BASE_REF = Firebase(url: "https://studr.firebaseio.com")
    static private var _USER_REF = Firebase(url: "https://studr.firebaseio.com/users")
    static private var _FRIENDSHIP_REF = Firebase(url: "https://studr.firebaseio.com/friendships")
    
    static var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    static var USER_REF: Firebase {
        return _USER_REF
    }
    
    static var FRIENDSHIPS_REF: Firebase {
        return _FRIENDSHIP_REF
    }
}

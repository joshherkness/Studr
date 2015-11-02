//
//  Database.swift
//  Studr
//
//  Created by Robin Onsay on 11/2/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import Parse

class Database: DataBaseHelper {
    let GROUPS = "Group"
    let USERS_POINTER = "_User"
    static func createEvent(eventName: String, eventDate: NSDate, eventDuration: Int) -> Bool {
        var event = PFObject(className: GROUP)
        
        event["title"] = eventName
        event["date"] = eventDate
        event["duration"] = eventDuration
        
    }
    static func destroyEvent(eventName: String) -> Bool {
        
    }
    static func findEventsWithName(eventName: String) -> [PFObject] {
        
    }
    static func findEventsWithTag(eventTag: String) -> [PFObject] {
        
    }
    static func getlocalEvents() -> [PFObject] {
        
    }
    static func getlocalPrivateEvents() -> [PFObject] {
        
    }
    static func getlocalPublicEvents() -> [PFObject] {
        
    }
    static func getpendingEvents() -> [PFObject] {
        
    }
    static func getuserEvents() -> [PFObject] {
        
    }
    static func joinEvent(eventName: String) -> Bool {
        
    }
    static func joinEventWithID(eventID: String) -> Bool {
        
    }
    static func leaveEvent(eventName: String) -> Bool {
        
    }
    
}

//
//  DataBaseHelper.swift
//  Studr
//
//  Created by Robin Onsay on 10/28/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import Parse

protocol DataBaseHelper{
    
    static var user:PFUser { get set }
    
    static func createEvent(eventName:String,eventDate:NSDate)-> Bool
    static func destroyEvent(eventName:String)->Bool
    static func joinEvent(eventName:String)-> Bool
    //With use of QR-code or map
    static func joinEventWithID(eventID:String)-> Bool
    static func leaveEvent(eventName:String)-> Bool
    static func getuserEvents()->[PFObject]
    static func getpendingEvents()->[PFObject]
    static func getlocalEvents(/*Some object to represent a location*/)->[PFObject]
    static func getlocalPrivateEvents(/*Some object to represent a location*/)->[PFObject]
    static func getlocalPublicEvents(/*Some object to represent a location*/)->[PFObject]
    static func findEventsWithName(eventName:String)->[PFObject]
    static func findEventsWithTag(eventTag:String)->[PFObject]
}
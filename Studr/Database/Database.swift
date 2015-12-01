//
//  Database.swift
//  Studr
//
//  Created by Robin Onsay on 11/2/15.
//  Copyright © 2015 JJR. All rights reserved.
//

import Foundation
import Parse


class Database{
    static func createEventWithBlock(eventName: String, eventDate: NSDate, eventDuration: Int, blockSuccess: () -> Void, blockFail: (error: NSError) ->Void) -> Void{
        let event = PFObject(className:"Group")
        event["title"] = eventName
        event["date"] = eventDate
        event["duration"] = eventDuration
        event["public"] = false
        event.saveInBackgroundWithBlock { (success, error) -> Void in
            if(success){
                blockSuccess()
            }else{
                blockFail(error: error!)
            }
        }
        
        
    }
    static func destroyEvent(eventID: String, blockSuccess: ()->Void, blockFail: (error: NSError) ->Void) -> Void {
        let eventQuery = PFQuery(className: "Group")
        eventQuery.getObjectInBackgroundWithId(eventID) { (event: PFObject?, error: NSError?) -> Void in
            if error == nil && event != nil{
                event?.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if(success){
                        blockSuccess()
                    }else{
                        blockFail(error: error!)
                    }
                })
            }else{
                blockFail(error: error!)
            }
        }
        
        
    }
    static func getUsersEvents(blockSuccess: (events: [PFObject])->Void, blockFail: (error: NSError) ->Void) -> Void{
        let eventsQuery = PFQuery(className: "Group")
        eventsQuery.whereKey("members", equalTo: PFUser.currentUser()!)
        eventsQuery.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if(error == nil){
                blockSuccess(events: events!)
            }else{
                blockFail(error: error!)
            }
        }

    }
    static func getUsersEvents(user: PFUser, blockSuccess: (events: [PFObject])->Void, blockFail: (error: NSError) ->Void) -> Void {
        let eventsQuery = PFQuery(className: "Group")
        eventsQuery.whereKey("members", equalTo: user)
        eventsQuery.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if(error == nil){
                blockSuccess(events: events!)
            }else{
                blockFail(error: error!)
            }
        }
    }
//    static func findEventsWithTag(eventTag: String) -> Void {
//        
//    }
    static func getlocalEvents(location: PFGeoPoint, radius: Double,blockSuccess: (events: [PFObject])->Void, blockFail: (error: NSError) ->Void) -> Void {
        let eventsQuery = PFQuery(className: "Group")
        eventsQuery.whereKey("location", nearGeoPoint: location, withinMiles: radius)
        eventsQuery.whereKey("public", equalTo: true)
        eventsQuery.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if(error == nil){
                blockSuccess(events: events!)
            }else{
                blockFail(error: error!)
            }
        }
    }
    static func getUserPendingEvents(blockSuccess: (events: [PFObject]?)->Void, blockFail: (error: NSError?) ->Void) -> Void {
        let relation = PFUser.currentUser()?.relationForKey("pendingGroup")
        let pendingEventsQuery = relation?.query()
        pendingEventsQuery?.findObjectsInBackgroundWithBlock({ (pendingEvents, error) -> Void in
            if(error == nil){
                blockSuccess(events: pendingEvents)
            }else{
                blockFail(error: error)
            }
        })
        
    }
    static func getUserEvents(blockSuccess: (events: [PFObject]?)->Void, blockFail: (error: NSError?) ->Void) -> Void {
        let relation = PFUser.currentUser()?.relationForKey("acceptedGroup")
        let acceptedEventsQuery = relation?.query()
        acceptedEventsQuery?.findObjectsInBackgroundWithBlock({ (acceptedEvents, error) -> Void in
            if(error == nil){
                blockSuccess(events: acceptedEvents)
            }else{
                blockFail(error: error)
            }
        })
        
    }
    static func joinEvent(event: PFObject!,blockSuccess: ()->Void, blockFail: (error: NSError?) -> Void){
        let memberRelation = event.relationForKey("members")
        memberRelation.addObject(PFUser.currentUser()!)
        event.saveInBackgroundWithBlock { (success, error) -> Void in
            if(success){
                blockSuccess()
            }else{
                blockFail(error: error!)
            }
        }
    }
    static func leaveEvent(event: PFObject!,blockSuccess: ()->Void, blockFail: (error: NSError?) -> Void) -> Void {
        let memberRelation = event.relationForKey("members")
        memberRelation.removeObject(PFUser.currentUser()!)
        event.saveInBackgroundWithBlock { (success, error) -> Void in
            if(success){
                blockSuccess()
            }else{
                blockFail(error: error!)
            }
        }
    }
    static func getCurrentUserFriends(blockSuccess: (friends: [PFObject])->Void, blockFail: (error: NSError?) -> Void){
        let friendsRelation = PFUser.currentUser()?.relationForKey("friend")
        let friendsQuery = friendsRelation?.query()
        friendsQuery?.findObjectsInBackgroundWithBlock({ (friendsFromBlock, errorFromBlock) -> Void in
            if(errorFromBlock == nil){
                blockSuccess(friends: friendsFromBlock!)
            }else{
                blockFail(error: errorFromBlock!)
            }
        })
    }
    
    static func getCurrentUserFriends(withString: String, blockSuccess: (friends: [PFObject])->Void, blockFail: (error: NSError?) -> Void){
        let friendsRelation = PFUser.currentUser()?.relationForKey("friend")
        let friendsQuery = friendsRelation?.query()
        friendsQuery?.whereKey("username", containsString: withString)
        friendsQuery?.findObjectsInBackgroundWithBlock({ (friendsFromBlock, errorFromBlock) -> Void in
            if(errorFromBlock == nil){
                blockSuccess(friends: friendsFromBlock!)
            }else{
                blockFail(error: errorFromBlock!)
            }
        })
    }
    
    static func getUsers(blockSuccess: (users: [PFUser])->Void, blockFail: (error: NSError) ->Void) -> Void{
        let eventsQuery = PFQuery(className: "_User")
        eventsQuery.whereKeyExists("username")
        eventsQuery.findObjectsInBackgroundWithBlock { (users, error) -> Void in
            if(error == nil){
                blockSuccess(users: users as! [PFUser])
            }else{
                blockFail(error: error!)
            }
        }
        
    }
    
    
    
    /**
     This function retrieves a list of All FriendFrequest objects that relate to a specific user
     
     - parameter user:            The user of interest
     - parameter completionBlock: The completion block for the query
     */
    static func getFriendRequestsForUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let predicate = NSPredicate(format: "from = %@ OR to = %@", user, user)
        let query = PFQuery(className: "FriendRequest", predicate: predicate)
        query.includeKey("from")
        query.includeKey("to")
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    /**
     This function retrieves a list of Accepted FriendFrequest objects that relate to a specific user
     
     - parameter user:            The user of interest
     - parameter completionBlock: The completion block for the query
     */
    static func getAcceptedFriendRequestsForUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let predicate = NSPredicate(format: "status = 'accepted' AND from = %@ OR status = 'accepted' AND to = %@", user, user)
        let query = PFQuery(className: "FriendRequest", predicate: predicate)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    /**
     This function retrieves a list of Pending FriendFrequest objects that relate to a specific user
     
     - parameter user:            The user of interest
     - parameter completionBlock: The completion block for the query
     */
    static func getPendingFriendRequestsForUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        let predicate = NSPredicate(format: "status = 'pending' AND from = %@ OR status = 'pending' AND to = %@", user, user)
        let query = PFQuery(className: "FriendRequest", predicate: predicate)
        query.whereKey("from", equalTo:user)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
}

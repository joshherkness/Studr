//
//  MembershipStatus.swift
//  Studr
//
//  Created by Joseph Herkness on 2/4/16.
//  Copyright © 2016 JJR. All rights reserved.
//


enum MembershipStatus: String {
    case Created = "created"
    case Accepted = "accepted"
    case PendingSent = "pending_sent"
    case PendingReceived = "pending_received"
    case Rejected = "rejected"
    case Terminated = "teminated"
    case None
}
//
//  ChallengeModel.swift
//  test-login
//
//  Created by Nicholas Rodman on 9/7/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import Firebase


//The challenge data should be stored under the id of its creator, and the id of its receiver
//If the receiver does not exist yet, we may be able to assign a temporary id to the incoming user
//to allow for the survival of the challenge through the sign-up process

//The challenge data will be stored within a participating user's information, under a unique id for the challenge
//i.e.  users: {
//          user1: {
//              challenges:
//                  challengeOneId:


//A challenge can be accepted or denied, cancelled, or pending.

struct Challenge {
    
    let challengerOne: String
    let challengerTwo: String
    let challengeName: String
    
    var daysOfWeek: Array<String>
    let dateStarted: String
    let totalDaysDuration: String   //may need to become integers later
    let makeItInteresting: Bool
    let wagerAmount: String         //may need to become integers later
    let wagerIsStrict: Bool         //must add logic to change challenge params

//    let publishToFacebook: Bool
    let challengeId: String
    
    let challengePending: Bool
    let challengeAccepted: Bool
    let challengeCancelled: Bool
    
    
    init(challengerOne: String, challengerTwo: String, challengeName: String, daysOfWeek: Array<String>, dateStarted: String, totalDaysDuration: String, makeItInteresting: Bool, wagerAmount: String, wagerIsStrict: Bool, challengeId: String, challengePending: Bool, challengeAccepted: Bool, challengeCancelled: Bool ){
        
        self.challengerOne = challengerOne
        self.challengerTwo = challengerTwo
        self.challengeName = challengeName
        self.daysOfWeek = daysOfWeek
        self.dateStarted = dateStarted
        self.totalDaysDuration = totalDaysDuration
        self.makeItInteresting = makeItInteresting
        self.wagerAmount = wagerAmount
        self.wagerIsStrict = wagerIsStrict
//        self.publishToFacebook = publishToFacebook
        self.challengeId = challengeId
        self.challengePending = challengePending
        self.challengeAccepted = challengeAccepted
        self.challengeCancelled = challengeCancelled
        
    }

    
}


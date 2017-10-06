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


struct Challenge {
    
    let ref: DatabaseReference?
    
    let challengerOne: String
    let challengerTwo: String
    let challengeName: String
    
    let daysOfWeek: Array<String>
    let dateStarted: String
    let dateEnding: String
    let totalDaysDuration: String //may need to become integers
    let makeItInteresting: Bool
    let wagerAmount: String      //may need to become integers
    let wagerIsStrict: Bool       //must add logic to change challenge params

//    let publishToFacebook: Bool
    let challengeId: String
    
    
    //A challenge can be accepted or denied, cancelled, or pending.  Pending begins as true, while 'Accepted' and 'Cancelled' both begin as false.
    var challengePending: Bool
    var challengeAccepted: Bool
    var challengeCancelled: Bool
    
    
    init(challengerOne: String, challengerTwo: String? = nil, challengeName: String? = nil, daysOfWeek: Array<String>? = nil, dateStarted: String? = nil, dateEnding: String? = nil, totalDaysDuration: String? = nil, makeItInteresting: Bool? = nil, wagerAmount: String? = nil, wagerIsStrict: Bool? = nil, challengeId: String? = nil, challengePending: Bool? = nil, challengeAccepted: Bool? = nil, challengeCancelled: Bool? = nil ){
        
        self.challengerOne = challengerOne
        self.challengerTwo = challengerTwo!
        self.challengeName = challengeName!
        self.daysOfWeek = daysOfWeek!
        self.dateStarted = dateStarted!
        self.dateEnding = dateEnding!
        self.totalDaysDuration = totalDaysDuration!
        self.makeItInteresting = makeItInteresting!
        self.wagerAmount = wagerAmount!
        self.wagerIsStrict = wagerIsStrict!
        self.challengeId = challengeId!
        self.challengePending = challengePending!
        self.challengeAccepted = challengeAccepted!
        self.challengeCancelled = challengeCancelled!
        //        self.publishToFacebook = publishToFacebook
        self.ref = nil
        
    }
    
    
    init(snapshot: DataSnapshot) {
        
            challengerOne = (snapshot.value(forKey: "challengerOne") as? String)!
            challengerTwo = snapshot.value(forKey: "challengerTwo") as! String
            challengeName = snapshot.value(forKey: "challengeName") as! String
            daysOfWeek = snapshot.value(forKey: "daysOfWeek") as! Array<String>
            dateStarted = snapshot.value(forKey: "dateStarted") as! String
            dateEnding = snapshot.value(forKey: "dateEnding") as! String
            totalDaysDuration = snapshot.value(forKey: "totalDaysDuration") as! String
            makeItInteresting = snapshot.value(forKey: "makeItInteresting") as! Bool
            wagerAmount = snapshot.value(forKey: "wagerAmount") as! String
            wagerIsStrict = snapshot.value(forKey: "wagerIsStrict") as! Bool
            challengeId = snapshot.value(forKey: "challengeId") as! String
            challengePending = snapshot.value(forKey: "challengePending") as! Bool
            challengeAccepted = snapshot.value(forKey: "challengeAccepted") as! Bool
            challengeCancelled = snapshot.value(forKey: "challengeCancelled") as! Bool
            ref = snapshot.ref
        
    }

}

//
//  UserModel.swift
//  test-login
//
//  Created by Nicholas Rodman on 8/21/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation


struct User {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    
    init(userId: String, firstName: String, lastName: String, email: String) {
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email

    }

    
}

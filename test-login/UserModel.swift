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
    
    init(userId: String, firstName: String, lastName: String) {
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName

    }

    
}

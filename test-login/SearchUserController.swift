////
////  SearchUserController.swift
////  test-login
////
////  Created by Nicholas Rodman on 9/20/17.
////  Copyright © 2017 Nick. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Firebase
//
//class SearchUserController: UIViewController {
//    
//    //Init Firebase
//    var ref: DatabaseReference!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        ref = Database.database().reference()
//        
//    }
//    
//    @IBOutlet weak var searchUserInputer: UITextField!
//    
//    @IBOutlet weak var retrievedUserLabel: UILabel!
//    
//    
//    @IBAction func searchUserButton(_ sender: Any) {
//        
//        if let user = searchUserInputer.text {
//            searchUser(user: user)
//        }
//    }
//    
//  //Searches a user entered email from Firebase and returns data if it matches
//    func searchUser(user: String) {
//        
//        let userRef = Database.database().reference().child("users")
//        let userQuery = userRef.queryOrdered(byChild: "email").queryEqual(toValue: user)
//        
//    
//        userQuery.observe(.value, with: { (snapshot) in
//            
//            for child in snapshot.children.allObjects {
//                
//                let childSnapshot = snapshot.childSnapshot(forPath: (child as AnyObject).key)
//
//                if let snapshotValue = childSnapshot.value as? NSDictionary {
//                    
//                   if let firstName = snapshotValue["firstName"] as? String,
//                   let lastName = snapshotValue["lastName"] as? String,
//                   let userId = snapshotValue["userId"] as? String,
//                   let email = snapshotValue["email"] as? String {
//                    
//                    let retrievedUser = User(userId: userId, firstName: firstName, lastName: lastName, email: email)
//            
//                        self.retrievedUserLabel.text = firstName
//                        print(firstName)
//                        print(retrievedUser)
//                    }
//                } else {
//                    print("Error: not retrieving user data")
//                }
//                
//            }
//        
//        })
//    }
//    
//   
//
//    
//    
//    
//}
//
//
//
//

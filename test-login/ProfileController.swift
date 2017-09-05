//
//  ProfileController.swift
//  test-login
//
//  Created by Nicholas Rodman on 8/22/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ProfileController: UIViewController {
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = Database.database().reference()
        
        checkIfUserLoggedIn()
    }
    
    
    
    @IBOutlet weak var currentUserLabel: UILabel!
    
    
//    Check if user is logged in
    
    func checkIfUserLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()

            
        } else {
            
            let userId = Auth.auth().currentUser?.uid
            
            //Retrieve user firstName from current user based on id
            Database.database().reference().child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let currentUser = snapshot.value as? [String: AnyObject] {
                    self.currentUserLabel.text = currentUser["firstName"] as? String
                }
                
                print(snapshot)
            }, withCancel: nil)
                
        }
    }
    
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }

    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            
            self.dismiss(animated: true, completion: nil)
        } catch let logoutError {
            print(logoutError)
        }

    }
    
    @IBAction func createChallengePressed(_ sender: Any) {
    }
    
    
    
    
    
}

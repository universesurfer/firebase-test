//
//  ViewController.swift
//  test-login
//
//  Created by Nicholas Rodman on 8/18/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class ViewController: UIViewController {

    //Initialize our database reference
    var ref: DatabaseReference!
    


  
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, let firstName = firstNameField.text, let lastName = lastNameField.text {
            
            Auth.auth().createUser(withEmail: email, password: password ) { (user, error) in
                // ...
                
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                //add popup later
                }
                
                let userID = user!.uid
                
                //Instantiate our User model - set key values equal to optionals above from sign up form
                let userAccount = User(userId: userID, firstName: firstName, lastName: lastName, email: email)
                
                //Initialize an empty dictionary to hold the keys and values to upload to Firebase
                var userAccountDict = [String:AnyObject]()
                
                //Use a dictionary method to update the keys and matching values. The values are the ones from UserAccount model's properties and the keys are what we decide we want them to be named in FirebaseDatabase. Use these keys to extract the values
                userAccountDict.updateValue(userAccount.userId as AnyObject, forKey: "userId")
                userAccountDict.updateValue(userAccount.firstName as AnyObject, forKey: "firstName")
                userAccountDict.updateValue(userAccount.lastName as AnyObject, forKey: "lastName")
                userAccountDict.updateValue(userAccount.email as AnyObject, forKey: "email")
                
                
                //Upload dictionary with the keys and values set above. The database will hold these key/value pairs under the "users" node.
                self.ref.child("users").child(user!.uid).setValue(userAccountDict)
                print("User registered in Firebase with a userId of " + user!.uid)
                
                
//                self.presentLoggedInScreen()
                
                }
            
            
        }
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                // ...
                
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                    
                }
                
                print ("Success")
                
//                self.performSegue(withIdentifier: "profile", sender: self)
                self.presentLoggedInScreen()
//
                }
        }
    
    }
    
    
    func presentLoggedInScreen() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInVC: ProfileController = storyboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        self.present(loggedInVC, animated: true, completion: nil)
    }
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    

}


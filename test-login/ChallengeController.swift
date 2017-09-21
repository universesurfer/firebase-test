//
//  ChallengeController.swift
//  test-login
//
//  Created by Nicholas Rodman on 8/25/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import Contacts
import ContactsUI
import Messages
import MessageUI


class ChallengeController: UIViewController, CNContactPickerDelegate {
    
//    var newChallenge = Challenge(challengerOne: <#T##String#>, challengerTwo: <#T##String#>, challengeName: <#T##String#>, daysOfWeek: <#T##Array<String>#>, totalDaysDuration: <#T##Int#>, makeItInteresting: <#T##Bool#>, wagerAmount: <#T##Int#>, wagerIsStrict: <#T##Bool#>, publishToFacebook: <#T##Bool#>, challengeId: <#T##String#>)
    
    
    //FIREBASE INITIALIZER
    var ref: DatabaseReference!
    
    //INITIALIZE DATE
    let today = NSDate()
    let dateComponents = NSDateComponents()
    
    //Date Formatter
    let formatter = DateFormatter()
    
//    let newDate = DateFormatter.string
    
    

    
//    let components = calendar.components(.Day, fromDate: date)
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = Database.database().reference()
        
        
        
    }

    
    //DATE SETTING
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBAction func getCurrentDatePressed(_ sender: Any) {
        currentDateLabel.text = String(describing: today)
    }
    
    
    //DAYS ENTERED INPUT
    @IBOutlet weak var daysEnteredInput: UITextField!
    


    
    
    
    @IBAction func updateDatePressed(_ sender: Any) {
        if let userEnteredDays = Int(daysEnteredInput.text!) {
            let updatedDate = Calendar.current.date(byAdding: .day, value: userEnteredDays, to: today as Date)
            
            currentDateLabel.text = String(describing: updatedDate)
            
        } else {
            print("Error, no days entered")
        }
        

    }
    
    
    
    
    
    
    @IBOutlet weak var showContactLabel: UILabel!
    

    @IBAction func searchContactsPressed(_ sender: Any) {
        
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == CNAuthorizationStatus.notDetermined {
            
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
                
                if success {
                    self.openContacts()
                }
                else {
                    print("Not authorized")
                }
            })
            
        } else if authStatus == CNAuthorizationStatus.authorized {
            
            self.openContacts()
            
        }
    }
    
    
    func openContacts() {
        
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
        
    }
    

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
        picker.dismiss(animated: true) {
            
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        //When user selects any contact
        let fullName = "\(contact.givenName) \(contact.familyName)"
        
        let contactPhoneNumber: String
        
        //Make sure that contact numbers exist
        if contact.phoneNumbers.count > 0 {
            contactPhoneNumber = ((contact.phoneNumbers[0].value ).value(forKey: "digits") as? String)!
            
             print(contactPhoneNumber)
            
        } else {
            contactPhoneNumber = ""
        }

    
        
        self.showContactLabel.text = "Contact: \(fullName) \(contactPhoneNumber)"
        
        print(fullName)
        print(contact.emailAddresses)
    }
    

    
    @IBAction func sendMessagePressed(_ sender: Any) {
        let messageVC = MFMessageComposeViewController()
        
        if (MFMessageComposeViewController.canSendText()) {
        
        messageVC.body = "Enter a message"
        messageVC.recipients = ["Enter telephone number"]
        messageVC.messageComposeDelegate = self as? MFMessageComposeViewControllerDelegate
        
        self.present(messageVC, animated: false, completion: nil)
            
        } else {
            print("Texting not available")
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        switch (result) {
        case MessageComposeResult.cancelled:
            print("Message cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
            break;
            
        }
    }
    
//__________NAME CHALLENGE INPUT__________
    
    @IBOutlet weak var challengeNameInput: UITextField!

//__________NUMBER OF DAYS INPUT__________
    
    @IBOutlet weak var numberOfDaysInput: UITextField!
    
    
    
// ________DAYS OF THE WEEK PICKER__________
    
    
    //This array holds days of the week, which will be pushed into the array if the user selects them, and removed if user deselects
    
    var daysOfTheWeekArray: Array<String> = []
    

    
    
    //DAYS OF THE WEEK BUTTONS
    @IBOutlet weak var sundayPressed: UIButton!
    @IBOutlet weak var mondayPressed: UIButton!
    @IBOutlet weak var tuesdayPressed: UIButton!
    @IBOutlet weak var wednesdayPressed: UIButton!
    @IBOutlet weak var thursdayPressed: UIButton!
    @IBOutlet weak var fridayPressed: UIButton!
    @IBOutlet weak var saturdayPressed: UIButton!
    
    @IBAction func sundayIsPressed(_ sender: Any) {
        
    sundayPressed.setTitleShadowColor(UIColor.white, for: .normal)
    sundayPressed.setTitleShadowColor(UIColor.blue, for: .selected)
        
        if let sundayPressed = sender as? UIButton {
            if sundayPressed.isSelected {
                // set deselected
                sundayPressed.isSelected = false
                
                //Remove the day from our array
                daysOfTheWeekArray = daysOfTheWeekArray.filter({$0 != "sunday"})
                print(daysOfTheWeekArray)
                
            } else {
                // set selected
                sundayPressed.isSelected = true
                
                //Add selected day
                daysOfTheWeekArray.append("sunday")
                print(daysOfTheWeekArray)
            }
        }
    }
    
    
    @IBAction func mondayIsPressed(_ sender: Any) {
        
        mondayPressed.setTitleShadowColor(UIColor.white, for: .normal)
        mondayPressed.setTitleShadowColor(UIColor.blue, for: .selected)
        
        if let mondayPressed = sender as? UIButton {
            if mondayPressed.isSelected {
                // set deselected
                mondayPressed.isSelected = false
                
                //Remove the day from our array
                daysOfTheWeekArray = daysOfTheWeekArray.filter({$0 != "monday"})
                print(daysOfTheWeekArray)
                
            } else {
                //set as selected
                mondayPressed.isSelected = true
                
                //Add selected day
                daysOfTheWeekArray.append("monday")
                print(daysOfTheWeekArray)
            }
        }
    }

    @IBAction func tuesdayIsPressed(_ sender: Any) {
        
        tuesdayPressed.setTitleShadowColor(UIColor.white, for: .normal)
        tuesdayPressed.setTitleShadowColor(UIColor.blue, for: .selected)
        
        if let tuesdayPressed = sender as? UIButton {
            if tuesdayPressed.isSelected {
                // set deselected
                tuesdayPressed.isSelected = false
                
                //Remove the day from our array
                daysOfTheWeekArray = daysOfTheWeekArray.filter({$0 != "tuesday"})
                print(daysOfTheWeekArray)
                
            } else {
                // set selected
                tuesdayPressed.isSelected = true
                
                //Add selected day
                daysOfTheWeekArray.append("tuesday")
                print(daysOfTheWeekArray)
                
                
            }
        }
        
    }
    
    
    @IBAction func wednesdayIsPressed(_ sender: Any) {
        
        wednesdayPressed.setTitleShadowColor(UIColor.white, for: .normal)
        wednesdayPressed.setTitleShadowColor(UIColor.blue, for: .selected)
        
        if let wednesdayPressed = sender as? UIButton {
            if wednesdayPressed.isSelected {
                // set deselected
                wednesdayPressed.isSelected = false
                
                //Remove the day from our array
                daysOfTheWeekArray = daysOfTheWeekArray.filter({$0 != "wednesday"})
                print(daysOfTheWeekArray)
                
            } else {
                // set selected
                wednesdayPressed.isSelected = true
                
                //Add selected day
                daysOfTheWeekArray.append("wednesday")
                print(daysOfTheWeekArray)
                
            }
        }
        
    }
    
    @IBAction func thursdayIsPressed(_ sender: Any) {
        
        thursdayPressed.setTitleShadowColor(UIColor.white, for: .normal)
        thursdayPressed.setTitleShadowColor(UIColor.blue, for: .selected)
        
        if let thursdayPressed = sender as? UIButton {
            if thursdayPressed.isSelected {
                // set deselected
                thursdayPressed.isSelected = false
                
                //Remove the day from our array
                daysOfTheWeekArray = daysOfTheWeekArray.filter({$0 != "thursday"})
                print(daysOfTheWeekArray)
                
            } else {
                // set selected
                thursdayPressed.isSelected = true
                
                //Add selected day
                daysOfTheWeekArray.append("thursday")
                print(daysOfTheWeekArray)
                
            }
        }

    }
    
    
    @IBAction func fridayIsPressed(_ sender: Any) {
        
        fridayPressed.setTitleShadowColor(UIColor.white, for: .normal)
        fridayPressed.setTitleShadowColor(UIColor.blue, for: .selected)
        
        if let fridayPressed = sender as? UIButton {
            if fridayPressed.isSelected {
                // set deselected
                fridayPressed.isSelected = false
                
                //Remove the day from our array
                daysOfTheWeekArray = daysOfTheWeekArray.filter({$0 != "friday"})
                print(daysOfTheWeekArray)
                
            } else {
                // set selected
                fridayPressed.isSelected = true
                
                //Add selected day
                daysOfTheWeekArray.append("friday")
                print(daysOfTheWeekArray)
                
            }
        }

    }
    
    
    @IBAction func saturdayIsPressed(_ sender: Any) {
        
        saturdayPressed.setTitleShadowColor(UIColor.white, for: .normal)
        saturdayPressed.setTitleShadowColor(UIColor.blue, for: .selected)
        
        if let saturdayPressed = sender as? UIButton {
            if saturdayPressed.isSelected {
                // set deselected
                saturdayPressed.isSelected = false
                
                //Remove the day from our array
                daysOfTheWeekArray = daysOfTheWeekArray.filter({$0 != "saturday"})
                print(daysOfTheWeekArray)
                
            } else {
                // set selected
                saturdayPressed.isSelected = true
                
                //Add selected day
                daysOfTheWeekArray.append("saturday")
                print(daysOfTheWeekArray)
                
            }
        }

    }
    
    
    
    
    
//_____________WAGER MAKER___________
    @IBOutlet weak var wagerInputTextField: UITextField!
    @IBOutlet weak var wagerToggle: UISwitch!
    
    var switchStatus: Bool = true

    
    @IBAction func wagerTogglePressed(_ sender: Any) {
        
        if wagerToggle.isOn == true {
            switchStatus = true
            print(switchStatus)
            
        } else if wagerToggle.isOn == false {
            
            switchStatus = false
            print(switchStatus)
            
        }
    }
    

//_____________CANCELLATION POLICY____________
    
    var strictStatus: Bool = true
    
    @IBOutlet weak var cancellationToggle: UISwitch!
    
    
    @IBAction func cancellationTogglePressed(_ sender: Any) {
        
        if cancellationToggle.isOn == true {
            strictStatus = true
        } else if cancellationToggle.isOn == false {
            strictStatus = false
        }
    }
    
    
    
    
//EMAIL USER SEARCH
    
    @IBOutlet weak var searchUserInputer: UITextField!
    
    @IBOutlet weak var retrievedUserLabel: UILabel!
   
    
    @IBAction func searchUserButton(_ sender: Any) {
        
        if let user = searchUserInputer.text {
            searchUser(user: user)
        }
    }
    
    //Searches a user entered email from Firebase and returns data if it matches
    func searchUser(user: String) {
        
        let userRef = Database.database().reference().child("users")
        let userQuery = userRef.queryOrdered(byChild: "email").queryEqual(toValue: user)
        
        
        userQuery.observe(.value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects {
                
                let childSnapshot = snapshot.childSnapshot(forPath: (child as AnyObject).key)
                
                if let snapshotValue = childSnapshot.value as? NSDictionary {
                    
                    if let firstName = snapshotValue["firstName"] as? String,
                        let lastName = snapshotValue["lastName"] as? String,
                        let userId = snapshotValue["userId"] as? String,
                        let email = snapshotValue["email"] as? String {
                        
                        let retrievedUser = User(userId: userId, firstName: firstName, lastName: lastName, email: email)
                        
                        self.retrievedUserLabel.text = firstName
                        self.showContactLabel.text = firstName
                        
                        print(firstName)
                        print(retrievedUser)
                    }
                } else {
                    print("Error: not retrieving user data")
                }
                
            }
            
        })
    }
    
    
//SUBMIT THE CHALLENGE-------------------------------------
    
    
    @IBAction func submitChallengePressed(_ sender: Any) {

//        let currentUser = Auth.auth().currentUser?.uid
        let thisChallengeId = ref.childByAutoId().key
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        //Convert today's date to string to comply with Firebase
        let dateString = formatter.string(from: today as Date)
        
       
        
//        let tomorrow = Calendar.current.date(byAdding:
//            .day, // updated this params to add hours
//            value: 1,
//            to: now)
        
    
        let makeItInteresting = switchStatus
//        let challengeId = thisChallengeId
        let challengePending = true
        let challengeAccepted = false
        let challengeCancelled = false
        let wagerIsStrict = strictStatus
//        let daysOfWeek = daysOfTheWeekArray
        
        
        
        
        
        
        if let challengerOne = Auth.auth().currentUser?.uid, let challengerTwo = showContactLabel.text, let challengeName = challengeNameInput.text, let wagerAmount = wagerInputTextField.text, let challengeDuration = daysEnteredInput.text, let userSelectedDuration = Int(challengeDuration) {
    
         
            
         let dateEnding = String(describing: Calendar.current.date(byAdding: .day, value: userSelectedDuration, to: today as Date))
            
        //Instantiate our Challenge model - set key values equal to optionals above from sign up form
            
            let newChallenge = Challenge(challengerOne: challengerOne, challengerTwo: challengerTwo, challengeName: challengeName, daysOfWeek: daysOfTheWeekArray, dateStarted: dateString, dateEnding: dateEnding, totalDaysDuration: challengeDuration, makeItInteresting: makeItInteresting, wagerAmount: wagerAmount, wagerIsStrict: wagerIsStrict, challengeId: thisChallengeId, challengePending: challengePending, challengeAccepted: challengeAccepted, challengeCancelled: challengeCancelled)
            
            
            //Initialize an empty dictionary to hold the keys and values to upload to Firebase
            var challengeDictionary = [String:AnyObject]()
            
            
            //Use a dictionary method to update the keys and matching values. The values are the ones from UserAccount model's properties and the keys are what we decide we want them to be named in FirebaseDatabase. Use these keys to extract the values
            challengeDictionary.updateValue(newChallenge.challengerOne as AnyObject, forKey: "challengerOne")
            challengeDictionary.updateValue(newChallenge.challengerTwo as AnyObject, forKey: "challengerTwo")
            challengeDictionary.updateValue(newChallenge.challengeName as AnyObject, forKey: "challengeName")
            challengeDictionary.updateValue(newChallenge.daysOfWeek as AnyObject, forKey: "daysOfWeek")
            challengeDictionary.updateValue(newChallenge.dateStarted as AnyObject, forKey: "dateStarted")
            challengeDictionary.updateValue(newChallenge.dateEnding as AnyObject, forKey: "dateEnding")
            challengeDictionary.updateValue(newChallenge.totalDaysDuration as AnyObject, forKey: "totalDaysDuration")
            challengeDictionary.updateValue(newChallenge.makeItInteresting as AnyObject, forKey: "makeItInteresting")
            challengeDictionary.updateValue(newChallenge.wagerAmount as AnyObject, forKey: "wagerAmount")
            challengeDictionary.updateValue(newChallenge.wagerIsStrict as AnyObject, forKey: "wagerIsStrict")
            challengeDictionary.updateValue(newChallenge.challengeId as AnyObject, forKey: "challengeId")
            challengeDictionary.updateValue(newChallenge.challengePending as AnyObject, forKey: "challengePending")
            challengeDictionary.updateValue(newChallenge.challengeAccepted as AnyObject, forKey: "challengeAccepted")
            challengeDictionary.updateValue(newChallenge.challengeCancelled as AnyObject, forKey: "challengeCancelled")
            
            
            //Upload dictionary with the keys and values set above. The database will hold these key/value pairs under the "challenges" node.
            self.ref.child("users").child(challengerOne).child("challenges").child(thisChallengeId).setValue(challengeDictionary)
            print("Challenge saved to Firebase database")
            
        }
    
    }




}



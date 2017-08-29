//
//  ChallengeController.swift
//  test-login
//
//  Created by Nicholas Rodman on 8/25/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import Contacts
import ContactsUI
import Messages
import MessageUI


class ChallengeController: UIViewController {

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = Database.database().reference()
    
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
        contactPicker.delegate = self as? CNContactPickerDelegate
        self.present(contactPicker, animated: true, completion: nil)
        
    }
    

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
        picker.dismiss(animated: true) {
            
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        //When user selects any contact
        let fullName = "\(contact.givenName) \(contact.familyName)"
        
        self.showContactLabel.text = "Contact: \(fullName)"
        
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

    
    
    
}

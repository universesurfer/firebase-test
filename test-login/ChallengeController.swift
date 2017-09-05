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
import JTAppleCalendar


class ChallengeController: UIViewController {
    
    //DATE FORMATTER
    let formatter = DateFormatter()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    //CALENDAR COLORS
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor.init(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor.init(colorWithHexValue: 0x4e3f5d)
    
    //FUNCTION THAT HANDLES SELECTED CELL COLOR
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        
        //Removes randomly selected cells
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
        
    }
    
    //HANDLE CELL TEXT COLOR
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    //FIREBASE INITIALIZER
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Allows for date range selection in calendar
        calendarView.allowsMultipleSelection  = true
        calendarView.rangeSelectionWillBeUsed = true
        
        ref = Database.database().reference()
    
        setupCalendarView()
    }

    func setupCalendarView(){
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //Setup labels
        calendarView.visibleDates{ (visibleDates) in
            
            self.setupViewsOfCalendar(from: visibleDates)
            
        }
        
    }
    
    
    //SETUP VIEWS FROM CALENDAR - MAKES THE VIEWDIDLOAD LOAD VISIBLEDATES 
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        
        //Formats the 'year' and 'month' labels on top of our calendar
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        year.text = formatter.string(from: date)
        
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

extension ChallengeController: JTAppleCalendarViewDataSource {
    
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters{
        
//        let jtDelegate = JTAppleCalendarViewDelegate.self
//        let jtDataSource = JTAppleCalendarViewDataSource.self
        
        formatter.dateFormat = "yyyy MM dd"
        
        
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")! //DO NOT FORCE UNWRAP IN ACTUAL APP
        let endDate = formatter.date(from: "2017 12 31")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
}

extension ChallengeController: JTAppleCalendarViewDelegate {
    
    //SHOW THE CELL
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.dateLabel.text = cellState.text
        
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    //Setup calendar views from visibleDates
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        setupViewsOfCalendar(from: visibleDates)
    }
    
}

    extension UIColor {
    convenience init (colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

//
//  ChallengeManager.swift
//  test-login
//
//  Created by Nicholas Rodman on 10/3/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class ChallengeManager: UICollectionViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    
    let currentUser = Auth.auth().currentUser?.uid
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        
        print("CHALLENGE MANAGER WORKING!")
        
        print(currentUser!)
        
        retrieveAllChallenges(user: currentUser!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//--------------RETRIEVE ALL CHALLENGES TO FILTER ON CLIENT------------
    
    //Array for all user challenges
    var allChallenges: [Challenge] = []
    
    func retrieveAllChallenges(user: String) {
        
        let challengeRef = Database.database().reference().child("users").child(currentUser!).child("challenges")

        //DataEventType will update our snapshot whenever their are changes to our database
        challengeRef.observe(DataEventType.value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects {
                
                let childSnapshot = snapshot.childSnapshot(forPath: (child as AnyObject).key)
      
            if let snapshotValue = childSnapshot.value as? NSDictionary {
                
                    if let challengeAccepted = snapshotValue["challengeAccepted"] as? Bool,
                        let challengeCancelled = snapshotValue["challengeCancelled"] as? Bool,
                        let challengeId = snapshotValue["challengeId"] as? String,
                        let challengeName = snapshotValue["challengeName"] as? String,
                        let challengePending = snapshotValue["challengePending"] as? Bool,
                        let challengerOne = snapshotValue["challengerOne"] as? String,
                        let challengerTwo = snapshotValue["challengerTwo"] as? String,
                        let dateEnding = snapshotValue["dateEnding"] as? String,
                        let dateStarted = snapshotValue["dateStarted"] as? String,
                        let daysOfWeek = snapshotValue["daysOfWeek"] as? Array<String>,
                        let makeItInteresting = snapshotValue["makeItInteresting"] as? Bool,
                        let totalDaysDuration = snapshotValue["totalDaysDuration"] as? String,
                        let wagerAmount = snapshotValue["wagerAmount"] as? String,
                        let wagerIsStrict = snapshotValue["wagerIsStrict"] as? Bool  {
                        
                        
                        //User returned from email search
                        let retrievedChallenge = Challenge(challengerOne: challengerOne, challengerTwo: challengerTwo, challengeName: challengeName, daysOfWeek: daysOfWeek, dateStarted: dateStarted, dateEnding: dateEnding, totalDaysDuration: totalDaysDuration, makeItInteresting: makeItInteresting, wagerAmount: wagerAmount, wagerIsStrict: wagerIsStrict, challengeId: challengeId, challengePending: challengePending, challengeAccepted: challengeAccepted, challengeCancelled: challengeCancelled)
                
                self.allChallenges.append(retrievedChallenge)
                print("INSIDE ALL CHALLENGES \(self.allChallenges)")
                        
                        
                        //Because we are dealing with an async call, we reload our collectionView to make sure our data displays once we have it
                        DispatchQueue.main.async(execute: {
                            self.collectionView?.reloadData()
                        })

            
                
//                self.filterChallenges()
                print(self.pendingFilterChallenges)
                
                }
                
                print(self.allChallenges.count)
                }
            }
        })
    }
    

    
//------------------RELOAD DATA----------------------
    
    func reload() {
        
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
        })
    }

//------------------CHALLENGE FILTERS----------------
    
    
    
    //Filter and save the pendingChallenges into this array
    var pendingFilterChallenges: [Challenge] {
         print("inside my pendingFilterChallenges array!")
        return allChallenges.filter { $0.challengePending == true }
       
    }
    
    //Filters current challenges.  We may want to update a new key in the model i.e. 'hasEnded' or 'challengeCompleted' based off the timer we create to make sure the challenge is indeed current.
    
//    var currentFilterChallenges: [NSDictionary] {
//        print("inside my currentFilterChallenges array")
//        return allChallenges.filter{ $0.value(forKey: "challengePending") as? Bool == false && $0.value(forKey: "challengeAccepted") as? Bool == true }
//    }
//    
    
    
    
//--------------RETRIEVE PENDING CHALLENGES--------------
    
    

//
//    var allPendingChallenges = [NSDictionary]()
//    
//    func retrievePendingChallenges(user: String) {
//        
//        let challengeRef = Database.database().reference().child("users").child(currentUser!).child("challenges")
//        let query = challengeRef.queryOrdered(byChild: "challengePending").queryEqual(toValue: true)
//        
//        
//        //DataEventType will update our snapshot whenever their are changes to our database
//        query.observe(DataEventType.value, with: { (snapshot) in
//            
//            if let snapshotValue = snapshot.value as? NSDictionary {
//                
//                self.allPendingChallenges = [snapshotValue]
//                
//                print("Inside pending challenges snapshot")
//                print(snapshotValue)
//                
//            }
//        })
//    }
    
    
//--------------RETRIEVE CURRENT CHALLENGES----------------
    
    

    


    
    
    
//--------------CHALLENGE FILTER CONTROL-------------------
    
    var dataFilter = 0
    
    @IBOutlet weak var challengeFilterSegment: UISegmentedControl!
    
    
    @IBAction func challengeFilterChanged(_ sender: Any) {
        
        switch challengeFilterSegment.selectedSegmentIndex {
        
        case 0:
            dataFilter = 0
            print("inside current challenges selection")
        case 1:
            dataFilter = 1
            print("inside pending filter selection \(pendingFilterChallenges)")
        case 2:
            dataFilter = 2
            print("inside completed challenges selection")
            
        default: break
            
        }
        
        reload()
        
    }
    
    
    
    
    
    
    

    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        

        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        
        switch dataFilter {
        case 0:
             print("printing allChallenges.count until we have currentChallenges setup")
            return allChallenges.count
        case 1:
            return pendingFilterChallenges.count
        case 2:
            print("printing allChallenges.count until we have completedChallenges setup")
            return allChallenges.count
                 default:
            return 1
            
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChallengeCell
        

        // Configure the cell
        cell.backgroundColor = .white
        
        var challenge: Challenge
        
        switch dataFilter {
            
            case 0:
                cell.challengeNameLabel.text = "Current Challenges"
                print("inside current dataFilter")
            case 1:
                challenge = pendingFilterChallenges[indexPath.row]
                cell.challengeNameLabel.text = challenge.challengeName
                print("inside pending dataFilter ")
            case 2:
                cell.challengeNameLabel.text = "Completed Challenges"
                print("inside completed dataFilter")
            default:
                cell.challengeNameLabel.text = "Nothin' here yet!"
                print("inside default")
            
        }
        
        
        
        return cell
        
        
        }
//        let challenge = pendingFilterChallenges[indexPath.row]
        
//        cell.challengeNameLabel.text = challenge.challengeName
    
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */





class ChallengeCell: UICollectionViewCell {

    @IBOutlet weak var challengeNameLabel: UILabel!
    
}












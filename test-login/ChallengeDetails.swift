//
//  ChallengeDetails.swift
//  test-login
//
//  Created by Nicholas Rodman on 10/6/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import UIKit

class ChallengeDetails: UIViewController {
    
    var selectedChallenge: Challenge!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        challengeName.text = selectedChallenge.challengeName
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBOutlet weak var challengeName: UILabel!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

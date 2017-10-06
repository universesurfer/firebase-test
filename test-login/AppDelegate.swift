//
//  AppDelegate.swift
//  test-login
//
//  Created by Nicholas Rodman on 8/18/17.
//  Copyright © 2017 Nick. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
//private let publishableKey: String = "pk_test_QbAtfrImSVvy7WM42aewfLVd"
    
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //------ Configure Stripe ------
//        STPPaymentConfiguration.shared().publishableKey = "pk_test_QbAtfrImSVvy7WM42aewfLVd"
        
        FirebaseApp.configure()
        return true
    }

  
}


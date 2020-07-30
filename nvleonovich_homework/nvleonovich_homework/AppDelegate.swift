//
//  AppDelegate.swift
//  nvleonovich_homework
//
//  Created by nvleonovich on 29.03.2020.
//  Copyright © 2020 nvleonovich. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
      return true
    }

}

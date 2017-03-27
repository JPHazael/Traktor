//
//  AppDelegate.swift
//  Traktor
//
//  Created by admin on 3/23/17.
//  Copyright © 2017 JPDaines. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability: Reachability?
    
    
    class func instance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Reachability Observer
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.checkForReachability), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        self.reachability = Reachability.forInternetConnection()
        self.reachability!.startNotifier()
        return true
    }
    
    func checkForReachability(notification: Notification){
        
        let remoteHostStatus = self.reachability!.currentReachabilityStatus()
        
        if remoteHostStatus == NotReachable{
            DispatchQueue.main.async{
                let alert = SCLAlertView()
                _ = alert.showError("OOPS", subTitle: "It Appears you have lost your internet connection. This my affect the performance of the app.")
            }
        }
    }
}


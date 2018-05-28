//
//  AppDelegate.swift
//  Face Based ID
//
//  Created by Rahul Golwalkar on 26/05/18.
//  Copyright © 2018 Rahul Golwalkar. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId:"us-east-1:f69145d7-7ff2-4afb-b441-5ecb80a5bde7")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration

        
        // Just an example how we can store key value pairs in the aws cognito user data set
//        // Initialize the Cognito Sync client
//        let syncClient = AWSCognito.default()
//
//        // Create a record in a dataset and synchronize with the server
//        let dataset = syncClient.openOrCreateDataset("myDataset")
//        dataset.setString("myValue", forKey:"myKey")
//        dataset.synchronize().continueWith {(task: AWSTask!) -> AnyObject? in
//            // Your handler code here
//            print("Synchronized!!!!")
//            print(task)
//            print(dataset)
//            return nil
//
//        }
//        print(dataset.string(forKey: "myKey"))

        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


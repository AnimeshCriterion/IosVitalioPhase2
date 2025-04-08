////
////  AppDelegate.swift
////  vitalio_native
////
////  Created by HID-18 on 02/04/25.
////
//
//import UIKit
//import Firebase
//import FirebaseMessaging
//
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//        
//        // Register for push notifications
//        UNUserNotificationCenter.current().delegate = self
//        application.registerForRemoteNotifications()
//        
//        Messaging.messaging().delegate = self
//        
//        return true
//    }
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("✅ Firebase Token: \(fcmToken ?? "No Token")")
//    }
//}
//
//

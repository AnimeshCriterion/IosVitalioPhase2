//
//  VitalioApp.swift
//  Vitalio
//
//  Created by HID-18 on 11/03/25.
//

import SwiftUI
import Firebase
import FirebaseMessaging

@main
struct VitalioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var themeManager = ThemeManager()
    @ObservedObject private var route = Routing()
    @StateObject var loginViewModel = LoginViewModal()
    @StateObject var pills = PillsViewModal()   
    @StateObject var dashboard = DashboardViewModal()
    @StateObject var fluidVM = FluidaViewModal()
    @StateObject var symptomsViewModal = SymptomsViewModal()
    @StateObject var vitalvm = VitalsViewModal()
    @StateObject var dietViewModel = DietViewModel()
    @StateObject var uploadReportViewModel = UploadReportViewModel() 
    @StateObject var allergiesViewModel = AllergiesViewModal()
    @StateObject var editProfileVM = EditProfileViewModal()
    @StateObject var chatViewModel = ChatViewModel()
    @StateObject var signUpViewModal = SignUpViewModal()
    @StateObject var popupManager = PopupManager()
//    @StateObject var webSocketManager = WebSocketManager(userId: "1234")/
    @StateObject var localizer = LocalizationManager.shared


    init() {
        _ = NetworkMonitor.shared  // starts monitoring
        FirebaseApp.configure()
        requestPushNotificationPermission()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("❌ Error fetching FCM token: \(error.localizedDescription)")
                } else if let token = token {
                    print("🔥 FCM token: \(token)")
                    UserDefaultsManager.shared.set(token, forKey: "fcmToken")
                    let fcmToken = UserDefaultsManager.shared.get(forKey: "fcmToken") ?? "notoken"
                    
                } else {
                    print("⚠️ No FCM token available yet.")
                }
            }
        }
 
    }

    var body: some Scene {
        WindowGroup {
//            NavigationStack(path: $route.navpath){
                ContentView()
//            }
            .environmentObject(route)
            .environmentObject(themeManager)
            .environmentObject(loginViewModel)
            .environmentObject(pills)
            .environmentObject(dashboard)
            .environmentObject(fluidVM)
            .environmentObject(symptomsViewModal)
            .environmentObject(vitalvm)
            .environmentObject(dietViewModel)
            .environmentObject(uploadReportViewModel)     
            .environmentObject(allergiesViewModel)
            .environmentObject(editProfileVM)
            .environmentObject(chatViewModel)
            .environmentObject(signUpViewModal)
            .environmentObject(localizer)
            .environmentObject(popupManager)
            
//            .environmentObject(webSocketManager)
        }
    }

    /// Request permission for push notifications
    private func requestPushNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("🚨 Push notification permission denied: \(error?.localizedDescription ?? "No error")")
            }
        }
    }
}

// MARK: - AppDelegate for Push Notifications & Firebase Messaging
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set Firebase Messaging delegate
        Messaging.messaging().delegate = self
        
        // Set UNUserNotificationCenter delegate
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // ✅ Get APNs Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("📲 APNs Device Token: \(tokenString)")
        // ✅ IMPORTANT: tell Firebase Messaging about your APNs token
         Messaging.messaging().apnsToken = deviceToken
    }

    // ❌ Failed to Register
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🚨 Failed to register: \(error.localizedDescription)")
    }

    // ✅ Get FCM Token (if using Firebase)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }

        UserDefaultsManager.shared.set(token, forKey: "fcmToken")
        let fcmToken = UserDefaultsManager.shared.get(forKey: "fcmToken") ?? "notoken"

        print("🔥 FCM Token: \(token)")
        print("🔥 FCM Token: \(fcmToken)")
        
    }

}

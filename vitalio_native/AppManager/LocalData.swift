//
//  LocalData.swift
//  Vitalio
//
//  Created by HID-18 on 12/03/25.
//

import Foundation

final class UserDefaultsManager {
    
    // ✅ Singleton Instance
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {} // Prevent direct initialization
    
    func set<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func get<T>(forKey key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    func clearAll() {
        defaults.dictionaryRepresentation().keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    // ✅ Store FCM Token
    func setFCMToken(_ token: String) {
        set(token, forKey: "FCMToken")
    }
    
    // ✅ Retrieve FCM Token
    func getFCMToken() -> String? {
        return get(forKey: "FCMToken")
    }
    
    func saveIsLoggedIn(loggedIn: Bool){
        set(loggedIn, forKey: "loggedIn")
    }
    
    func getIsLoggedIn() -> Bool? {
        return get(forKey: "loggedIn")
    }
    
    // MARK: - User ID
       func saveUserID(_ userID: String) {
           set(userID, forKey: "UserID")
       }

       func getUserID() -> String? {
           return get(forKey: "UserID")
       }

       // MARK: - UHID
       func saveUHID(_ uhid: String) {
           set(uhid, forKey: "UHID")
       }

       func getUHID() -> String? {
           return get(forKey: "UHID")
       }
    private let key = "userData"
     
          func saveUserData(_ patient: PatientModel) {
              if let encoded = try? JSONEncoder().encode(patient) {
                  UserDefaults.standard.set(encoded, forKey: key)
              }
          }
     
          func getUserData() -> PatientModel? {
              if let data = UserDefaults.standard.data(forKey: key),
                 let decoded = try? JSONDecoder().decode(PatientModel.self, from: data) {
                  return decoded
              }
              return nil
          }
    
}

struct PatientModel: Codable {
    let id: String
    let patientName: String
    let emailID: String
    let genderId: String
    let bloodGroupId: String
    let height: String
    let weight: String
    let dob: String
    let zip: String
    let ageUnitId: String
    let age: String
    let address: String
    let mobileNo: String
    let countryId: String
    let stateId: String
    let cityId: String
    let userId: String
    let uhID: String?
    let profileUrl: String?
}

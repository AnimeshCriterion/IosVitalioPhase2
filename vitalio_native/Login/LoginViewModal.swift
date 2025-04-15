//
//  LoginViewModal.swift
//  vitalio_native
//
//  Created by HID-18 on 01/04/25.
//

import Foundation


class LoginViewModal : ObservableObject {
    
    
    
    
    

    
    
    @Published var uhidNumber: String = "" // Moved UHID to ViewModel
    @Published var isOTPSuccess: Bool = false  // ✅ Track OTP status
    @Published var isLoggedIn: Bool = false  // ✅ user Logged In
    @Published var apiState: APIState = .idle  // Track API state
    
    
    func loadData( uhid: String) async {
        print("step 1")
            do {
                let params = ["mobileNo": "", "uhid": uhid]
                let result = try await APIService.shared.fetchRawData(fromURL: baseURL+getPatientDetailsByMobileNo, parameters: params)
                print("api data", result)
                // result is already [String: Any]
                guard let responseArray = result["responseValue"] as? [Any],
                      let patientData = responseArray.first as? [String: Any] else {
                    print("Failed to parse response")
                    return
                }

                let id = patientData["id"] as? String ?? ""
                let extractedUHID = patientData["uhID"] as? String ?? ""

                print("Extracted id: \(id), UHID: \(extractedUHID)")
                UserDefaultsManager.shared.saveUHID(extractedUHID)
                UserDefaultsManager.shared.saveUserID(id)
            } catch {
                print("Error:", error)
            }
    }
    
    
    //18021
    func login(uhid: String) async {
        DispatchQueue.main.async {
                   self.apiState = .loading  // ✅ Show loading state
               }
            print("🔄 Attempting login with UHID: \(uhid)") // Debugging to verify correctness
            
            guard !uhid.isEmpty else {
                print("⚠️ UHID is empty!")
                return
            }
            
            do {
                let params = ["ifLoggedOutFromAllDevices": "1", "UHID": uhid] // Pass entered UHID
                let response = try await APIService.shared.fetchRawData(fromURL: baseURL + sentLogInOTPForSHFCApp, parameters: params)
                
                print("✅ Success:", response)
                DispatchQueue.main.async {
                                 self.apiState = .success
                             }
            } catch {
                DispatchQueue.main.async {
                                   self.apiState = .failure("Invalid OTP")  // ❌ API Error
                               }
                print("❌ Error:", error)
            }
        }
    
    
    func verifyOTP(otp: String, uhid: String) async {
        DispatchQueue.main.async {
                   self.apiState = .loading  //  Show loading state
               }
        do {
            let params = ["otp" : otp,
                          "UHID" : uhidNumber,
                          "deviceToken" : "eafdasgfsdgfsdgsdfgfd",
                          "ifLoggedOutFromAllDevices" :  "0"]
            let response = try await APIService.shared.fetchRawData(fromURL: baseURL+verifyLogInOTPForSHFCApp, parameters: params)
            print("✅ Success:", response)
            await loadData(uhid: uhid)
            DispatchQueue.main.async {
                             self.apiState = .success
                UserDefaultsManager.shared.saveIsLoggedIn(loggedIn: true)
                         }
        } catch {
            DispatchQueue.main.async {
                               self.apiState = .failure("Invalid OTP")  // ❌ API Error
                           }
            print("❌ Error:", error)
        }
    }
}



enum APIState {
    case idle
    case loading
    case success
    case failure(String)
}

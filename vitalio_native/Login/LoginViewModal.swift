//
//  LoginViewModal.swift
//  vitalio_native
//
//  Created by HID-18 on 01/04/25.
//

import Foundation


class LoginViewModal : ObservableObject {
    
    
    
    
    

    var route: Routing?

        func navigateToDashboard() {
            route?.navigate(to: .dashboard)
        }
    
    @Published var uhidNumber: String = "" // Moved UHID to ViewModel
    @Published var extractedMobileNumber: String = "" // Moved UHID to ViewModel
    @Published var isOTPSuccess: Bool = false  // ✅ Track OTP status
    @Published var isLoggedIn: Bool = false  // ✅ user Logged In
    @Published var apiState: APIState = .idle  // Track API state
    @Published var isOTPInvalid: Bool = false
    @Published var tempPatientModel: PatientModel?
//
//    func loadData( uhid: String) async {
//            do {
//                
//                let params = ["mobileNo": "", "uhid": uhid]
//                let result = try await APIService.shared.fetchRawData(fromURL: baseURL7082+getPatientDetailsByMobileNo, parameters: params)
//                print("api data", result)
//                // result is already [String: Any]
//                guard let responseArray = result["responseValue"] as? [Any],
//                      let patientData = responseArray.first as? [String: Any] else {
//                    print("Failed to parse response")
//                    return
//                }
//                print(patientData)
//                let id = patientData["id"] as? String ?? ""
//                let extractedUHID = patientData["uhID"] as? String ?? ""
//                 extractedMobileNumber = patientData["mobileNo"] as? String ?? ""
//                // ✅ Convert to JSON data
//                            let jsonData = try JSONSerialization.data(withJSONObject: patientData)
//                // ✅ Decode into PatientModel12
//                            let patientModel = try JSONDecoder().decode(PatientModel.self, from: jsonData)
//                // ✅ Save to UserDefaults
//                
//                      UserDefaultsManager.shared.saveUserData(patientModel)
//                var  data = UserDefaultsManager.shared.getUserData()
//                print("Extracted id: \(id), UHID: \(extractedUHID)")
//                UserDefaultsManager.shared.saveUHID(extractedUHID)
//                UserDefaultsManager.shared.saveUserID(id)
//            } catch {
//                print("Error:", error)
//            }
//    }
    
    func loadData(uhid: String) async -> PatientModel? {
        print("step 1")
        let isNumericOnly = uhid.allSatisfy { $0.isNumber }

        do {
            let params = isNumericOnly ? [
                "mobileNo": uhid,
                "uhid": "",
                "clientId": clientID
            ] : [
                "mobileNo": "",
                "uhid": uhid,
                "clientId": clientID
            ]

            print("params \(params)")

            let result = try await APIService.shared.fetchRawData(
                fromURL: baseURL7082 + getPatientDetailsByMobileNo,
                parameters: params
            )

            print("api data", result)

            guard
                let responseArray = result["responseValue"] as? [Any],
                let patientData = responseArray.first as? [String: Any]
            else {
                print("Failed to parse responseValue")
                return nil
            }

            let jsonData = try JSONSerialization.data(withJSONObject: patientData)
            let patientModel = try JSONDecoder().decode(PatientModel.self, from: jsonData)

            print("\(patientModel.profileUrl) from api")

            // Don't save to UserDefaults here anymore
            return patientModel

        } catch {
            print("Error:", error)
            return nil
        }
    }


   
    
    func checkIdentifierType(_ input: String) -> String {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedInput.lowercased().contains("uhid") {
            return "UHID"
        } else if isValidMobileNumber(trimmedInput) {
            return "Mobile"
        } else {
            return "Unknown"
        }
    }

    func isValidMobileNumber(_ input: String) -> Bool {
        let mobileRegex = "^[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return predicate.evaluate(with: input)
    }
    @Published var isRegistered: Bool = true
    
    var isButtonDisabled: Bool {
        let uhid = uhidNumber.trimmingCharacters(in: .whitespaces)
        
        // ✅ Enable if it starts with "uhid" (case-insensitive)
        if uhid.lowercased().hasPrefix("uhid") {
            return false
        }

        // ✅ Enable if numeric-only and length >= 10
        let isNumericOnly = uhid.allSatisfy { $0.isNumber }
        if isNumericOnly && uhid.count >= 10 {
            return false
        }

        // ❌ All other cases: disabled
        return true
    }
    
    //18021
    func login(uhid: String, isLoggedIn : String) async {
        
        print("🔄 Attempting login with UHID: \(uhid)") // Debugging to verify correctness
        
        DispatchQueue.main.async {
                   self.apiState = .loading
       
               }
        
        let result = await loadData(uhid: uhid)
        if let model = result {
            print("✅ API Call Success")
            tempPatientModel = model  // Save it temporarily
            // Proceed to show OTP screen
        } else {
            print("❌ API Call Failed")
        }
        print("modelling \(tempPatientModel)")

        var params = ["" : ""]
        if    (checkIdentifierType(uhid) == "UHID" ){
            
            params = ["ifLoggedOutFromAllDevices": isLoggedIn, "UHID": uhid]
            
        }  else if (checkIdentifierType(uhid) == "Mobile" ){
            
            params = ["ifLoggedOutFromAllDevices": isLoggedIn, "UHID": uhid]
            
            /*   params = ["ifLoggedOutFromAllDevices": isLoggedIn, "mobileNo": uhid, "UHID": ""]*/
            
        }
    
        guard !uhid.isEmpty else {
            print("⚠️ UHID is empty!")
            return
        }
 
   
            
  
            
            do {

                let response = try await APIService.shared.fetchRawData(fromURL: baseURL7082 + sentLogInOTPForSHFCApp, parameters: params)
                
                print("✅ Success:", response)
                if let isRegistered = response["isRegisterd"] as? Int, isRegistered == 0 {
                    print("🔒 User is not registered.")
                    DispatchQueue.main.async{
                        self.isRegistered = false
                    }
                } else {
                    print("✅ User is registered.")
                    DispatchQueue.main.async{
                        self.isRegistered = true
                        
                    }
                }

                DispatchQueue.main.async {
                                 self.apiState = .success
                             }
            } catch {
                DispatchQueue.main.async {
                                 
                self.apiState = .failure("error")
                self.isLoggedIn = true
                               }
                print("❌ Error:", error)
            }
        }
    @Published var showToast: Bool = false
    
    func verifyOTP(otp: String, uhid: String) async {
        let fcmToken =  UserDefaultsManager.shared.get(forKey: "fcmToken") ?? "notoken"

        DispatchQueue.main.async {
                   self.apiState = .loading  //  Show loading state
            self.showToast = false;
               }
        do {
            let params = ["otp" : otp,
                          "UHID" : uhidNumber,
                          "deviceToken" : fcmToken,
                          "ifLoggedOutFromAllDevices" :  "0"]
            let response = try await APIService.shared.fetchRawData(fromURL: baseURL7082+verifyLogInOTPForSHFCApp, parameters: params)
            print("✅  Success:", response)
            
                if let model = tempPatientModel {
                    print("modalwa \(model)")
                    UserDefaultsManager.shared.saveUserData(model)
                    UserDefaultsManager.shared.saveIsLoggedIn(loggedIn: true)
                    
                    let id = String(model.userId)
                    let extractedUHID = model.uhID ?? ""
                    
                    UserDefaultsManager.shared.saveUHID(extractedUHID)
                    UserDefaultsManager.shared.saveUserID(id)
                

                // Navigate to dashboard
//                navigateToDashboard()
            }

//            await loadData(uhid: uhid)
             
            DispatchQueue.main.async {
                            self.apiState = .success
//                                            UserDefaultsManager.shared.saveIsLoggedIn(loggedIn: true)
                            
                            if let responseArray = response["responseValue"] as? [[String: Any]] {
                                do {
                                    let firstItem = try JSONSerialization.data(withJSONObject: responseArray[0])
                                    let patient = try JSONDecoder().decode(PatientModel.self, from: firstItem)
                                    print("FaheemCheck ✅ Decoded patient: \(patient)")
                                    UserDefaultsManager.shared.saveUserData(patient)
                                    
                                    if let savedPatient = UserDefaultsManager.shared.getUserData() {
                                        print("FaheemCheck2 ✅ Retrieved from UserDefaults: \(savedPatient)")
                                    } else {
                                        print("❌ Failed to retrieve saved user data")
                                    }
                                } catch {
                                    print("❌ JSON decoding error: \(error)")
                                }
                            }
                        }
             
        } catch {
            DispatchQueue.main.async {
                    self.apiState = .failure("Invalid OTP")
                    self.showToast = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showToast = false
                }
                print("❌ Error:", error)
        }
    }
    
    func logOut(uhid: String) async {
        let fcmToken = UserDefaultsManager.shared.get(forKey: "fcmToken") ?? "notoken"

        
        do{
            let params = [
                          "UHID" : uhid,
                          "deviceToken" : fcmToken,
                       ]
            let response = try await APIService.shared.fetchRawData(fromURL: baseURL7082+"api/LogInForVitalioApp/LogOutOTPForVitalioApp", parameters: params)
        } catch {
            print("error")
        }
    }
}



enum APIState {
    case idle
    case loading
    case success
    case failure(String)
}


//http://172.16.61.31:5082/api/LogInForVitalioApp/LogOutOTPForVitalioApp?UHID=UHID01235&deviceToken=dulLpKNCK8h5jWigtthtH5:APA91bGN-IfgKuZM6IiNJw1eSqT2EQWNkh80ZEetd4gc3krv30rhpt44ZktMcOyAZ6jIsGWKg3Kuv4kOCU8Wwa7OrHGPYE2c-ECNoo4pj2nnhcHBD_e9I1M


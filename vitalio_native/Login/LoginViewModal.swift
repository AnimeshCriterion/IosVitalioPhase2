//
//  LoginViewModal.swift
//  vitalio_native
//
//  Created by HID-18 on 01/04/25.
//

import Foundation


class LoginViewModal : ObservableObject {
    
    
    
    
    

    
    
    @Published var uhidNumber: String = "" // Moved UHID to ViewModel
    @Published var extractedMobileNumber: String = "" // Moved UHID to ViewModel
    @Published var isOTPSuccess: Bool = false  // ✅ Track OTP status
    @Published var isLoggedIn: Bool = false  // ✅ user Logged In
    @Published var apiState: APIState = .idle  // Track API state
    
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
    
    func loadData(uhid: String) async {
        
          print("step 1")
          do {
              let params = ["mobileNo": "", "uhid": uhid,"clientId" : clientID]
              let result = try await APIService.shared.fetchRawData(
                  fromURL: baseURL7082 + getPatientDetailsByMobileNo,
                  parameters: params
              )
              print("api data", result)
   
              guard let responseArray = result["responseValue"] as? [Any],
                    let patientData = responseArray.first as? [String: Any] else {
                  print("Failed to parse response")
                  return
              }
   
              // ✅ Convert to JSON data
              let jsonData = try JSONSerialization.data(withJSONObject: patientData)
              
              // ✅ Decode into PatientModel
              let patientModel = try JSONDecoder().decode(PatientModel.self, from: jsonData)
             print("\( patientModel.profileUrl) from api")
              
              // ✅ Save to UserDefaults
              UserDefaultsManager.shared.saveUserData(patientModel)
   
              let id = String(patientModel.userId)
              let extractedUHID = patientModel.uhID ?? ""
              
              
              print("Extracted id: \(id), UHID: \(extractedUHID)")
              
              var  data = UserDefaultsManager.shared.getUserData()
              print(data)
              UserDefaultsManager.shared.saveUHID(extractedUHID)
              UserDefaultsManager.shared.saveUserID(id)
              print((UserDefaultsManager.shared.getUHID() ?? "") + "uhid is being saved")
              print((UserDefaultsManager.shared.getUserData()?.profileUrl ?? "") + "getting updated url from local storage")
          } catch {
              print("Error:", error)
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
    
    
    
    //18021
    func login(uhid: String, isLoggedIn : String) async {
        
        print("🔄 Attempting login with UHID: \(uhid)") // Debugging to verify correctness
        
        DispatchQueue.main.async {
                   self.apiState = .loading
       
               }
        
         await loadData(uhid: uhid)

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
    
    
    func verifyOTP(otp: String, uhid: String) async {
        DispatchQueue.main.async {
                   self.apiState = .loading  //  Show loading state
               }
        do {
            let params = ["otp" : otp,
                          "UHID" : uhidNumber,
                          "deviceToken" : "eafdasgfsdgfsdgsdfgfd",
                          "ifLoggedOutFromAllDevices" :  "0"]
            let response = try await APIService.shared.fetchRawData(fromURL: baseURL7082+verifyLogInOTPForSHFCApp, parameters: params)
            print("✅ Success:", response)
//            await loadData(uhid: uhid)
             
            DispatchQueue.main.async {
                            self.apiState = .success
                                            UserDefaultsManager.shared.saveIsLoggedIn(loggedIn: true)
                            
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
                               self.apiState = .failure("Invalid OTP")  // ❌ API Error
                           }
            print("❌ Error:", error)
        }
    }
    
    func logOut(uhid: String) async {
        
        do{
            let params = [
                          "UHID" : uhid,
                          "deviceToken" : "eafdasgfsdgfsdgsdfgfd",
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


//
//  EditProfileViewModal.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/28/25.
//

import Foundation

class EditProfileViewModal : ObservableObject {
    var userData =  UserDefaultsManager.shared.getUserData()
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dob: Date = Date()
    @Published var gender: String = "Male"
    @Published var weight: String = ""
    @Published var selectedBloodGroup: String = ""
    @Published var height: String = ""
    @Published var emergencyContact: String = ""
    @Published var age: String = ""
    @Published var loadingImage: Bool = false
    
    
//    init() {
////        loadUserData()
////        print(userData?.patientName as? String ?? "")
//    }
//    

     func loadUserData() {
        guard let userData = UserDefaultsManager.shared.getUserData() else {
                print("No user data found")
            print("No user data found\(userData?.dob ?? "")")
            
                return
            }

        firstName = userData.patientName
        age = userData.age
        emergencyContact = userData.mobileNo
        if userData.genderId == "1" {
            gender = "Male"
        }else{
            gender = "Female"
        }
        weight = userData.weight
        height = userData.height
        selectedBloodGroupID = userData.bloodGroupId
         print("\(userData.dob) getting dob") // prints "01-03-1998 00:00:00 getting dob"

         if let parsedDate = parseDate(userData.dob) {
             dob = parsedDate // Assign parsed Date to dob
             print("\(dob) Now dob") // Prints real Date object, e.g. 1998-03-01 00:00:00 +0000
         } else {
             print("Failed to parse date")
         }

         let outputFormatter = DateFormatter()
         outputFormatter.dateFormat = "yyyy-MM-dd"

         print(outputFormatter.string(from: dob))  // Now prints "1998-03-01"


         
        

    }
    
    func formatDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter.string(from: date)
       }

//    @Published var dob: Date = Date()
    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: string)
    }


    func updateDOB(from originalString: String) {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = inputFormatter.date(from: originalString) {
            dob = date  // Assign the Date object to dob
            print("Date saved:", dob)  // This prints the Date object
        } else {
            print("Invalid date string")
        }
    }




       private func calculateAge(from dob: Date) -> String {
           let calendar = Calendar.current
           let ageComponents = calendar.dateComponents([.year], from: dob, to: Date())
           return "\(ageComponents.year ?? 0)"
       }

    @Published var updateProfile: Bool = false
    
    
    
    func updateSuccess() {
        updateProfile = true

           // Auto-dismiss after 2 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.updateProfile = false
           }
       }
    
    func updateProfileData() async throws {
        print("Dateofbirth: \(formatDate(dob))")
        guard let url = URL(string: baseURL7082 + "api/PatientRegistration/UpdatePatientProfile") else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "Pid": UserDefaultsManager.shared.getUserData()?.pid ?? 8,
            "PatientName": firstName,
            "EmailID":  UserDefaultsManager.shared.getUserData()?.emailID ?? "",
            "GenderId":  UserDefaultsManager.shared.getUserData()?.genderId ?? "",
            "BloodGroupId": String(selectedBloodGroupID!),
            "Height": height,
            "Weight": weight,
            "Dob": formatDate(dob),
            "Zip":  UserDefaultsManager.shared.getUserData()?.zip ?? "",
            "AgeUnitId":  UserDefaultsManager.shared.getUserData()?.ageUnitId ?? "",
            "Age":  UserDefaultsManager.shared.getUserData()?.age ?? "",
            "Address":  UserDefaultsManager.shared.getUserData()?.address ?? "",
            "MobileNo": emergencyContact,
            "CountryId":  UserDefaultsManager.shared.getUserData()?.countryId ?? "",
            "StateId":  UserDefaultsManager.shared.getUserData()?.stateId ?? "",
            "CityId":  UserDefaultsManager.shared.getUserData()?.cityId  ?? "",
            "UserId":  UserDefaultsManager.shared.getUserData()?.userId ?? ""
        ]

        let bodyString = parameters.map { "\($0.key)=\($0.value)" }
                                   .joined(separator: "&")
        print("Body: \(bodyString)")
        request.httpBody = bodyString.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("❌ Server returned status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            showGlobalError(message: "Error: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            throw NetworkError.badResponse
        }

        // Print raw response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🧾 Raw API response: \(jsonString)")
            
        }
        updateSuccess()
        // Decode and save to UserDefaults
        guard let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let responseArray = result["responseValue"] as? [[String: Any]],
              let firstItem = try? JSONSerialization.data(withJSONObject: responseArray[0]),
              let updatedPatient = try? JSONDecoder().decode(PatientModel.self, from: firstItem) else {
            print("❌ Failed to decode or save updated patient data.")
            return
        }

        UserDefaultsManager.shared.saveUserData(updatedPatient)
      
        print("✅ Profile updated and saved to local storage:", updatedPatient)
    }
    
    func updateProfileDataForP(imageData: Data, filename: String) async {
        print("sending to api \(filename)")
        print("sending to api \(imageData.count) bytes imageData")
        
        // Force unwrap userData — be sure it exists or this will crash
        let userData = UserDefaultsManager.shared.getUserData()!
        
        let parameters = [
            ["key": "Pid", "value": userData.pid , "type": "text"],
            ["key": "PatientName", "value": "\(userData.patientName )", "type": "text"],
            ["key": "EmailID", "value": userData.emailID , "type": "text"],
            ["key": "GenderId", "value": "\(userData.genderId )", "type": "text"],
            ["key": "BloodGroupId", "value": userData.bloodGroupId , "type": "text"],
            ["key": "Height", "value": "\(userData.height )", "type": "text"],
            ["key": "Weight", "value": "\(userData.weight )", "type": "text"],
            ["key": "Dob", "value": "\(userData.dob.toDateFormat("yyyy-MM-dd"))", "type": "text"],
            ["key": "Zip", "value": userData.zip , "type": "text"],
            ["key": "AgeUnitId", "value": userData.ageUnitId , "type": "text"],
            ["key": "Age", "value": userData.age , "type": "text"],
            ["key": "Address", "value": userData.address , "type": "text"],
            ["key": "MobileNo", "value": "\(userData.mobileNo )", "type": "text"],
            ["key": "CountryId", "value": userData.countryId , "type": "text"],
            ["key": "StateId", "value": userData.stateId , "type": "text"],
            ["key": "CityId", "value": userData.cityId , "type": "text"],
            ["key": "UserId", "value": userData.userId , "type": "text"],
            ["key": "FamilyDiseaseJson", "value": "\"\"", "type": "text"],
            ["key": "ChoronicDiseasesJson", "value": "\"\"", "type": "text"],
            ["key": "FormFile", "src": "\(filename)", "type": "file"]
        ] as [[String: Any]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        
        print(parameters)
        
        for param in parameters {
            guard let paramName = param["key"] as? String else { continue }
            body += Data("--\(boundary)\r\n".utf8)
            
            guard let paramType = param["type"] as? String else { continue }
            
            if paramType == "text" {
                guard let paramValue = param["value"] as? String else { continue }
                body += Data("Content-Disposition: form-data; name=\"\(paramName)\"\r\n\r\n".utf8)
                body += Data("\(paramValue)\r\n".utf8)
            } else if paramType == "file" {
                guard let paramSrc = param["src"] as? String else { continue }
                let fileURL = URL(fileURLWithPath: paramSrc)
                let fileData = try? Data(contentsOf: fileURL)
                
                if let fileData = fileData {
                    body += Data("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".utf8)
                    body += Data("Content-Type: application/octet-stream\r\n\r\n".utf8)
                    body += fileData
                    body += Data("\r\n".utf8)
                } else {
                    print("Error reading file data for \(paramSrc)")
                }
            }
        }
        
        body += Data("--\(boundary)--\r\n".utf8)
        
        var request = URLRequest(url: URL(string: baseURL7082 + "api/PatientRegistration/UpdatePatientProfile")!, timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                showGlobalError(message: String(describing: error))
                return
            }
            print("Response: " + (String(data: data, encoding: .utf8) ?? "No response string"))
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let status = json?["status"] as? Int, status == 1 {
                    print("✅ Success")
                } else {
                    let message = json?["message"] as? String ?? "Unknown error"
                    let responseValue = json?["responseValue"] as? String ?? "No details"
                    let errorCode = json?["errorCode"] as? String ?? "No error code"
                    
                    print("❌ Failed - Message: \(message)")
                    print("Response Value: \(responseValue)")
                    print("Error Code: \(errorCode)")
                    showGlobalError(message: "Error: \(errorCode), \(responseValue)")
                }
            } catch {
                showGlobalError(message: "❌ JSON parsing error: \(error.localizedDescription)")
                print("❌ JSON parsing error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }



//    func updateProfileDataForP(imageData: Data, filename: String) async  {
//        
//       
//        
//        
//        
//        
//        print("sending to api \(filename)")
//        print("sending to api \(imageData)  imageData")
//        
//        
//        let parameters = [
//            ["key": "Pid", "value":  UserDefaultsManager.shared.getUserData()?.pid ?? 8, "type": "text"],
//            ["key": "PatientName", "value": "\( UserDefaultsManager.shared.getUserData()?.patientName ?? "" )", "type": "text"],
//            ["key": "EmailID", "value":  UserDefaultsManager.shared.getUserData()?.emailID  ?? "" , "type": "text"],
//            ["key": "GenderId", "value": "\( UserDefaultsManager.shared.getUserData()?.genderId ?? "" )", "type": "text"],
//            ["key": "BloodGroupId", "value":  UserDefaultsManager.shared.getUserData()?.bloodGroupId ?? "" , "type": "text"],
//            ["key": "Height", "value": "\( UserDefaultsManager.shared.getUserData()?.height ?? "" )", "type": "text"],
//            ["key": "Weight", "value": "\( UserDefaultsManager.shared.getUserData()?.weight ?? "" )", "type": "text"],
//            ["key": "Dob", "value": "\(UserDefaultsManager.shared.getUserData()?.dob ?? "" )", "type": "text"],
//            ["key": "Zip", "value":  UserDefaultsManager.shared.getUserData()?.zip ?? "" , "type": "text"],
//            ["key": "AgeUnitId", "value":  UserDefaultsManager.shared.getUserData()?.ageUnitId ?? "" , "type": "text"],
//            ["key": "Age", "value":  UserDefaultsManager.shared.getUserData()?.age ?? "" , "type": "text"],
//            ["key": "Address", "value":  UserDefaultsManager.shared.getUserData()?.address ?? "" , "type": "text"],
//            ["key": "MobileNo", "value": "\( UserDefaultsManager.shared.getUserData()?.mobileNo ?? "" )", "type": "text"],
//            ["key": "CountryId", "value":  UserDefaultsManager.shared.getUserData()?.countryId ?? "" , "type": "text"],
//            ["key": "StateId", "value":  UserDefaultsManager.shared.getUserData()?.stateId ?? "" , "type": "text"],
//            ["key": "CityId", "value":  UserDefaultsManager.shared.getUserData()?.cityId ?? "" , "type": "text"],
//            ["key": "UserId", "value":  UserDefaultsManager.shared.getUserData()?.userId ?? "" , "type": "text"],
////            ["key": "FamilyDiseaseJson", "value": "\"\"", "type": "text"],
////            ["key": "ChoronicDiseasesJson", "value": "\"\"", "type": "text"],
//            ["key": "FormFile", "src": "\(filename)", "type": "file"]
//        ] as [[String: Any]]
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        var body = Data()
//        var error: Error? = nil
//        
//        print(parameters)
//
//        for param in parameters {
//            guard let paramName = param["key"] as? String else { continue }
//            body += Data("--\(boundary)\r\n".utf8)
//
//            guard let paramType = param["type"] as? String else { continue }
//
//            if paramType == "text" {
//                guard let paramValue = param["value"] as? String else { continue }
//                body += Data("Content-Disposition: form-data; name=\"\(paramName)\"\r\n\r\n".utf8)
//                body += Data("\(paramValue)\r\n".utf8)
//            } else if paramType == "file" {
//                guard let paramSrc = param["src"] as? String else { continue }
//                let fileURL = URL(fileURLWithPath: paramSrc)
//                let fileData = try? Data(contentsOf: fileURL)
//
//                if let fileData = fileData {
//                    body += Data("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".utf8)
//                    body += Data("Content-Type: application/octet-stream\r\n\r\n".utf8)
//                    body += fileData
//                    body += Data("\r\n".utf8)
//                }
//            }
//        }
//
//
//        body += Data("--\(boundary)--\r\n".utf8)
//        let postData = body
//
//        var request = URLRequest(url: URL(string: baseURL7082 + "api/PatientRegistration/UpdatePatientProfile")!, timeoutInterval: Double.infinity)
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "PUT"
//        request.httpBody = postData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print(String(describing: error))
//                showGlobalError(message: String(describing: error))
//                return
//            }
//            print("Response" + String(data: data, encoding: .utf8)!)
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//
//                if let status = json?["status"] as? Int, status == 1 {
//                    print("✅ Success")
//
//                } else {
//                    let message = json?["message"] as? String ?? "Unknown error"
//                    let responseValue = json?["responseValue"] as? String ?? "No details"
//                    let errorCode = json?["errorCode"] as? String ?? "No error code"
//
//                    print("❌ Failed - Message: \(message)")
//                    print("Response Value: \(responseValue)")
//                    print("Error Code: \(errorCode)")
//                    showGlobalError(message: "Error: \(errorCode), \(responseValue)")
//                }
//            } catch {
//                showGlobalError(message: "❌ JSON parsing error: \(error.localizedDescription)")
//                print("❌ JSON parsing error: \(error.localizedDescription)")
//            }
//
//        }
//
//        task.resume()
//    }

 

    
    
    
    func calculateAge(from dateString: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let birthDate = formatter.date(from: dateString) else {
            return nil
        }
        
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year
    }
    
    
    func calculateAgeString(from dateString: String) -> String {
        if let age = calculateAge(from: dateString) {
            return String(age)
        } else {
            return "Invalid date"
        }
    }
    
    struct BloodGroup: Identifiable, Codable, Hashable, CustomStringConvertible {
        let id: String
        let groupName: String

        var description: String {
            groupName
        }
    }
    
    let bloodGroups: [BloodGroup] = [
        BloodGroup(id: "1", groupName: "A+"),
        BloodGroup(id: "2", groupName: "A-"),
        BloodGroup(id: "3", groupName: "B+"),
        BloodGroup(id: "4", groupName: "B-"),
        BloodGroup(id: "5", groupName: "O+"),
        BloodGroup(id: "6", groupName: "O-"),
        BloodGroup(id: "7", groupName: "AB+"),
        BloodGroup(id: "8", groupName: "AB-")
    ]
    
    @Published var selectedBlood: BloodGroup? = nil
    @Published var selectedBloodGroupID: String? = nil
    
//    func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.timeZone = TimeZone(abbreviation: "UTC") // Optional: ensures consistency
//        return formatter.string(from: date)
//    }

}

extension String {
    func toDateFormat(_ format: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = self.contains(":") ? "dd-MM-yyyy HH:mm:ss" : "dd-MM-yyyy"
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return self // fallback to original string if parsing fails
    }
}

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
    
    
//    init() {
////        loadUserData()
////        print(userData?.patientName as? String ?? "")
//    }
//    

     func loadUserData() {
        guard let userData = UserDefaultsManager.shared.getUserData() else {
                print("No user data found")
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
        
        if let parsedDate = parseDate(userData.dob) {
                    dob = parsedDate
                }
        

    }
    
    func formatDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter.string(from: date)
       }

       private func parseDate(_ string: String) -> Date? {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter.date(from: string)
       }

       private func calculateAge(from dob: Date) -> String {
           let calendar = Calendar.current
           let ageComponents = calendar.dateComponents([.year], from: dob, to: Date())
           return "\(ageComponents.year ?? 0)"
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
            "Pid": 8,
            "PatientName": firstName,
            "EmailID": "yasirkhan2910@hotmail.com",
            "GenderId": gender == "Male" ? 1 : 2,
            "BloodGroupId": String(selectedBloodGroupID!),
            "Height": height,
            "Weight": weight,
            "Dob": formatDate(dob),
            "Zip": 226026,
            "AgeUnitId": 1,
            "Age": 25,
            "Address": "LKO",
            "MobileNo": emergencyContact,
            "CountryId": 101,
            "StateId": 38,
            "CityId": 25,
            "UserId": 1209
        ]

        let bodyString = parameters.map { "\($0.key)=\($0.value)" }
                                   .joined(separator: "&")
        print("Body: \(bodyString)")
        request.httpBody = bodyString.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("❌ Server returned status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            throw NetworkError.badResponse
        }

        // Print raw response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🧾 Raw API response: \(jsonString)")
        }
  
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

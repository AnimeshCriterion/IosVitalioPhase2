//
//  SignUpViewModel.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/19/25.
//

import Foundation
import SwiftUI


struct Gender: Identifiable, Hashable{
    let id = UUID()
    let name: String
    let value: String
    let image: String
    let gederId: Int
}

class SignUpViewModal: ObservableObject {
    
    init() {
        updateFormattedDate(with: selectedDate)
        loadCountries()
    }

    func updateFormattedDate(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formattedDate = formatter.string(from: date)
    }
    
    @Published var currentPage = 0
    @Published  var firstName: String = ""
    @Published  var lastNmae: String = ""
    @Published  var familyDisease: String = ""

    func getCurrentDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: Date())
    }

    @Published var genders: [Gender] = [
        Gender(name: "Male", value: "male", image: "male", gederId: 1),
        Gender(name: "Female", value: "female", image: "female", gederId: 2),
        Gender(name: "Other", value: "other", image: "other", gederId: 3)
    ]
    
    
    
    func getSelectedGenderId(selectedGender: Gender) -> Int {
        switch selectedGender.value.lowercased() {
        case "male": return 1
        case "female": return 2
        case "other": return 3
        default: return 0
        }
    }

    @Published  var selectedGender: String? = nil
    @Published  var selectedGenderId: Int? = nil
    
    
    @Published  var selectedDate = Date()
    @Published  var formattedDate = ""
    var isDateToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
    
    
    struct Vital: Identifiable {
        let id = UUID()
        let name: String
        let value: String
        let unit: String
    }
    
    @Published var selectedBloodGroup: String? = nil
    @Published var selectedBloodGroupId: String? = nil
        
        let bloodGroups: [Vital] = [
            Vital(name: "A+", value: "99/70", unit: "1"),
            Vital(name: "A-", value: "18", unit: "2"),
            Vital(name: "B+", value: "98.6", unit: "3"),
            Vital(name: "B-", value: "60", unit: "4"),
            Vital(name: "AB+", value: "98.4", unit: "9"),
            Vital(name: "AB-", value: "170", unit: "5"),
            Vital(name: "O+", value: "170", unit: "8"),
            Vital(name: "O-", value: "170", unit: "6"),
        ]
        
        let bloodGridColumns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    
    
    @Published var streetAddress: String = ""
    @Published var zipCode: String = ""
//    @Published var selectedCity: String = ""
    
    
    /// countru dropdownData start
    
    @Published var showCountryDropdown = false
    struct Country: Codable, Identifiable, CustomStringConvertible {
        let id: Int
        let countryName: String
        let status: Bool
        let userId: Int
        let countryCode: String

        var description: String { countryName } // for display in dropdown
    }
    @Published var selectedCountry: Country? = nil
    @Published var selectedCountryID: Int? = nil
    @Published var countries: [Country] = []
    var countryOptions: [String] {
        countries.map { $0.countryName }
    }

    
    func loadCountries() {
            guard let url = Bundle.main.url(forResource: "country_json", withExtension: "json") else {
                print("❌ countries.json not found")
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode([Country].self, from: data)
                countries = decoded
            } catch {
                print("❌ Failed to decode JSON:", error)
            }
        }
    func selectCountry(_ country: Country) {
            selectedCountry = country
            selectedCountryID = country.id
            print("Selected country ID: \(country.id)")
        }
    
    /// countruydropdownData End
    
    
    /// state dropdown start
    
    @Published var states: [State] = []
    @Published var selectedStateID: Int? = nil
    @Published var selectedState: State? = nil
    
    func StateData(_ countryID: Int) async {
        do {
            let result = try await APIService.shared.fetchRawData(
                fromURL: "https://api.medvantage.tech:7083/api/StateMaster/GetStateMasterByCountryId",
                parameters: ["id": String(countryID)]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decodedResponse = try JSONDecoder().decode(StateResponse.self, from: jsonData)
                    DispatchQueue.main.async {
                        self.states = decodedResponse.responseValue
                    }

            
            print("Fetching Data:",jsonData);

        } catch {
            print("❌ Error Fetching Vitals:", error)
        }
    }
    
    
    struct StateResponse: Codable {
        let status: Int
        let message: String
        let responseValue: [State]
    }

    struct State: Codable, Identifiable, CustomStringConvertible {
        let id: Int
        let countryId: Int
        let stateName: String
        let status: Bool
        let userId: Int
        let countryName: String

        
        var description: String { stateName }
    }
    
    /// state dropdown end
   
    
    
    /// city dropdown start

    @Published var citys: [City] = []
    @Published var selectedCityID: Int? = nil
    @Published var selectedCity: City? = nil
   
    func CityData(_ stateId: Int) async {
        do {
            let result = try await APIService.shared.fetchRawData(
                fromURL: "https://api.medvantage.tech:7083/api/CityMaster/GetCityMasterByStateId",
                parameters: ["id": String(stateId)]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decodedResponse = try JSONDecoder().decode(CityResponse.self, from: jsonData)
            await MainActor.run {
                self.citys = decodedResponse.responseValue
            }

            
            print("Fetching Data:",jsonData);

        } catch {
            print("❌ Error Fetching Vitals:", error)
        }
    }
    
    struct CityResponse: Codable {
        let status: Int
        let message: String
        let responseValue: [City]
    }

    struct City: Codable, Identifiable, CustomStringConvertible {
        let id: Int
        let name: String
        let stateId: Int
        let stateName: String
        let status: Bool
        let userId: Int

        var description: String {
            name
        }
    }
    /// city dropdown end
    
    
    
    
    @Published var weight : String = ""
    @Published var selectedUnit = "Kg"
    let unitOptions = ["Kg"]
    
    
    
    @Published var selectedFeet: Int = 5
    @Published var selectedInches: Int = 7
    @Published var selectedHeightUnit: String = "ft" // Only the unit
    @Published var selectedHeightText: String = "0" // Full display text
    @Published var showPopup = false

    let feetRange = Array(3...7)
    let inchesRange = Array(0...11)
    let units = ["in", "ft", "cm"]
    
    
    func convertToCentimeters(from input: String) -> Double? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if trimmed.hasSuffix("cm") {
            return Double(trimmed.replacingOccurrences(of: "cm", with: "").trimmingCharacters(in: .whitespaces))
        } else if trimmed.hasSuffix("in") {
            if let value = Double(trimmed.replacingOccurrences(of: "in", with: "").trimmingCharacters(in: .whitespaces)) {
                return value * 2.54
            }
        } else if trimmed.hasSuffix("ft") {
            if let value = Double(trimmed.replacingOccurrences(of: "ft", with: "").trimmingCharacters(in: .whitespaces)) {
                return value * 30.48
            }
        }
        
        return nil // Unknown or unsupported format
    }

    


    
    
    /// chronic disease
    
       @Published var searchText = ""
       @Published var showCancelButton: Bool = false
       @Published var selectedItems: [Problem] = []
       
       var filteredResults: [Problem] {
           if searchText.isEmpty {
               return []
           } else {
               return arrayData.filter { $0.problemName.lowercased().contains(searchText.lowercased()) }
           }
       }
    @Published var arrayData: [Problem] = []
    
    
    struct ProblemResponse: Codable {
        let status: Int
        let message: String
        let responseValue: [Problem]
    }

    struct Problem: Codable, Identifiable, Hashable, Equatable {
        let id: Int
        let problemName: String
        let problemTypeID: Int
    }
    
    func chronicDisease(_ searchData: String) async {
        do {
            let result = try await APIService.shared.fetchRawData(
                fromURL: "https://api.medvantage.tech:7082/api/KnowMedApis/GetProblemList",
                parameters: [
                    "withICDCode": "true",
                    "alphabet": String(searchData)
                ]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decodedResponse = try JSONDecoder().decode(ProblemResponse.self, from: jsonData)
//            await MainActor.run {
//                        self.arrayData = decodedResponse.responseValue.map { $0.problemName }
//                    }
            await MainActor.run {
                        self.arrayData = decodedResponse.responseValue
                    }

            
            print("Fetching Chronic Data:",jsonData);

        } catch {
            print("❌ Error Fetching Vitals:", error)
        }
    }
    
    
    
       @Published var searchChronicConditionText = ""
       @Published var showCancelButtonChronicCondition: Bool = false
       @Published var selectedChronicConditionItems: [Problem] = []

    
    
       var filteredResultsChronicCondition: [Problem] {
           if searchChronicConditionText.isEmpty {
               return []
           } else {
               return arrayData.filter { $0.problemName.lowercased().contains(searchChronicConditionText.lowercased()) }
           }
       }
    
    
    
    
//    @Published var healthHostory : String = ""
    let healthHistoryList = ["High Blood Pressure (Hypertension)", "Blood Cancer (Leukemia)", "Blood Clots (Deep Vein Thrombosis)", "Blood Disorders (Anemia)", "Thalassemia (Blood Disorder)", "Hemophilia (Blood Clotting Disorder)", "Greg", "Thomas", "Robert", "Bernie", "Mike", "Benno", "Hugo", "Miles", "Michael", "Mikel", "Tim", "Tom", "Lottie", "Lorrie", "Barbara","Faheem","FaheemGeorge"]
    @Published var searchHealthHistoryText = ""
    @Published var showHealthHistoryCancelButton: Bool = false
    var filteredHealthHistoryResults: [String] {
        if searchHealthHistoryText.isEmpty {
            return []
        } else {
            return healthHistoryList.filter { $0.lowercased().contains(searchHealthHistoryText.lowercased()) }
        }
    }
    @Published var selectedHealthHistoryItems: [String] = []
    @Published var showHealthHistoryPopup = false
    @Published var tempSelectedHealthHistoryItems: Set<String> = []
    
    
    
    
    
    
//    struct VitalsReminder: Identifiable{
//            let id = UUID()
//            let name: String
//            let subName: String
//        }
    @Published var vitalsData: [VitalsReminder] = [
        VitalsReminder(name: "Blood Presure", subName: "3 times a day"),
        VitalsReminder(name: "Heart Rate", subName: "3 times a day"),
        VitalsReminder(name: "Blood Oxygen (spo2)", subName: "3 times a day"),
        VitalsReminder(name: "Resparetry Rate", subName: "Every 4 hours"),
        VitalsReminder(name: "RBS", subName: "Daily"),
        VitalsReminder(name: "Body Weight", subName: "Monthly")
        ]
    @Published var showPopupReminder = false
    @Published var selectedSubName: String = "Select Frequency"
    @Published var selectedReminder: VitalsReminder?
    
    
    
    
    @Published var name : String = ""
    @Published var selectedfluidIntakeUnit = "Litre"
    let fludeIntakeUnitOptions = ["Litre", "gram", "mg"]
    
    
    class VitalsReminder: Identifiable, ObservableObject {
        var id = UUID()
        var name: String
        @Published var subName: String
        
        init(name: String, subName: String) {
            self.name = name
            self.subName = subName
        }
    }
    

    
    
    
    @Published var isSavingSuccessful : Bool = false
    func submitPatientDetails(number: String) {
        
        let chronic = escapedJSONString(patientDetailsList)

    
        // 1. Your API URL
        guard let url = URL(string: baseURL7082 + "api/PatientRegistration/PatientSignUp") else {
            print("❌ Invalid URL")
            return
        }

        // 2. Request Payload (Dictionary)
        let jsonPayload: [String: Any] = [
            "patientName": firstName + " " + lastNmae,
            "genderId": selectedGenderId ?? "1",
            "bloodGroupId": selectedBloodGroupId ?? 0,
            "height": selectedHeightText,
            "dob": formattedDate,
            "weight": String(describing: weight),
            "zip": String(describing: zipCode),
            "address": streetAddress,
            "countryCallingCode": "+91",
            "mobileNo": "\(number)",
            "countryId": selectedCountryID ?? 0,
            "stateId": selectedStateID ?? 0,
            "cityId": selectedCityID ?? 0,
            "choronicDiseasesJson": chronic ?? "",
            "familyDiseaseJson": familyDisease == "[]" ? "" : familyDisease ,
//            "reminderJson": "",
            "clientId": "194",
            "isExternal": "1"
        ]
        print(jsonPayload)

        // 3. Convert to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonPayload) else {
            print("❌ Failed to serialize JSON")
            return
        }

        // 4. Prepare URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // 5. Perform Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async{
                    self.showError = true
                    self.errorIs = "❌ Error: \(error.localizedDescription)"
                }
              
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async{
                    self.showError = true
                    self.errorIs = "❌ Invalid response"
                }
                print("❌ Invalid response")
                return
            }

            print("✅ Status Code: \(httpResponse.statusCode)")
            if("\(httpResponse.statusCode)" == "200"){
                self.isSavingSuccessful = true
            }else{
                DispatchQueue.main.async{
                    self.showError = true
                    self.errorIs = "❌ some Error Occured"
                }
                self.isSavingSuccessful = false
            }

            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📦 Response: \(responseString)")
//                    LoginViewModal().loadData(uhid: "")
                }
            }
            
            if let data2 = data {
                do {
                    // Decode JSON
                    if let json = try JSONSerialization.jsonObject(with: data2, options: []) as? [String: Any],
                       let responseArray = json["responseValue"] as? [[String: Any]],
                       let firstItem = responseArray.first,
                       let uhid = firstItem["uhid"] as? String {
                        print("📦 UHID: \(uhid)")
                        Task{
                            let viewModel = LoginViewModal()
                            await viewModel.loadData(uhid: uhid)
                        }
                    }
                } catch {
                    print("❌ JSON parsing error: \(error.localizedDescription)")
                }
            }

        }

        task.resume()
    }
    
    @Published var showError: Bool = false
    @Published var errorIs: String = ""
    
    func intakeError() {
        showError = true

           // Auto-dismiss after 2 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.showError = false
           }
       }
    
    
    @Published var patientDetailsList: [PatientDetail] = []
       
    func addDetail(_ newDetail: PatientDetail) {
          guard !patientDetailsList.contains(where: { $0.detailID == newDetail.detailID }) else {
              return // Already exists, don't add
          }
          patientDetailsList.append(newDetail)
        let escapedBodyString = escapedJSONString(patientDetailsList)
        print(escapedBodyString ?? "")

      }
      
    

    func removeDetail(byID id: String) {
        patientDetailsList.removeAll { $0.detailID == id }
        print(patientDetailsList)
         let escapedBodyString = escapedJSONString(patientDetailsList)
        print(escapedBodyString ?? "")
    }
    


    func escapedJSONString<T: Encodable>(_ list: [T]) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = []
        
        guard let data = try? encoder.encode(list),
              let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        let escaped = jsonString
            .replacingOccurrences(of: "\\", with: "\\\\") // escape backslashes
            .replacingOccurrences(of: "\"", with: "\\\"") // escape quotes
        
        return "\"\(escaped)\"" // wrap in quotes
    }
    
    
    // Final result map
    var resultMap: [String: Any] = [
        "clientId": "194",
        "isExternal": "1"
    ]

    private var currentSelectedDiseases: [String] = []

    // 1️⃣ Store selected disease(s)
    func selectDiseases(_ diseases: [String]) {
        currentSelectedDiseases = diseases
    }

    // 2️⃣ Assign relation
    func assignRelation(_ relation: String) {
        guard !currentSelectedDiseases.isEmpty else { return }

        if var existing = resultMap[relation] as? [String] {
            for disease in currentSelectedDiseases where !existing.contains(disease) {
                existing.append(disease)
            }
            resultMap[relation] = existing
        } else {
            resultMap[relation] = currentSelectedDiseases
        }

        // Clear for next selection
        currentSelectedDiseases.removeAll()
    }

    func printResultMap() {
        var result = "{"
        var entries: [String] = []

        for (key, value) in resultMap {
            if let array = value as? [String] {
                let arrayString = array.map { "\\\"\($0)\\\"" }.joined(separator: ", ")
                entries.append("\\\"\(key)\\\": [\(arrayString)]")
            } else if let string = value as? String {
                entries.append("\\\"\(key)\\\": \\\"\(string)\\\"")
            }
        }

        result += entries.joined(separator: ", ")
        result += "}"
        
        // Wrap the entire result in quotes to form a single escaped string
        let escapedJSONString = "\"\(result)\""
        familyDisease = escapedJSONString
        print(escapedJSONString)
    }


    let progressMessages = [
        "Great start! You’re just beginning—let’s keep going!",
        "You’re gaining momentum—keep moving forward!",
        "Nice work! You’re a quarter of the way there!",
        "Nice work! You’re a third of the way there!",
        "You’re getting closer—just a little more to reach halfway!",
        "You’re getting closer—just a little more to reach halfway!",
        "You’re past halfway—great job so far!",
        "You’re making great progress—just a little more to go!",
        "You've come so far—just a final push!",
        "So close! Only a few steps remain!",
        "You’re just one step away from completing the process."
    ]


    let progressStages = [
        "Getting Started",
        "Moving Forward",
        "Staying on Track",
        "One-Third Complete",
        "Almost There to Halfway",
        "Staying on Track",
        "Moving Ahead",
        "Final Stretch in Sight",
        "Just a Little Further to Go",
        "Final Push Ahead",
        "All Done!"
    ]
    
    
    
    

}

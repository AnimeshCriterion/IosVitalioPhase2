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
enum EditableField: String, Identifiable, CaseIterable {
    case name = "Name"
    case gender = "Gender"
    case dateOfBirth = "Date of Birth"
    case bloodGroup = "Blood Group"
    case address = "Address"
    case weight = "Weight"
    case height = "Height"

    var id: String { rawValue }
}

@MainActor
class SignUpViewModal: ObservableObject {
    
    init() {
        updateFormattedDate(with: selectedDate)
        loadCountries()
    }
    deinit {
           print("SignupViewModel deinitialized")
       }
    func updateFormattedDate(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formattedDate = formatter.string(from: date)
    }
    
    @Published var currentPage = 0
    @Published var lastPage = -1
    @Published  var firstName: String = ""
    @Published  var lastNmae: String = ""
    @Published  var familyDisease: String = ""
    @Published var showFirstNameError: Bool = false

//    @Published  var selectedField: EditableField? = nil
    @Published var selectedProfileField: EditableField? = nil
    func reset() {
        currentPage = 0
        lastPage = -1
        firstName = ""
        lastNmae = ""
        familyDisease = ""
        showFirstNameError = false
            tempPatientModel = nil
        selectedGender = nil
        selectedGenderId = nil
        formattedDate = ""
        streetAddress = ""
        fullAddress = ""
        zipCode = ""
        states = []
        selectedStateID = nil
        selectedState = nil
       isLoading = false
            // Reset additional variables if you add more
        }

    func getCurrentDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: Date())
    }

    @Published var genders: [Gender] = [
        Gender(name: "Male", value: "Male", image: "male", gederId: 1),
        Gender(name: "Female", value: "Female", image: "female", gederId: 2),
        Gender(name: "Other", value: "Other", image: "other", gederId: 3)
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
    @Published var fullAddress: String = ""
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
    @Published var isLoading: Bool = false
    
    func StateData(_ countryID: Int) async {
        do {
            print("stateId: \(countryID)")
                self.isLoading = true
            let result = try await APIService.shared.fetchRawData(
                fromURL: "http://172.16.61.31:5119/api/StateMaster/GetStateMasterByCountryId",
                parameters: ["id": String(countryID),
                             "clientId": "176"]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decodedResponse = try JSONDecoder().decode(StateResponse.self, from: jsonData)
                   
            self.states = decodedResponse.responseValue
            self.isLoading = false
                    

            
            print("Fetching Data:",jsonData);

        } catch {
            self.isLoading = false
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
        print("cityData \(stateId)")
        do {
            self.isLoading = true
            let result = try await APIService.shared.fetchRawData(
                fromURL: "http://172.16.61.31:5119/api/CityMaster/GetCityMasterByStateId",
                parameters: ["id": String(stateId),
                            "clientId": "176"]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decodedResponse = try JSONDecoder().decode(CityResponse.self, from: jsonData)
                self.citys = decodedResponse.responseValue
            self.isLoading = false
            print("Fetching Data:",jsonData);

        } catch {
            self.isLoading = false
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
    @Published var selectedVitalIndex: Int? = nil

    var vitalsList: [[String: Any]] = [
        [
            "parameterId": "1",
            "parameterTypeId": "4",
            "name": "Blood Pressure",
            "quantity": "0",
            "frequencyType": "ONCE A DAY (24 HOURLY)",
            "isCheck": false,
            "uhid": "123456"
        ],
        [
            "parameterId": "1",
            "parameterTypeId": "74",
            "name": "Heart Rate",
            "quantity": "0",
            "frequencyType": "ONCE A DAY (24 HOURLY)",
            "isCheck": false,
            "uhid": "123456"
        ],
        [
            "parameterId": "1",
            "parameterTypeId": "56",
            "name": "Blood Oxygen (spo2)",
            "quantity": "0",
            "frequencyType": "ONCE A DAY (24 HOURLY)",
            "isCheck": false,
            "uhid": "123456"
        ],
        [
            "parameterId": "1",
            "parameterTypeId": "7",
            "name": "Respiratory Rate",
            "quantity": "0",
            "frequencyType": "ONCE A DAY (24 HOURLY)",
            "isCheck": false,
            "uhid": "123456"
        ],
        [
            "parameterId": "1",
            "parameterTypeId": "3",
            "name": "Pulse Rate",
            "quantity": "0",
            "frequencyType": "ONCE A DAY (24 HOURLY)",
            "isCheck": false,
            "uhid": "123456"
        ],
        [
            "parameterId": "1",
            "parameterTypeId": "10",
            "name": "RBS",
            "quantity": "0",
            "frequencyType": "ONCE A DAY (24 HOURLY)",
            "isCheck": false,
            "uhid": "123456"
        ]
    ]

    var fluidIntakeDetails: [String: Any] = [
        "parameterId": "2",
        "parameterTypeId": "1",
        "name": "Fluid Limit",
        "quantity": "",
        "frequencyType": "Daily",
        "isCheck": false,
        "uhid": "0"
    ]

    
    var frequencyList: [[String: Any]] = []
    /// frequency api
    func hitFrequencyApi() async {
        print("hitFrequencyApi")
        do {
            self.isLoading = true
            let result = try await APIService.shared.fetchRawData(
                fromURL:baseURL7082 + "api/KnowMedApis/GetFrequencyList",
                parameters: ["alphabet": ""]
            )
            let jsonData = try JSONSerialization.data(withJSONObject: result)
            if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
               let jsonDict = jsonObject as? [String: Any],
               let response = jsonDict["responseValue"] as? [[String: Any]] {
                frequencyList = response
                print("decodedResponse",response)
            }
            self.isLoading = false
            print("decodedResponse",frequencyList)
        }
        catch {
            self.isLoading = false
            print("❌ Error Fetching Vitals:", error)
        }
    }
    
    
    
    @Published var weight : String = ""
    @Published var selectedUnit = "Kg"
    let unitOptions = ["Kg"]
    
    
    
    @Published var selectedFeet: Int = 5
    @Published var selectedInches: Int = 7
    @Published var selectedHeightUnit: String = "ft" // Only the unit
    @Published var selectedHeightText: String = "" // Full display text
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
    @Published var familyProblems: [Problem] = []
    @Published var problemsByFamily: [FamilyMember: [Problem]] = [:]
    func assignSelectedProblemsToRelations() {
            for rawRelation in tempSelectedHealthHistoryItems {
                guard let member = FamilyMember(rawValue: rawRelation) else { continue }
                var existingProblems = problemsByFamily[member] ?? []
                
                for problem in familyProblems {
                    if !existingProblems.contains(where: { $0.id == problem.id }) {
                        existingProblems.append(problem)
                    }
                }
                problemsByFamily[member] = existingProblems
            }
            tempSelectedHealthHistoryItems.removeAll()
        familyProblems.removeAll()
        }
    func printResultMapFamilyProblem() {
            for (member, problems) in problemsByFamily {
                print("\(member.rawValue): \(problems.map { $0.problemName })")
            }
        }
    func getFamilyProblemJson() -> String? {
        var result: [String: [String]] = [:]
        
        for (member, problems) in problemsByFamily {
            result[member.rawValue] = problems.map { $0.problemName }
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        
        return nil
    }

       @Published var searchText = ""
       @Published var showCancelButton: Bool = false
       @Published var selectedItems: [Problem] = []
       @Published var OtherselectedDiseaseItems: [Problem] = []
       @Published var chronicPreview: String = ""
    @Published var familyProblemPreview: String = ""

    // Wherever you want to generate the text, e.g. in a function
    func generateAllProblemsText() {
        var result = ""

        for member in FamilyMember.allCases {
            if let problems = problemsByFamily[member], !problems.isEmpty {
                result += "\(member.rawValue):\n"
                for problem in problems {
                    result += "• \(problem.problemName)\n"
                }
                result += "\n"
            }
        }

        familyProblemPreview = result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

       
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
//    @Published var vitalsData: [VitalsReminder] = [
//        VitalsReminder(name: "Blood Presure", subName: "3 times a day"),
//        VitalsReminder(name: "Heart Rate", subName: "3 times a day"),
//        VitalsReminder(name: "Blood Oxygen (spo2)", subName: "3 times a day"),
//        VitalsReminder(name: "Resparetry Rate", subName: "Every 4 hours"),
//        VitalsReminder(name: "RBS", subName: "Daily"),
//        ]
    @Published var showPopupReminder = false
    @Published var selectedSubName: String = "Select Frequency"
    @Published var selectedReminder: VitalsReminder?
    
    
    
    
    @Published var fluidQuantity : String = ""
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
    

    
    
    @Published var route: Routing?
    

    func navigateToDashboard() {
//        route?.navigate(to: .dashboard)
        route?.replaceAllWith(.dashboard)
    }
//    func onSignupSuccess() {
//        // Clears all navigation stack and goes to dashboard
//        routing.replaceAllWith(.dashboard)
//    }


    @Published var isSavingSuccessful : Bool = false
    @Published var showLoader: Bool = false
    @Published var tempPatientModel: PatientModel?
    func submitPatientDetails(number: String) async -> Bool {
        self.showLoader = true
        self.showError = false

        let chronic = escapedJSONString(patientDetailsList)
        let otherChronic = escapedJSONString(otherDetailsList)
        guard let jsonString = getFamilyProblemJson() else {
            print("❌ Failed to generate familyDiseaseJson")
            self.showLoader = false
            return false
        }

        guard let url = URL(string: baseURL7082 + "api/PatientRegistration/PatientSignUp") else {
            print("❌ Invalid URL")
            self.showLoader = false
            return false
        }

        vitalsList.append(fluidIntakeDetails)

        var reminderJsonString = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: vitalsList)
            reminderJsonString = String(data: jsonData, encoding: .utf8) ?? ""
            print(reminderJsonString)
        } catch {
            print("JSON encoding error: \(error)")
        }

        let jsonPayload: [String: Any] = [
            "patientName": firstName + " " + lastNmae,
            "genderId": selectedGenderId ?? "1",
            "bloodGroupId": selectedBloodGroupId ?? 0,
            "height": selectedHeightText,
            "dob": formattedDate,
            "weight": String(describing: weight),
            "zip": String(describing: zipCode),
            "address": streetAddress,
            "streetAddress": streetAddress,
            "countryCallingCode": "+91",
            "mobileNo": "\(number)",
            "countryId": selectedCountryID ?? 0,
            "stateId": selectedStateID ?? 0,
            "cityId": selectedCityID ?? 0,
            "choronicDiseasesJson": chronic ?? "",
            "otherChoronicDiseasesJson": otherChronic ?? "",
            "familyDiseaseJson": jsonString,
            "clientId": "194",
            "isExternal": "1",
            "reminderJson": reminderJsonString
        ]

        print("jsonPayload : \(jsonPayload)")

        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonPayload) else {
            print("❌ Failed to serialize JSON")
            self.showLoader = false
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                self.showError = true
                self.errorIs = "❌ Invalid response"
                self.showLoader = false
                return false
            }

            print("✅ Status Code: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 200 {
                self.isSavingSuccessful = true
                self.showLoader = false

                // Parse UHID if present
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let responseArray = json["responseValue"] as? [[String: Any]],
                   let firstItem = responseArray.first,
                   let uhid = firstItem["uhid"] as? String {
                    print("📦 UHID: \(uhid)")
                    let viewModel = LoginViewModal()
//                    await viewModel.loadData(uhid: uhid)
//                    if let patient = await viewModel.loadData(uhid: uhid) {
//                        print("✅ API Call Success")
//                        
//                        navigateToDashboard()
//                    } else {
//                        print("❌ API Call Failed")
//                    }
                    let result = await viewModel.loadData(uhid: uhid)
                    if let model = result {
                        print("✅ API Call Success")
                        tempPatientModel = model  // Save it temporarily
                        // Proceed to show OTP screen
                    } else {
                        print("❌ API Call Failed")
                    }
                    if let model = tempPatientModel {
                        print("registermodalwa \(model)")
                        UserDefaultsManager.shared.saveUserData(model)
                        UserDefaultsManager.shared.saveIsLoggedIn(loggedIn: true)
                        
                        let id = String(model.userId)
                        let extractedUHID = model.uhID ?? ""
                        
                        UserDefaultsManager.shared.saveUHID(extractedUHID)
                        UserDefaultsManager.shared.saveUserID(id)
                    

                    // Navigate to dashboard
                    navigateToDashboard()
                        
                }
                    

//                    let success = await viewModel.loadData(uhid: uhid)
//
//                    if success {
//                        print("✅ API Call Success")
//                        navigateToDashboard()
//                    } else {
//                        print("❌ API Call Failed")
//                    }

                }

                return true
            } else {
                self.isSavingSuccessful = false
                self.showError = true
                self.errorIs = "❌ Some error occurred"
                self.showLoader = false
                return false
            }

        } catch {
            print("❌ Network error: \(error.localizedDescription)")
            self.showError = true
            self.isSavingSuccessful = false
            self.errorIs = "❌ Error: \(error.localizedDescription)"
            self.showLoader = false
            return false
        }
    }

    
    @Published var showError: Bool = false
    @Published var errorIs: String = ""
    
//    func intakeError() {
//        showError = true
//
//           // Auto-dismiss after 2 seconds
//           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//               self.showError = false
//           }
//       }
    
    
    @Published var patientDetailsList: [PatientDetail] = []
    @Published var otherDetailsList: [PatientDetail] = []
       
    func addDetail(_ newDetail: PatientDetail) {
          guard !patientDetailsList.contains(where: { $0.detailID == newDetail.detailID }) else {
              return // Already exists, don't add
          }
          patientDetailsList.append(newDetail)
        let escapedBodyString = escapedJSONString(patientDetailsList)
        print(escapedBodyString ?? "")

      }
    
    func addOtherDiseaseDetail(_ newDetail: PatientDetail) {
          guard !otherDetailsList.contains(where: { $0.detailID == newDetail.detailID }) else {
              return // Already exists, don't add
          }
        otherDetailsList.append(newDetail)
        let escapedBodyString = escapedJSONString(otherDetailsList)
        print(escapedBodyString ?? "")

      }
      
    

    func removeDetail(byID id: String) {
        patientDetailsList.removeAll { $0.detailID == id }
        print(patientDetailsList)
         let escapedBodyString = escapedJSONString(patientDetailsList)
        print(escapedBodyString ?? "")
    }
    
    func removeOtherDiseaseDetail(byID id: String) {
        otherDetailsList.removeAll { $0.detailID == id }
        print(otherDetailsList)
         let escapedBodyString = escapedJSONString(otherDetailsList)
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
//        "You've come so far—just a final push!",
        "You’re just one step away from completing the process.",
        "Your submission is now complete and we're excited to have you on board.",
        "You’re nearly done—just one final step!",
        "Almost done--just complete this final step.",
        "You’re just one step away from completing the process.",
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
//        "Final Push Ahead",
//        "Just a Little Further to Go",
        "All Done!",
        "Thank you for registering with Vitalio!",
        "One Step Away",
        "All Done!",
        "All Done!",
    ]
    
    
    
    

}

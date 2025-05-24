//
//  SignUpViewModel.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/19/25.
//

import Foundation
import SwiftUI
class SignUpViewModal: ObservableObject {
    
    @Published var currentPage = 0
    @Published  var firstName: String = ""
    @Published  var lastNmae: String = ""
    
    
    struct Gender: Identifiable, Hashable{
        let id = UUID()
        let name: String
        let value: String
        let image: String
    }
    @Published var genders: [Gender] = [
        Gender(name: "Male", value: "male", image: "male"),
        Gender(name: "Female", value: "female", image: "female"),
        Gender(name: "Other", value: "other", image: "other")
    ]
    @Published  var selectedGender: String? = nil
    
    
    @Published  var selectedDate = Date()
    @Published  var formattedDate = ""
    
    
    
    struct Vital: Identifiable {
        let id = UUID()
        let name: String
        let value: String
        let unit: String
    }
    
    @Published var selectedBloodGroup: String? = nil
        
        let bloodGroups: [Vital] = [
            Vital(name: "A+", value: "99/70", unit: "mm/Hg"),
            Vital(name: "A-", value: "18", unit: "min"),
            Vital(name: "B+", value: "98.6", unit: "%"),
            Vital(name: "B-", value: "60", unit: "BPM"),
            Vital(name: "AB+", value: "98.4", unit: "°F"),
            Vital(name: "AB-", value: "170", unit: "cm"),
            Vital(name: "O+", value: "170", unit: "cm"),
            Vital(name: "O-", value: "170", unit: "cm"),
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
    
    init() {
        loadCountries()
    
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
    let unitOptions = ["Kg", "g", "ml"]
    
    
    
    @Published var selectedFeet: Int = 5
    @Published var selectedInches: Int = 7
    @Published var selectedHeightUnit: String = "ft" // Only the unit
    @Published var selectedHeightText: String = "5′ 7″ ft" // Full display text
    @Published var showPopup = false

    let feetRange = Array(3...7)
    let inchesRange = Array(0...11)
    let units = ["in", "ft", "cm"]
    
    
    
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
    
}

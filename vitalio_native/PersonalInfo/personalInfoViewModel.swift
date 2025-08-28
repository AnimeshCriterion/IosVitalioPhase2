//
//  personalInfoViewModel.swift
//  vitalio_native
//
//  Created by Test on 11/08/25.
//
import Foundation


class PersonalPersonInfoViewModel: ObservableObject {
    @Published var chronicDiseases: [ChronicDisease] = []
    @Published var isLoading: Bool = false
    private var searchTask: Task<Void, Never>?
    @Published var selectedCountry: Country?
    @Published var countries: [Country] = []
    @Published var selectedState: States?
    @Published var states: [States] = []
    @Published var selectedCity: City?
    @Published var citys: [City] = []
    @Published var selectedBloodGroup: BloodGroup?
    @Published var streetAddress = "655/79, Sarfarazganj"
    @Published var zipCode = "226101"
    @Published var weight = "56"
    @Published var height = "170"
    @Published var selectedChronicDiseases: [ChronicDisease] = []
//    private var searchWorkItem: DispatchWorkItem?
    
    init() {
        //        Task {
        //            await self.chronicDisease("")
        //        }
        Task {
        await loadCountries()
    }
    }
    
    let bloodGroups = [
        BloodGroup(id: "A+"), BloodGroup(id: "A-"),
        BloodGroup(id: "B+"), BloodGroup(id: "B-"),
        BloodGroup(id: "AB+"), BloodGroup(id: "AB-"),
        BloodGroup(id: "O+"), BloodGroup(id: "O-")
    ]
    
    @MainActor
    func searchDebounced(query: String) {
        // Cancel any ongoing search task
        searchTask?.cancel()
        
        // Create a new debounced search task
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000) // 0.4s debounce
            await chronicDisease(query)
        }
    }

    @MainActor
    private func chronicDisease(_ searchData: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await APIService.shared.fetchRawData(
                fromURL: "https://api.medvantage.tech:7082/api/KnowMedApis/GetProblemList",
                parameters: [
                    "withICDCode": "true",
                    "alphabet": searchData
                ]
            )
            
            guard let responseArray = result["responseValue"] as? [[String: Any]] else { return }
            
            let data = try JSONSerialization.data(withJSONObject: responseArray)
            let decoded = try JSONDecoder().decode([ChronicDisease].self, from: data)
            
            chronicDiseases = decoded
        } catch {
            print("Error fetching chronic diseases:", error)
        }
    }
    
    func loadCountries() async {
        guard let url = Bundle.main.url(forResource: "country_json", withExtension: "json") else {
            print("❌ countries.json not found")
            return
        }
        
        do {
            // Load data asynchronously (automatically on a background thread)
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Country].self, from: data)
            
            // Update UI on the main thread using `MainActor`
            await MainActor.run {
                self.countries = decoded
                print("Countries loaded: \(decoded.count) items")
            }
        } catch {
            await MainActor.run {
                print("❌ Failed to decode JSON:", error)
            }
        }
    }
    func StateData(_ countryID: Int) async {
        do {
            print("stateId: \(countryID)")
            
            // Update UI on the main thread before starting the request
            await MainActor.run {
                self.isLoading = true
            }
            
            let result = try await APIService.shared.fetchRawData(
                fromURL: "http://172.16.61.31:5119/api/StateMaster/GetStateMasterByCountryId",
                parameters: ["id": String(countryID), "clientId": "176"]
            )
            
            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decodedResponse = try JSONDecoder().decode(StateResponse.self, from: jsonData)
            
            // Update UI on the main thread after receiving the response
            await MainActor.run {
                self.states = decodedResponse.responseValue
                self.isLoading = false
            }
            
            print("Fetching Data:", states)
        } catch {
            // Ensure UI updates happen on the main thread even in case of errors
            await MainActor.run {
                self.isLoading = false
            }
            print("❌ Error Fetching States:", error)
        }
    }
    
    func CityData(_ stateId: Int) async {
        print("cityData \(stateId)")
        do {
            await MainActor.run {
                self.isLoading = true
            }
            let result = try await APIService.shared.fetchRawData(
                fromURL: "http://172.16.61.31:5119/api/CityMaster/GetCityMasterByStateId",
                parameters: ["id": String(stateId),
                            "clientId": "176"]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decodedResponse = try JSONDecoder().decode(CityResponse.self, from: jsonData)
            await MainActor.run {
                self.citys = decodedResponse.responseValue
            self.isLoading = false
            }
                
            print("Fetching Data:",jsonData);

        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            print("❌ Error Fetching Vitals:", error)
        }
    }
}




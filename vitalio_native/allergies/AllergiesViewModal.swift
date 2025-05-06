//
//  AllergiesViewModal.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/24/25.
//

import Foundation

class AllergiesViewModal: ObservableObject {
    
    @Published var isLoading: Bool = false
    let uhid =  UserDefaultsManager.shared.getUHID() ?? ""
    @Published var showPopup = false
    
    @Published var substance: String = ""
    @Published var reaction: String = ""
    @Published var selectedName: String?
 
    @Published var allergiesList: [AllergyRecord] = []
    
    func allergiesData() async {
        DispatchQueue.main.async {
            self.isLoading = true
           }
        do {
            let result = try await APIService.shared.fetchRawData(
                fromURL: baseURL7082 + "api/PatientIPDPrescription/PatientAllergies",
                parameters: ["uhID": uhid,
                             "clientID": clientID
                            ]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decoded = try JSONDecoder().decode(AllergiesResponse.self, from: jsonData)
            DispatchQueue.main.async {
                self.allergiesList = decoded.responseValue
                self.isLoading = false
            }

            print("Fetching Allergies:", jsonData)
        
        } catch {
            DispatchQueue.main.async {
                       self.isLoading = false
                   }
            print("❌ Error Fetching Vitals:", error)
        }
    }
    
    @Published var showAlert : Bool = false
    
    
    func addAlergiesData() async {
        showAlert = true
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let formattedDate = formatter.string(from: Date())
        print("DateTime: \(formattedDate)")
       
        
        
        let allergiesJson: [String: Any] = [
            "parameterValueId": "133",
            "parameterStatement": "Self",
            "clinicalDataTypeId": "0",
            "clinicalDataTypeRowId": "0",
            "date": formattedDate,
            "remark": reaction,
            "substance": substance,
            "severityLevel": selectedName,
            "isFromPatient": "1",
            "historyParameterAssignId": selectedSubstanceTypeID
        ]
        let allergiesArray = [allergiesJson]

        do {
            // Convert allergiesJson to JSON String
            let jsonData = try JSONSerialization.data(withJSONObject: allergiesArray, options: [])
                    guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                        print("❌ Failed to encode JSON string.")
                        return
                    }

            let result = try await APIService.shared.postWithQueryParams(
                toURL: baseURL7082 + "api/PatientIPDPrescription/SavePatientAllergies",
                parameters: [
                              "uhID": uhid,
                              "clientID": clientID,
                              "allergiesJson": jsonString
                ]
            )
            

            let decodedData = try JSONSerialization.data(withJSONObject: result)
            
            Task{
                await allergiesData()
            }
            resetFields()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showAlert = false
            }
            
            print("✅ Allergies addes successfully:", decodedData)

        } catch {
            print("❌ Error Fetching Vitals:", error)
        }
    }
    
    
    @Published var substanceTypeList: [ParameterItem] = []
    
    @Published var selectedSubstanceType: ParameterItem? = nil
    @Published var selectedSubstanceTypeID: Int? = nil
    
    func substanceType() async {
        DispatchQueue.main.async {
            self.isLoading = true
           }
        do {
            let result = try await APIService.shared.fetchRawData(
                fromURL: baseURL7082 + "api/HistorySubCategory/GetHistorySubCategoryMasterById",
                parameters: ["CategoryId": "23"]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decoded = try JSONDecoder().decode(ParameterResponse.self, from: jsonData)
            DispatchQueue.main.async {
                self.substanceTypeList = decoded.responseValue
                self.isLoading = false
            }

            print("Fetching Substance:", jsonData)
        
        } catch {
            DispatchQueue.main.async {
                       self.isLoading = false
                   }
            print("❌ Error Fetching Vitals:", error)
        }
    }
    
    @Published var showValidationAlert = false
    @Published var alertMessage = ""
   
    
    func validateFields() -> Bool {
        if selectedSubstanceType == nil {
            alertMessage = "Please select a Substance Type."
            return false
        }
        if substance.isEmpty {
            alertMessage = "Please enter Substance."
            return false
        }
        if reaction.isEmpty {
            alertMessage = "Please enter Reaction/Allergy."
            return false
        }
        if selectedName == nil {
            alertMessage = "Please select the severity of the reaction."
            return false
        }
        return true
    }
    
    
    func resetFields() {
        reaction = ""
        substance = ""
        selectedName = ""
        selectedSubstanceTypeID = nil
    }
    
    
    
}

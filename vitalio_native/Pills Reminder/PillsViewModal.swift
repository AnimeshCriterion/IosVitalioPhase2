
import Foundation

class PillsViewModal : ObservableObject {
    
    @Published var medications: [Medication] = [] // Assuming this is the expected type

    
    
    
    func getMedication() async {
        let baseURL = "https://api.medvantage.tech:7082/api/"
        let endpoint = "PatientMedication/GetAllPatientMedication"
        let uhid = "UHID01256"
        let fullURL = baseURL + endpoint

        do {
            let result = try await APIService.shared.fetchRawData(
                fromURL: fullURL,
                parameters: ["UhID": uhid]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decodedData = try JSONDecoder().decode(MedicationResponse.self, from: jsonData)
            
            print("✅ Decoded Data:", decodedData.responseValue.medicationNameAndDate)
        
            
            DispatchQueue.main.async {
                          self.medications = decodedData.responseValue.medicationNameAndDate
                      }
            
            
            
        } catch {
            print("❌ Error Fetching Medication:", error)
        }
    }

    
    
}

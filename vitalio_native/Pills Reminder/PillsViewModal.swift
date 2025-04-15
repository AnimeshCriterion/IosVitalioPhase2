
import Foundation

class PillsViewModal : ObservableObject {
    
    @Published var medications: [Medication] = []
    @Published var uniqueTimes: [String] = []
    @Published var showSuccess: Bool = false
    
    func triggerSuccess() {
           showSuccess = true

           // Auto-dismiss after 2 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.showSuccess = false
           }
       }
    
    func getMedication() async {
        let baseURL = "https://api.medvantage.tech:7082/api/"
        let endpoint = "PatientMedication/GetAllPatientMedication"
        
        let uhid =  UserDefaultsManager.shared.getUHID() ?? ""
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
            self.extractUniqueTimes(from: self.medications)
                      }
            
            
            
        } catch {
            print("❌ Error Fetching Medication:", error)
        }
    }
    
    
    
    private func extractUniqueTimes(from medications: [Medication]) {
        var timesSet = Set<String>()

        for med in medications {
            guard let jsonTimeString = med.jsonTime,
                  let data = jsonTimeString.data(using: .utf8) else {
                continue
            }

            do {
                let timeItems = try JSONDecoder().decode([JsonTimeItem].self, from: data)
                for item in timeItems {
                    var cleanedTime = item.time.trimmingCharacters(in: .whitespacesAndNewlines)

                    // Normalize based on durationType if needed
                    if cleanedTime.contains("Afternoon") {
                        cleanedTime = cleanedTime.replacingOccurrences(of: "Afternoon", with: "PM")
                    } else if cleanedTime.contains("Morning") {
                        cleanedTime = cleanedTime.replacingOccurrences(of: "Morning", with: "AM")
                    } else if cleanedTime.contains("Evening") {
                        cleanedTime = cleanedTime.replacingOccurrences(of: "Evening", with: "PM")
                    }

                    timesSet.insert(cleanedTime)
                }
            } catch {
                print("❌ Failed to decode jsonTime: \(error)")
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures proper AM/PM parsing

        let sortedTimes = Array(timesSet).sorted {
            guard let t1 = formatter.date(from: $0),
                  let t2 = formatter.date(from: $1) else {
                return false
            }
            return t1 < t2
        }

        self.uniqueTimes = sortedTimes
    }

    
    
    
    func medcineIntake(
        pmID: Int,
        prescriptionID: Int,
        convertedTime: String,  // e.g., "10:00 PM"
        durationType: String,
        date: String
    ) async {
        
      let uhid =   UserDefaultsManager.shared.getUHID() ?? ""
     let id =    UserDefaultsManager.shared.getUserID() ?? ""

        var time = ""
        if let time24 = convertTo24HourFormat(convertedTime) {

            time = time24
            print(time)  // Output: "22:00"
        }
        
        print(durationType)

        
        let params: [String: String] = [
            "UhID": uhid,
            "pmID": "\(pmID)",
            "intakeDateAndTime": "\(date) \(time)",
            "prescriptionID": "\(prescriptionID)",
            "userID": id,
            "duration": durationType,
            "compareTime": time
        ]

        print(params)
     
        

        do {
            
            let response = try await APIService.shared.postRawData(toURL: baseURL + insertPatientMedication, body: params)
            print("Response dictionary:", response)

            if let message = response["message"] as? String {
                print("Message:", message)
            }
//            let response: String = try await APIService.shared.postData(toURL: baseURL + insertPatientMedication, body: params)
//            print("✅ API Success:", response)
            triggerSuccess()
            await getMedication()
        } catch {
            print("❌ API Failed:", error.localizedDescription)
            print("❌ API Failed:", error)
        }

    }
    
    func convertTo24HourFormat(_ time12: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures AM/PM is parsed correctly

        if let date = formatter.date(from: time12) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }

        return nil
    }


}


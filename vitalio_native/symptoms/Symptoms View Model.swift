//
//  Symptoms View Model.swift
//  vitalio_native
//
//  Created by HID-18 on 21/04/25.
//

import Foundation

class SymptomsViewModal : ObservableObject {
    @Published var problemsWithIconList: [Problem] = []
    @Published var selectedSymptoms: [OtherSymptom] = []
    @Published var savingList: [SavingList] = []
    @Published var searchText: String = ""
    @Published var otherSymptomsList: [OtherSymptom] = []
    @Published  var stillHaveSymptoms: [StillHaveSymptom] = []
    @Published var showSuccess: Bool = false
    @Published var symptomResponse: [SymptomsHistoryItem] = []
    
    var groupedSymptoms: [String: [SymptomsHistoryItem]] {
        let grouped = Dictionary(grouping: symptomResponse) { symptom in
            // Format the date (e.g., "2025-05-06")
            return symptom.detailsDate ?? "Unknown Date"
        }
        return grouped
    }

    
    func triggerSuccess() {
           showSuccess = true
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.showSuccess = false
           }
       }
    

    
    func getCurrentFormattedDateTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: now)
    }
    

    
    
    func icons() {
        print("ffgiofd")
        
        let parameters = "{\"problemName\":\"\",\"languageId\":\"1\"}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(
            url: URL(string: baseURL205 + "api/v1.0/Patient/getProblemsWithIcon")!,
            timeoutInterval: Double.infinity
        )
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
                print("Headers:", httpResponse.allHeaderFields)
            } else {
                print("Invalid response")
            }
            
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(ProblemResponse.self, from: data)
                    DispatchQueue.main.async{
                        self.problemsWithIconList = decodedResponse.responseValue
                    }
                    print("✅ Problems fetched:")
                } catch {
                    print("Decoding error:", error)
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Raw response:", responseString)
                    }
                }
            }
        }
        
        task.resume()
        print("ffgiofd")
    }
    


    func getSuggessions() {
        let parameters = "{\"memberId\":\"380258\"}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(
            url: URL(string: baseURL205 + "api/v1.0/Patient/getAllSuggestedProblem")!,
            timeoutInterval: Double.infinity
        )
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error:", error ?? "Unknown error")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(OtherSymptomModel.self, from: data)
                DispatchQueue.main.async {
                    self.otherSymptomsList = decoded.responseValue
                    print("Symptoms Loaded: \(self.otherSymptomsList.count)")
                }
            } catch {
                print("Decoding error:", error)
                print("Raw response:", String(data: data, encoding: .utf8) ?? "No response string")
            }
        }

        task.resume()
    }
  


    
    func  addSavingList(_ symptoms: SavingList){
        if let index = savingList.firstIndex(where: { $0.detailID == symptoms.detailID}){
            savingList.remove(at: index)
        } else {
            savingList.append(symptoms)
        }
      print(savingList)
      print(getEncodedSymptomParam(savingList))

    }




   
    func getEncodedSymptomParam(_ savingList: [SavingList]) -> String {
        guard let jsonData = try? JSONEncoder().encode(savingList),
              let jsonString = String(data: jsonData, encoding: .utf8),
              let encoded = jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return "[]"
        }
        return encoded
    }


    func sendSymptoms(savingList: [SavingList]) {
        let encodedSymptoms = getEncodedSymptomParam(savingList)
        let baseURL = baseURL7082 +  "api/PatientIPDPrescription/InsertSymtoms"
        let fullURLString = "\(baseURL)?uhID=\(UserDefaultsManager.shared.getUserData()?.uhID ?? "" )&userID=0&doctorId=0&jsonSymtoms=\(encodedSymptoms)&clientID=\(clientID)"
        print(fullURLString)
        guard let url = URL(string: fullURLString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            print("Response:", String(data: data, encoding: .utf8) ?? "")
            DispatchQueue.main.async {
                self.triggerSuccess()
                self.savingList = []
            }
        }
        task.resume()
    }

    

    

    func getStillHaveSymptoms() {
        guard let url = URL(string: baseURL7082 +  "api/PatientIPDPrescription/GetSymtoms?uhID=\(UserDefaultsManager.shared.getUserData()?.uhID ?? "" )&clientID=\(clientID)") else { return }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }
            

            do {
                let decodedResponse = try JSONDecoder().decode(StillHaveSymptomsResponse.self, from: data)

                DispatchQueue.main.async {
                    self.stillHaveSymptoms = decodedResponse.responseValue
                    print("Loaded symptoms: \(self.stillHaveSymptoms.map { $0.details })")
                    
                }

            } catch {
                print("JSON decoding failed: \(error)")
                self.stillHaveSymptoms = []
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(responseString)")
                }
            }
            
        }

        task.resume()
    }
    func customdate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd" // Your original format

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE, dd MMMM yyyy" // Desired format

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString // fallback if parsing fails
        }
    }
    
    func SymptomsHistory() async {
        let body: [String: Any] = ["": ""]
        
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])

            // Make API call
            let result = try await APIService.shared.postRawData(
                toURL: baseURL7082 + "api/PatientIPDPrescription/GetSymtoms?uhID=\(UserDefaultsManager.shared.getUserData()?.uhID ?? "")&clientID=194",
                body: bodyData
            )
            // Print response as string
            print(result)
            if let responseValue = result["responseValue"] as? [[String: Any]] {
                let jsonData = try JSONSerialization.data(withJSONObject: responseValue, options: [])
                let decoded = try JSONDecoder().decode([SymptomsHistoryItem].self, from: jsonData)
                
                DispatchQueue.main.async {
                    self.symptomResponse = decoded
                }
            }

        } catch {
            print("❌ Error: \(error)")
        }
    }
    

    @Published var selectedFilter: TimeFilter = .weekly


//    // Call this method to load data
//    func SymptomsHistory(for date: Date) async {
//        // API call logic here
//        // Then group your response by day/week/month based on `selectedFilter`
//    }



}


//
//  UploadReportViewModel.swift
//  vitalio_native
//
//  Created by HID-18 on 24/04/25.
//

import Foundation
import UniformTypeIdentifiers

class UploadReportViewModel : ObservableObject {
    @Published var allReports : [AllReport] = []
    @Published var serverResponse: String?
    @Published var serverResponseText: String? = nil
    @Published var serverJSON: [String: Any]? = nil
    @Published var isloading: Bool = false
    @Published var showSaving: Bool = false  
    @Published var uploadingFile: Bool = false
    @Published var completed: Bool = false
    
    func newFormate(_ inputDateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "d/M/yyyy h:mm:ssa"
        inputFormatter.amSymbol = "AM"
        inputFormatter.pmSymbol = "PM"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: inputDateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date)
        } else {
            print("Failed to parse date: \(inputDateString)")
            return ""
        }
    }

    func getAllReport(name: String) async {
        DispatchQueue.main.async {
            self.isloading = true
        }
        
        let uhid =   UserDefaultsManager.shared.getUHID() ?? ""
        do{
            let result = try await APIService.shared.fetchRawData(
                fromURL: baseURL7082 + "api/PatientMediaData/GetPatientMediaData?",
                parameters: ["uhId" : uhid,"category" : name]
            )
            
            let jsonData = try JSONSerialization.data(withJSONObject: result)
            print(jsonData)
            let decodedData = try JSONDecoder().decode(AllReportResponse.self, from: jsonData)
            print(decodedData)
            DispatchQueue.main.async {
                self.allReports = decodedData.responseValue
                self.isloading = false
            }}
        catch{
            print(error)
            DispatchQueue.main.async {
                self.allReports = []
                self.isloading = false
            }}
        DispatchQueue.main.async {
            self.isloading = false
        }
    }
    
    
    
  
    func uploadFile(src: String) {
        DispatchQueue.main.async {
            self.uploadingFile = true
        }
        
        let uhid =   UserDefaultsManager.shared.getUHID() ?? ""
       let id =    UserDefaultsManager.shared.getUserID() ?? ""
            print("🚀 Step 1: Starting upload")

            let parameters = [
                [
                    "key": "file",
                    "src": src,
                    "type": "file"
                ]
            ] as [[String: Any]]

            let boundary = "Boundary-\(UUID().uuidString)"
            var body = Data()

            for param in parameters {
                if param["disabled"] != nil { continue }
                guard let paramName = param["key"] as? String else { continue }
                body += Data("--\(boundary)\r\n".utf8)
                body += Data("Content-Disposition:form-data; name=\"\(paramName)\"".utf8)

                let paramType = param["type"] as! String

                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += Data("\r\n\r\n\(paramValue)\r\n".utf8)
                } else {
                    let paramSrc = param["src"] as! String
                    let fileURL = URL(fileURLWithPath: paramSrc)

                    if let fileContent = try? Data(contentsOf: fileURL) {
                        body += Data("; filename=\"\(fileURL.lastPathComponent)\"\r\n".utf8)
                        body += Data("Content-Type: application/octet-stream\r\n\r\n".utf8)
                        body += fileContent
                        body += Data("\r\n".utf8)
                    } else {
                        print("❌ Failed to read file content from \(paramSrc)")
                        return
                    }
                }
            }

            body += Data("--\(boundary)--\r\n".utf8)

            var request = URLRequest(url: URL(string: "http://182.156.200.178:8016/uploadLabreport/?file=null")!,
                                     timeoutInterval: 60)
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = body

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("🚨 Upload error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.serverResponseText = "Error: \(error.localizedDescription)"
                    }
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                    print("📦 Headers: \(httpResponse.allHeaderFields)")
                }

                guard let data = data else {
                    print("⚠️ No data received from server.")
                    DispatchQueue.main.async {
                        self.serverResponseText = "No data received"
                    }
                    return
                }

                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    print("✅ Parsed JSON: \(jsonObject)")

                    DispatchQueue.main.async {
                        self.serverResponseText = "\(jsonObject)"
                        self.serverJSON = jsonObject as? [String: Any]
                
                            self.uploadingFile = false
                    
                    }
                } catch {
                    print("❌ JSON decode error: \(error)")
                    DispatchQueue.main.async {
                        self.serverResponseText = "Decoding error: \(error.localizedDescription)"
                        DispatchQueue.main.async {
                            self.uploadingFile = false
                        }
                    }
                }
            }
        DispatchQueue.main.async {
            self.uploadingFile = false
        }
            task.resume()
        }
    
    

    func saveFormDataWithQuery(src: String, subCategory: String, remark: String, category: String, dateTime: String) {
        
        let uhid =   UserDefaultsManager.shared.getUHID() ?? ""
       let id =    UserDefaultsManager.shared.getUserID() ?? ""
        let baseURL = baseURL7082 + "api/PatientMediaData/InsertPatientMediaData"
        let queryParams = [
            "uhId": uhid,
            "subCategory": subCategory,
            "remark": remark,
            "category": category,
            "dateTime": dateTime,
//            "dateTime": "2025-04-25T05:30:00",
            "userId": id
        ]

        // Build query string
        var components = URLComponents(string: baseURL)!
        components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let finalURL = components.url else {
            print("Invalid URL")
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()

        let fileURL = URL(fileURLWithPath: src)
        let filename = fileURL.lastPathComponent
        let mimeType = mimeTypeForPath(path: src)

        if let fileData = try? Data(contentsOf: fileURL) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"formFile\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        } else {
            print("Could not read file")
            return
        }

        var request = URLRequest(url: finalURL, timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }
        task.resume()
    }

    func mimeTypeForPath(path: String) -> String {
        let url = URL(fileURLWithPath: path)
        if let type = UTType(filenameExtension: url.pathExtension) {
            return type.preferredMIMEType ?? "application/octet-stream"
        }
        return "application/octet-stream"
    }
    

    func insertInvestigationFromServerData() {
        
        guard let responseArray = serverJSON?["response"] as? [Any],
              let firstResponse = responseArray.first as? [String: Any],
              let patientDetails = firstResponse["patient_details"] as? [String: Any],
              let reportArray = firstResponse["report"] as? [[String: Any]] else {
            print("Invalid server data format.")
            return
        }
        
        // 1. Prepare tempPatientData dynamically
        let itemName = "General Report" // You can decide better naming based on requirement
        let itemId = ""
        let labName = patientDetails["lab_name"] as? String ?? ""
        let receiptNo = "" // No receiptNo found in API, so keeping blank
        let rawReportedDate = patientDetails["reported_date"] as? String ?? ""
        let resultDateTime = newFormate(rawReportedDate)

        let tempPatientData: [[String: Any]] = [
            [
                "itemName": itemName,
                "itemId": itemId,
                "labName": labName,
                "receiptNo": receiptNo,
                "resultDateTime": resultDateTime
            ]
        ]
        
        let tempReportData: [[String: Any]] = reportArray.map { testDict in
            let resultString = testDict["result"] as? String ?? ""
            let rangeString = testDict["normal_values"] as? String ?? ""
            
            // Default normal = "1" (normal), will change to "0" (abnormal) if needed
            var isNormal = "1"
            
            if let result = Double(resultString) {
                // Range can be "13 - 17" format, so split and check
                let components = rangeString.components(separatedBy: " - ")
                if components.count == 2,
                   let lowerBound = Double(components[0].trimmingCharacters(in: .whitespaces)),
                   let upperBound = Double(components[1].trimmingCharacters(in: .whitespaces)) {
                    
                    if !(lowerBound...upperBound).contains(result) {
                        isNormal = "0" // result is OUTSIDE the normal range
                    }
                }
            }
            
            return [
                "subTestId": "",
                "subTestName": testDict["test_name"] as? String ?? "",
                "range": rangeString,
                "resultDateTime": "",
                "result": resultString,
                "unit": testDict["unit"] as? String ?? "",
                "isNormal": isNormal
            ]
        }
        
        // 3. Convert tempPatientData to JSON string
        guard let tempPatientDataJSON = try? JSONSerialization.data(withJSONObject: tempPatientData, options: []),
              let tempPatientDataString = String(data: tempPatientDataJSON, encoding: .utf8) else {
            print("Failed to serialize tempPatientData")
            return
        }
        
        // 4. Convert tempReportData to JSON string
        guard let tempReportDataJSON = try? JSONSerialization.data(withJSONObject: tempReportData, options: []),
              let tempReportDataString = String(data: tempReportDataJSON, encoding: .utf8) else {
            print("Failed to serialize tempReportData")
            return
        }
        
            let uhid =   UserDefaultsManager.shared.getUHID() ?? ""
        let idString = UserDefaultsManager.shared.getUserID() ?? ""

        // Try to parse the id to an integer
        let id = Int(idString) ?? 0  // Default to 0 if the conversion fails
        
        print(uhid)
        print(id)
        // 5. Build parameters
        let parameters = """
        {
            "uhid": "\(uhid)",
            "investigationDetailsJson": '\(tempPatientDataString)',
            "investigationResultJson": '\(tempReportDataString)',
            "clientId": \(clientID),
            "userId": \(id)
        }
        """
        
        // 6. Convert parameters to Data
        guard let postData = parameters.data(using: .utf8) else {
            print("Failed to encode parameters.")
            return
        }
        
        // 7. Prepare URL request
        guard let url = URL(string: "http://172.16.61.31:5090/api/InvestigationByPatient/InsertResult") else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        
        print("Request URL: \(url)")
        print("Request Body: \(parameters)")
        
        // 8. Execute API call
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
            }
        }
        DispatchQueue.main.async {
            self.completed = true
        }
        task.resume()
    }


}

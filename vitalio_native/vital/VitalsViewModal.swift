//
//  VitalsViewModal.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/15/25.
//

import Combine
import Foundation
import SwiftUI


class VitalsViewModal: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var vitals: [Vital] = []
    @Published var data: String = ""
    @Published var unitData: String = ""
    @Published var patientGraph: [PatientGraph] = []
    @Published var patientVital: [PatientVital] = []
    @Published var vitalsDate: [VitalsDate] = []
    @Published var selectedVital: Vital?
    @Published var matchSelectedValue: [String] = []
    @Published var vmValueBPSys = ""
    @Published var vmValueBPDias = ""
    @Published var vmValueSPO2 = "0"
    @Published var vmValueRespiratoryRate = "0"
    @Published var vmValueHeartRate = "0"
    @Published var vmValuePulse = "0"
    @Published var vmValueRbs = "0"
    @Published var vmValueTemperature = "0"
    
    // Use a unique identifier, e.g., rowId

    @Published var showVoiceAssistant = false
    
     // Called when the drag/press begins
     func startVoiceAssistant() {
         guard !showVoiceAssistant else { return }
         showVoiceAssistant = true
         print("started")
         // … any additional startup logic here …
     }
    
     // Called when the drag/press ends
     func stopVoiceAssistant() {
         guard showVoiceAssistant else { return }
         showVoiceAssistant = false
         print("ended")
         // … any cleanup logic here …
     }
    
//    func getVitals() async {
//        let uhid =  UserDefaultsManager.shared.getUHID() ?? ""
//        DispatchQueue.main.async {
//            self.isLoading = true
//           }
//        do {
//            let result = try await APIService.shared.fetchRawData(
//                fromURL: baseURL7082 + "api/PatientVital/GetPatientLastVital",
//                parameters: ["uhID": uhid]
//            )
//
//            let jsonData = try JSONSerialization.data(withJSONObject: result)
//            
//            let decoded = try JSONDecoder().decode(VitalResponse.self, from: jsonData)
//            DispatchQueue.main.async {
//                self.vitals = decoded.responseValue.lastVital
//                self.isLoading = false
//            }
//            DispatchQueue.main.async {
//                self.vitals = decoded.responseValue.lastVital
//                
//                // Now map vitalName to your variables
//                for vital in decoded.responseValue.lastVital {
//                    switch vital.vitalName {
//                    case "BP_Sys":
//                        self.vmValueBPSys = "\(vital.vitalValue)"
//                    case "BP_Dias":
//                        self.vmValueBPDias = "\(vital.vitalValue)"
//                    case "Spo2":
//                        self.vmValueSPO2 = "\(vital.vitalValue)"
//                    case "RespRate":
//                        self.vmValueRespiratoryRate = "\(vital.vitalValue)"
//                    case "HeartRate":
//                        self.vmValueHeartRate = "\(vital.vitalValue)"
//                    case "Pulse":
//                        self.vmValuePulse = "\(vital.vitalValue)"
//                    case "RBS":
//                        self.vmValueRbs = "\(vital.vitalValue)"
//                    case "Temperature":
//                        self.vmValueTemperature = "\(vital.vitalValue)"
//                    default:
//                        break
//                    }}}
//            // 🖨️ Print all final values
//              print("✅ Updated Vitals:")
//              print("vmValueBPSys: \(self.vmValueBPSys)")
//              print("vmValueBPDias: \(self.vmValueBPDias)")
//              print("vmValueSPO2: \(self.vmValueSPO2)")
//              print("vmValueRespiratoryRate: \(self.vmValueRespiratoryRate)")
//              print("vmValueHeartRate: \(self.vmValueHeartRate)")
//              print("vmValuePulse: \(self.vmValuePulse)")
//              print("vmValueRbs: \(self.vmValueRbs)")
//              print("vmValueTemperature: \(self.vmValueTemperature)")
//        } catch {
//            print("❌ Error Fetching Vitals:", error)
//        }
//    }
    var groupedVitals: [Vital] {
        // All vital names you expect
        let allVitalNames = [
            "Blood Pressure", "HeartRate", "Spo2", "Temperature", "Pulse",
            "RespRate", "RBS", "Weight", "Height"
        ]
        
        var result: [Vital] = []
        var addedBP = false

        // Step 1: Handle existing vitals
        for vital in vitals {
            if vital.vitalName == "BP_Sys" || vital.vitalName == "BP_Dias" {
                if addedBP { continue }
                if let sys = vitals.first(where: { $0.vitalName == "BP_Sys" }),
                   let dias = vitals.first(where: { $0.vitalName == "BP_Dias" }) {
                    let bpVital = Vital(
                        uhid: sys.uhid,
                        pmId: sys.pmId,
                        vitalID: sys.vitalID,
                        vitalName: "Blood Pressure",
                        vitalValue: 0,
                        unit: "mmHg",
                        vitalDateTime: sys.vitalDateTime,
                        userId: sys.userId,
                        rowId: sys.rowId
                    )
                    result.append(bpVital)
                    addedBP = true
                }
            } else {
                result.append(vital)
            }
        }

        // Step 2: Add missing vitals with placeholder
        let existingNames = Set(result.map { $0.vitalName })
        for name in allVitalNames where !existingNames.contains(name) {
            let placeholderVital = Vital(
                uhid: "", pmId: 0, vitalID: 0,
                vitalName: name,
                vitalValue: 0,
                unit: unitForVital(name), // Optional: provide default unit
                vitalDateTime: "", userId: 0, rowId: 0
            )
            result.append(placeholderVital)
        }

        return result
    }
    func unitForVital(_ name: String) -> String {
        switch name {
        case "Blood Pressure": return "mmHg"
        case "HeartRate", "Pulse": return "/min"
        case "Spo2": return "%"
        case "Temperature": return "°F"
        case "RespRate": return "/min"
        case "RBS": return "mg/dL"
        case "Weight": return "kg"
        case "Height": return "cm"
        default: return ""
        }
    }


    let vitalPriorityOrder: [String] = [
        "BP_Sys",       // 1. Blood Pressure (systolic)
        "BP_Dias",      // 1. Blood Pressure (diastolic)
        "HeartRate",    // 2. Heart Rate
        "Spo2",         // 3. SpO2
        "Temperature",  // 4. Temperature
        "RespRate",     // 5. Respiratory Rate
        "RBS",          // 6. RBS
        "Pulse",
        "Weight",        // 7. Weight
        "Height"
    ]

    
    func getVitals() async {
        let uhid = UserDefaultsManager.shared.getEmployee()?.empId ?? ""

        DispatchQueue.main.async {
            self.isLoading = true
        }

        do {
            let result = try await APIService.shared.fetchRawData(
                fromURL: baseURL7082 + "api/PatientVital/GetPatientLastVital",
                parameters: ["uhID": uhid]
            )

            let jsonData = try JSONSerialization.data(withJSONObject: result)
            let decoded = try JSONDecoder().decode(VitalResponse.self, from: jsonData)

            var fetchedVitals = decoded.responseValue.lastVital
            print("fetchedVitals \(fetchedVitals)")
            let orderedVitals = fetchedVitals.sorted {
                let firstIndex = vitalPriorityOrder.firstIndex(of: $0.vitalName) ?? Int.max
                let secondIndex = vitalPriorityOrder.firstIndex(of: $1.vitalName) ?? Int.max
                return firstIndex < secondIndex
            }

            print("orderedVitals \(orderedVitals)")

            // MARK: - Add missing default vitals
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let nowString = formatter.string(from: Date())

            let defaultVitals: [Vital] = [
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "BP_Sys", vitalValue: 0, unit: "mmHg", vitalDateTime: nowString, userId: 0, rowId: 0),
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "BP_Dias", vitalValue: 0, unit: "mmHg", vitalDateTime: nowString, userId: 0, rowId: 0),
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "HeartRate", vitalValue: 0, unit: "bpm", vitalDateTime: nowString, userId: 0, rowId: 0),
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "Spo2", vitalValue: 0, unit: "%", vitalDateTime: nowString, userId: 0, rowId: 0),
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "Temperature", vitalValue: 0, unit: "°F", vitalDateTime: nowString, userId: 0, rowId: 0),
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "Pulse", vitalValue: 0, unit: "bpm", vitalDateTime: nowString, userId: 0, rowId: 0),
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "RespRate", vitalValue: 0, unit: "rpm", vitalDateTime: nowString, userId: 0, rowId: 0),
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "RBS", vitalValue: 0, unit: "mg/dL", vitalDateTime: nowString, userId: 0, rowId: 0),
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "Weight", vitalValue: 0, unit: "kg", vitalDateTime: nowString, userId: 0, rowId: 0),
                Vital(uhid: uhid, pmId: 0, vitalID: 0, vitalName: "Height", vitalValue: 0, unit: "cm", vitalDateTime: nowString, userId: 0, rowId: 0),
            ]

            let existingVitalNames = Set(fetchedVitals.map { $0.vitalName })
            let missingDefaults = defaultVitals.filter { !existingVitalNames.contains($0.vitalName) }

            fetchedVitals.append(contentsOf: missingDefaults)

            DispatchQueue.main.async {
                self.vitals = orderedVitals
                self.isLoading = false

                // 🧠 Map to view model variables
                for vital in fetchedVitals {
                    switch vital.vitalName {
                    case "BP_Sys":
                        self.vmValueBPSys = "\(vital.vitalValue)"
                    case "BP_Dias":
                        self.vmValueBPDias = "\(vital.vitalValue)"
                    case "Spo2":
                        self.vmValueSPO2 = "\(vital.vitalValue)"
                    case "RespRate":
                        self.vmValueRespiratoryRate = "\(vital.vitalValue)"
                    case "HeartRate":
                        self.vmValueHeartRate = "\(vital.vitalValue)"
                    case "Pulse":
                        self.vmValuePulse = "\(vital.vitalValue)"
                    case "RBS":
                        self.vmValueRbs = "\(vital.vitalValue)"
                    case "Temperature":
                        self.vmValueTemperature = "\(vital.vitalValue)"
//                    case "Weight":
//                        self.vmValueWeight = "\(vital.vitalValue)"
//                    case "Height":
//                        self.vmValueHeight = "\(vital.vitalValue)"
                    default:
                        break
                    }
                }

                // ✅ Debug print
                print("✅ Updated Vitals:")
                print("vmValueBPSys: \(self.vmValueBPSys)")
                print("vmValueBPDias: \(self.vmValueBPDias)")
                print("vmValueSPO2: \(self.vmValueSPO2)")
                print("vmValueRespiratoryRate: \(self.vmValueRespiratoryRate)")
                print("vmValueHeartRate: \(self.vmValueHeartRate)")
                print("vmValuePulse: \(self.vmValuePulse)")
                print("vmValueRbs: \(self.vmValueRbs)")
                print("vmValueTemperature: \(self.vmValueTemperature)")
//                print("vmValueWeight: \(self.vmValueWeight)")
//                print("vmValueHeight: \(self.vmValueHeight)")
            }
        } catch {
            DispatchQueue.main.async {
                self.vitals = []
                self.isLoading = false
            }
            print("❌ Error Fetching Vitals:", error)
        }
    }


    
    
    func myCurrentDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func myCurrentTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    
    func timeAgoSince(_ dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")

            guard let date = formatter.date(from: dateString) else {
                return "Invalid date"
            }

            let secondsAgo = Int(Date().timeIntervalSince(date))

            let minute = 60
            let hour = 60 * minute
            let day = 24 * hour

            if secondsAgo < minute {
                return "Just now"
            } else if secondsAgo < hour {
                return "\(secondsAgo / minute) min ago"
            } else if secondsAgo < day {
                return "\(secondsAgo / hour) hr ago"
            } else if secondsAgo < day * 2 {
                return "Yesterday"
            } else {
                return "\(secondsAgo / day) days ago"
            }
        }
    
    
    func colorForVitalName(_ name: String) -> Color {
        switch name {
        case "BP_Sys", "BP_Dias", "Temperature":
            return .red
        case "Spo2","RBS" :
            return .blue
        case "HeartRate", "RespRate":
            return .yellow
        default:
            return .blue
        }
    }
    
    
    @MainActor
    func addVitals(_ values: [String: String]) async {
        print("matchSelectedValue \(matchSelectedValue)")
        let uhid =  UserDefaultsManager.shared.getEmployee()?.empId ?? ""
//        let uhid =  UserDefaultsManager.shared.getUHID() ?? ""
        var body = [
//            "vmValueBPSys": vmValueBPSys,
//            "vmValueBPDias": vmValueBPDias,
//            "vmValueSPO2": vmValueSPO2,
//            "vmValueRespiratoryRate": vmValueRespiratoryRate,
//            "vmValueHeartRate": vmValueHeartRate,
//            "vmValuePulse": vmValuePulse,
//            "vmValueRbs": vmValueRbs,
//            "vmValueTemperature": vmValueTemperature,
            "uhid": uhid,
            "userId":(UserDefaultsManager.shared.getUserData()?.userId ?? "0"),
            "vitalDate": myCurrentDate(Date()),
            "vitalTime": myCurrentTime(Date()),
            "clientId": clientID,
            "isFromPatient":"true",
            "positionId":"129"
        ]
        for (key, value) in values {
             body[key] = value
            }
        print(body)
        do {
            let result = try await APIService.shared.postRawData(toURL: baseURL7082 + "api/PatientVital/InsertPatientVital", body: body)
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
                    let jsonString = String(data: jsonData, encoding: .utf8) {
                     print("✅ API Response:\n\(jsonString)")
                 } else {
                     print("📦 Raw Response:\n\(result)")
                 }
            matchSelectedValue.removeAll()
            Task{
            await getVitals()
            }
        } catch {
          print("❌ Error occured", error)
        }
    }
    
    
    
//    func vitalsHistory() async {
//        do {
//            let result = try await APIService.shared.fetchRawData(
//                fromURL:"https://api.medvantage.tech:7082/api/PatientVital/GetPatientVitalGraph",
//                parameters: [
//                    "userId" : "0",
////                    "uhID": "UHID01256",
//                    "UHID" : "UHID01235",
//                    "vitalIdSearchNew" : "6,4",
//                    "vitalDate" : "2025-04-21",
//                    "currentDate" : "2025-04-27"
//
//
//                ]
//            )
//
//            let jsonData = try JSONSerialization.data(withJSONObject: result)
//            let decoded = try JSONDecoder().decode(VitalResponse.self, from: jsonData)
//            DispatchQueue.main.async {
//                self.vitals = decoded.responseValue
//            }
//            print("✅ Vitals sent successfully:", decoded)
//
//        } catch {
//            print("❌ Error Fetching Vitals:", error)
//        }
//    }
    
    @Published var historyFilter: VitalHistoryFilter = .daily
    
    enum VitalHistoryFilter {
        case daily
        case weekly
        case monthly
    }
    
    
    /// formate date
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
    
    
    
    let currentDate = Date()
//    var startDate: Date
    var startDate: Date = Date()
    
    func mapPeriodToFilter(_ period: Period) -> VitalHistoryFilter {
        switch period {
        case .daily: return .daily
        case .weekly: return .weekly
        case .monthly: return .monthly
        }
    }
    
    func vitalsHistory() async {
        
        let uhid =  UserDefaultsManager.shared.getUHID() ?? ""
        let userId =  UserDefaultsManager.shared.getUserID() ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

      

        switch historyFilter {
        case .daily:
            startDate = currentDate
        case .weekly:
            startDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate) ?? currentDate
        case .monthly:
            startDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        }
        
        
        let parameters: [String: String] = [
            "userId": userId,
            "UHID": uhid,
            "vitalIdSearchNew": String(selectedVital!.vitalID),
            "vitalDate": formatter.string(from: startDate),
            "currentDate": formatter.string(from: currentDate)
        ]
        print("✅ Vitals body parameters :", parameters)

        do {
            let result = try await APIService.shared.fetchRawData(
                fromURL: baseURL7082 + "api/PatientVital/GetPatientVitalGraph",
                parameters: parameters
            )

         
            let jsonData = try JSONSerialization.data(withJSONObject: result)

           
            let decoded = try JSONDecoder().decode(VitalHistoryResponse.self, from: jsonData)

          
            DispatchQueue.main.async {
                self.patientGraph = decoded.responseValue.patientGraph
                self.patientVital = decoded.responseValue.patientVital
                self.vitalsDate = decoded.responseValue.vitalsDate
            }

            print("✅ Vitals fetched successfully:", decoded)
        } catch {
            print("❌ Error Fetching Vitals:", error.localizedDescription)
        }
    }


    
    func timeAgoSince(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: dateString) else { return "Invalid date" }

        let interval = Date().timeIntervalSince(date)

        switch interval {
        case 0..<60:
            return "Just now"
        case 60..<3600:
            let minutes = Int(interval / 60)
            return "\(minutes) min ago"
        case 3600..<86400:
            let hours = Int(interval / 3600)
            return "\(hours) hr ago"
        default:
            let days = Int(interval / 86400)
            return "\(days) day\(days > 1 ? "s" : "") ago"
        }
    }

    
    var vitalsTimer: Timer?
    
    
    
     
//    enum VitalStatus {
//
//        case normal
//
//        case borderline
//
//        case critical
//     
//        var color: Color {
//
//            switch self {
//
//            case .normal: return .green
//
//            case .borderline: return .orange
//
//            case .critical: return .red
//
//            }
//
//        }
//     
//        var label: String {
//
//            switch self {
//
//            case .normal: return "Normal"
//
//            case .borderline: return "Borderline"
//
//            case .critical: return "Critical"
//
//            }
//
//        }
//
//    }

    func getVitalStatus(for vital: String, value: String) -> VitalStatus {
        let cleanedValue = value.filter("0123456789.".contains)
        let doubleVal = Double(cleanedValue) ?? 0

        switch vital {
        case "BP_Sys":
            switch doubleVal {
            case 90...120: return .normal
            case 121...139: return .borderline
            default: return .critical
            }

        case "BP_Dias":
            switch doubleVal {
            case 60...80: return .normal
            case 81...89: return .borderline
            default: return .critical
            }

        case "HeartRate", "Pulse":
            switch doubleVal {
            case 60...100: return .normal
            case 50...59, 101...110: return .borderline
            default: return .critical
            }

        case "Spo2":
            switch doubleVal {
            case 95...100: return .normal
            case 90..<95: return .borderline
            default: return .critical
            }

        case "Temperature":
            switch doubleVal {
            case 97.0...99.5: return .normal
            case 99.6...100.4: return .borderline
            default: return .critical
            }

        case "RespRate":
            switch doubleVal {
            case 12...20: return .normal
            case 10...11, 21...24: return .borderline
            default: return .critical
            }

        case "RBS":
            switch doubleVal {
            case 70...140: return .normal
            case 141...180: return .borderline
            default: return .critical
            }

        case "Body Weight":
            return .normal // You can later apply your own rules

        default:
            return .normal
        }
    }




     
//    func getVitalStatus(for vital: String, value: String) -> VitalStatus {
//        print(" AllVitals: \(vital)")
//
//        switch vital {
//
//        case "BPSys", "BPDias":
//
//            let match = value.range(of: #"(\d{2,3})/(\d{2,3})"#, options: .regularExpression)
//
//            if let match = match {
//
//                let parts = String(value[match]).split(separator: "/")
//
//                if let sys = Int(parts[0]), let dia = Int(parts[1]) {
//
//                    if (90...120).contains(sys) && (60...80).contains(dia) {
//
//                        return .normal
//
//                    } else if (121...139).contains(sys) || (81...89).contains(dia) {
//
//                        return .borderline
//
//                    }
//
//                }
//
//            }
//
//            return .critical
//
//        case "HeartRate", "Pulse":
//
//            let intVal = Int(value.filter("0123456789".contains)) ?? 0
//
//            switch intVal {
//
//            case 60...100: return .normal
//
//            case 50...59, 101...110: return .borderline
//
//            default: return .critical
//
//            }
//
//        case "Spo2":
//
//            let intVal = Int(value.replacingOccurrences(of: "%", with: "")) ?? 0
//
//            if intVal >= 95 { return .normal }
//
//            else if intVal >= 90 { return .borderline }
//
//            else { return .critical }
//
//        case "Temperature":
//
//            let temp = Double(value.filter("0123456789.".contains)) ?? 0
//
//            if (97.0...99.5).contains(temp) { return .normal }
//
//            else if (99.6...100.4).contains(temp) { return .borderline }
//
//            else { return .critical }
//
//        case "RespRate":
//
//            let intVal = Int(value.filter("0123456789".contains)) ?? 0
//
//            switch intVal {
//
//            case 12...20: return .normal
//
//            case 10...11, 21...24: return .borderline
//
//            default: return .critical
//
//            }
//
//        case "RBS":
//
//            let intVal = Int(value.filter("0123456789".contains)) ?? 0
//
//            switch intVal {
//
//            case 70...140: return .normal
//
//            case 141...180: return .borderline
//
//            default: return .critical
//
//            }
//
//        case "Body Weight":
//
//            return .normal
//
//        default:
//
//            return .normal
//
//        }
//
//    }

    
//    let status = getVitalStatus(for: vitalName, value: value)
//
//  VitalRowView(vitalName: "Blood Pressure", value: "125/85")
//
//  VitalRowView(vitalName: "Heart Rate", value: "108")
//
//  VitalRowView(vitalName: "SpO2", value: "92%")

   
     
    
    
    
    
    
}

enum VitalStatus {
    case normal
    case borderline
    case critical

    var color: Color {
        switch self {
        case .normal:
            return .green
        case .borderline:
            return .orange
        case .critical:
            return .red
        }
    }
}

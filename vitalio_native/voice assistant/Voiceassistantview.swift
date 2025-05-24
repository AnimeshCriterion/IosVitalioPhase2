import SwiftUI
import Starscream
import AVFoundation

#Preview {
    Voiceassistantview()
}

struct Voiceassistantview: View {
    @State private var wavePhase: CGFloat = 0
    @State private var socket: WebSocket?
    @State private var message = "Connecting..."
    @State private var recievedText = ""
    @State private var recorder: AudioCapture?
    @EnvironmentObject var viewModel : DashboardViewModal
    @EnvironmentObject var symptomsVM : SymptomsViewModal
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.15, green: 0.45, blue: 1.0), Color(red: 0.0, green: 0.25, blue: 0.7)]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()

            VStack {
                Spacer()
                    .onAppear {
                        Task{
                         await connectWebSocket()
                        }
                    }
                    .onDisappear {
                        sendRequest(text: recievedText)
                        recorder?.stop()
                        disconnectWebSocket()
                    }
                Text(message)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                                Text(recievedText)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                  
             

                Spacer()

                VStack(spacing: 20) {
                    AnimatedWave(phase: wavePhase)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        .frame(height: 20)
                        .onAppear {
                            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                                wavePhase = .pi * 2
                            }
                        }

                    HStack {
                        Text("Speak to add your vitals or report your symptoms")
                            .foregroundColor(.white)
                            .font(.footnote)
                            .padding(.leading)
                        Spacer()
                    }
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
    }

    func connectWebSocket() async  {
//     await   sendTextToVoiceData(text : "what is your name")
        guard let url = URL(string: socketURL + "listen?token=5678") else {
            message = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let webSocket = WebSocket(request: request)
        socket = webSocket

        webSocket.onEvent = { event in
            switch event {
            case .connected(_):
                message = "Connected"
                webSocket.write(string: "Hello WebSocket")

                // Start mic stream
                recorder = AudioCapture(socket: webSocket)
                recorder?.start()

            case .text(let text):
                DispatchQueue.main.async {
                    self.recievedText += " \(text)"
                    if(viewModel.showVoiceAssistant==false){
                        viewModel.lastTextRecieved = true
                        viewModel.showVoiceAssistant = false
                    }
                       
                }

            case .disconnected(let reason, let code):
                message = "Disconnected: \(reason) (\(code))"

            case .error(let error):
                message = "Error: \(error?.localizedDescription ?? "Unknown")"

            default:
                break
            }
        }

        webSocket.connect()
    }

    func disconnectWebSocket() {
        socket?.disconnect()
        socket = nil
        message = "Disconnected"
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var textApiUrlUrl = "http://food.shopright.ai:3478/api/echo/"
    

    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    func getCurrentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    var uhid =  UserDefaultsManager.shared.getUHID() ?? ""
    var id =    UserDefaultsManager.shared.getUserID() ?? ""
    
    
    @EnvironmentObject var vitalsVM: VitalsViewModal
    
    
    // Static list of fluids
    let temp: [[String: String]] = [
        ["name": "water", "id": "97694"],
        ["name": "milk", "id": "76"],
        ["name": "green tea", "id": "114973"],
        ["name": "coffee", "id": "168"],
        ["name": "fruit juice", "id": "66"]
    ]

    // Simulate receiving data from the response
    let myVital: [String: Any] = [
        "fluidValue": [
            "water": 90.0
        ]
    ]


    func sendRequest(text: String) {
  
        // Dynamically create the parameters as a JSON string
        let parameters = """
        {
          "text": {
            "text": "\(text)",
            "userid": "\(id)",
            "uhid": "\(uhid)",
            "date": "2024-09-18",
            "time": "11:55:12",
            "clientID": 1,
            "medication": [
              {
                "drugName": [],
                "medicationNameAndDate": []
              }
            ]
          }
        }
        """
        
        // Convert the string to Data
        guard let postData = parameters.data(using: .utf8) else {
            print("Failed to create data from parameters.")
            return
        }
        
        // Create the URLRequest
        guard let url = URL(string: "http://food.shopright.ai:3478/api/echo/") else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        // Send the HTTP request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return
            }
            
            
            // Try to parse the response into a dictionary
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let echo = jsonObject["echo"] as? [String: Any],
                   let myVital = echo["myvital"] as? [String: Any] {
                    if let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                       let jsonString = String(data: prettyData, encoding: .utf8) {
                        print(jsonString)
                    } else {
                        print("Failed to format JSON.")
                    }

                    
                    // Extract values from the JSON response
                    let uhID = myVital["uhID"] as? String ?? "N/A"
                    

                    
                    
                    
                    
                    
                    
                    
                    
                    
                    // FLUID
                    
                    let userId = myVital["userId"] as? String ?? "N/A"
                    let fluidValue = myVital["fluidValue"] as? [String: Any]
                    let waterValue = fluidValue?["water"] as? Double ?? 0.0
                    if let fluidValue = myVital["fluidValue"] as? [String: Any] {
                        
                        // Loop through the fluidValue dictionary
                        for (key, value) in fluidValue {
                            // Check for the corresponding fluid in the static list
                            if let fluidName = key as? String, let fluidAmount = value as? Double {
                                if let fluid = temp.first(where: { $0["name"] == fluidName }) {
                                    // Extract the id of the corresponding fluid
                                    if let fluidId = fluid["id"] {
                                        // Print the fluid name, id, and valu
                                        print("Fluid: \(fluidName), ID: \(fluidId), Value: \(fluidAmount)")
                                        Task{
                                            await saveIntake(selectedFoodId: Int(fluidId) ?? 0, fluidLevel: String(fluidAmount))
                                            
                                        }
                                    }
                                }
                            }
                        }}
                    
                    
                    // Print the extracted values
                    print("User ID: \(userId)")
                    print("Fluid water value: \(waterValue)")
                    print("Fluid : \(waterValue)")
                    
                    
                    
                    
                    
                    
 //            VITALS          VITALS          VITALS          VITALS          VITALS          VITALS          VITALS
                    
                    DispatchQueue.main.async {
                        vitalsVM.vmValueBPSys = String(describing: myVital["vmValueBPSys"] ?? "")
                        vitalsVM.vmValueBPDias = String(describing: myVital["vmValueBPDias"] ?? "")
                        vitalsVM.vmValueRespiratoryRate = String(describing: myVital["vmValueRespiratoryRate"] ?? "")
                        vitalsVM.vmValueSPO2 = String(describing: myVital["vmValueSPO2"] ?? "")
                        vitalsVM.vmValuePulse = String(describing: myVital["vmValuePulse"] ?? "")
                        vitalsVM.vmValueTemperature = String(describing: myVital["vmValueTemperature"] ?? "")
                        vitalsVM.vmValueHeartRate = String(describing: myVital["vmValueHeartRate"] ?? "")
                        vitalsVM.vmValueRbs = String(describing: myVital["vmValueRbs"] ?? "")
                    }
                    
                    let vmValueUrineOutput = myVital["vmValueUrineOutput"]
                    
                    let weight = myVital["weight"] as? Int ?? 0
                    let vitalDate = myVital["vitalDate"] as? String ?? "N/A"
                    let vitalTime = myVital["vitalTime"] as? String ?? "N/A"
                    
                    
                    
                    
                    if (myVital["vmValueBPSys"] as? Int ?? 0) != 0 ||
                       (myVital["vmValueBPDias"] as? Int ?? 0) != 0 ||
                       (myVital["vmValueRespiratoryRate"] as? Int ?? 0) != 0 ||
                       (myVital["vmValueSPO2"] as? Int ?? 0) != 0 ||
                       (myVital["vmValuePulse"] as? Int ?? 0) != 0 ||
                       (myVital["vmValueTemperature"] as? Double ?? 0.0) != 0.0 ||
                       (myVital["vmValueHeartRate"] as? Int ?? 0) != 0 ||
                       (myVital["vmValueRbs"] as? Int ?? 0) != 0 {
                        
                        
                        print("Vital is present")
                        Task{
                            await addVitals()
                        }
                 
                    }

                    
                    
                    
                    print("Blood Pressure Sys: \(vitalsVM.vmValueBPSys)")
                    print("Blood Pressure Dias: \(vitalsVM.vmValueBPDias)")
                    print("Respiratory Rate: \(vitalsVM.vmValueRespiratoryRate)")
                    print("SPO2: \(vitalsVM.vmValueSPO2)")
                    print("Pulse: \(vitalsVM.vmValuePulse)")
                    print("Temperature: \(vitalsVM.vmValueTemperature)")
                    print("Heart Rate: \(vitalsVM.vmValueHeartRate)")
                    print("RBS: \(vitalsVM.vmValueRbs)")
                    print("Urine Output: \(vmValueUrineOutput)")
                    print("Vital Date: \(vitalDate)")
                    print("Vital Time: \(vitalTime)")
                    print("Vital Time: \(weight)")
                    print("Systolic BP: \(vitalsVM.vmValueBPSys), Diastolic BP: \(vitalsVM.vmValueBPDias)")
                    print("Temperature: \(vitalsVM.vmValueTemperature)")
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
            
                    if let symptomsArray = myVital["symptomsList"] as? [[String: Any]], !symptomsArray.isEmpty {
                      
                        var savingList: [SavingList] = []

                        for symptomDict in symptomsArray {
                            if let symptom = symptomDict["symptom"] as? String,
                               let id = symptomDict["id"] {
                                
                                let item = SavingList(
                                    detailID: "\(id)",
                                    detailsDate: symptomsVM.getCurrentFormattedDateTime(),
                                    details: symptom,
                                    isFromPatient: "1"
                                )
                                savingList.append(item)
                            }
                        }

                        if !savingList.isEmpty {
                      

                            viewModel.triggerSymptomConfirmation(with: savingList)
                        }

                    }


                    
                    
                    
//                    sendSymptoms(savingList: )
                    
                    
                    
//                 SYMPTOMS       SYMPTOMS       SYMPTOMS       SYMPTOMS       SYMPTOMS       SYMPTOMS
                    
        
                    
               
                    
                    
                    
          
                    
                } else {
                    print("Error: Could not parse the expected structure in the response.")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
       
        task.resume()
    }
    
    
    
    
    
    
    
    
    

    
    func saveIntake(selectedFoodId: Int, fluidLevel: String) async {
        let currentDate = ISO8601DateFormatter().string(from: Date())
        let body = FoodIntakeRequest(
            givenQuanitityInGram: 0,
            uhid: uhid,
            foodId: selectedFoodId,
            pmId: 0,
            givenFoodQuantity: Double(fluidLevel) ?? 0.0,
            givenFoodDate: currentDate,
            givenFoodUnitID: 27,
            recommendedUserID: 0,
            jsonData: "",
            fromDate: currentDate,
            isGiven: 0,
            entryType: "N",
            isFrom: 0,
            dietID: 0,
            userID: 0
        )
        
        print(body)
        
        do {
            let result = try await APIService.shared.postRawData(
                toURL: baseURL7096 + foodIntake,
                body: body
            )
            DispatchQueue.main.async{
                viewModel.triggerFluidSuccess()}
            print("API Success:", result)
        } catch {
            print("Error sending food intake:", error)
        }

        
    }
    
    
    
    
    
    
    
    
    
    

    
    func addVitals() async {
        var body = [
            "vmValueBPSys": vitalsVM.vmValueBPSys,
            "vmValueBPDias": vitalsVM.vmValueBPDias,
            "vmValueSPO2": vitalsVM.vmValueSPO2,
            "vmValueRespiratoryRate": vitalsVM.vmValueRespiratoryRate,
            "vmValueHeartRate": vitalsVM.vmValueHeartRate,
            "vmValuePulse": vitalsVM.vmValuePulse,
            "vmValueRbs": vitalsVM.vmValueRbs,
            "vmValueTemperature": vitalsVM.vmValueTemperature,
              "uhid": uhid,
              "userId": "664",
            "vitalDate": vitalsVM.myCurrentDate(Date()),
            "vitalTime": vitalsVM.myCurrentTime(Date()),
              "clientId": clientID
        ]
        
        
        print(body)
        
        do {
            let result = try await APIService.shared.postRawData(toURL: baseURL7082 + "api/PatientVital/InsertPatientVital", body: body)
            print(result)
            Task{
                DispatchQueue.main.async{
                    viewModel.triggerVitalsSuccess()
                }

                await vitalsVM.getVitals()
            }


        } catch {
            print("❌ Error Fetching Vitals:", error)
        }
    }
    
    
    
    
}



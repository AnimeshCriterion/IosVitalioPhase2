//
//  DashboardViewModal.swift
//  vitalio_native
//
//  Created by HID-18 on 11/04/25.
//

import Foundation


 class DashboardViewModal : ObservableObject {
    @Published var isDrawerOpen = false

     
     
     @Published  var showVoiceAssistant = false
     @Published  var lastTextRecieved = false
     
     
     
    func  hidePage(){
  
        if(lastTextRecieved == true){
            self.showVoiceAssistant = false
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                self.showVoiceAssistant = false
            }
        }
    
     }

     @Published var showSuccess: Bool = false
     @Published var showVitalSuccess: Bool = false
     @Published var showFluidSuccess: Bool = false
     
     func triggerSuccess() {
         showSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showSuccess = false
            }
        }    
     func triggerVitalsSuccess() {
         showVitalSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.showVitalSuccess = false
            }
        }    
     func triggerFluidSuccess() {
         showFluidSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.showFluidSuccess = false
            }
        }
     
     
     
     @Published var showConfirmationSheet = false
     @Published var pendingSymptoms: [SavingList] = []

     func triggerSymptomConfirmation(with symptoms: [SavingList]) {
         if !symptoms.isEmpty {
             DispatchQueue.main.async {
                 self.pendingSymptoms = symptoms
                 self.showConfirmationSheet = true}
         }
     }

     func confirmSymptoms() {
         DispatchQueue.main.async {
             self.sendSymptoms(savingList:   self.pendingSymptoms)
             self.showConfirmationSheet = false
             self.pendingSymptoms = []
         }
     }
     func sendSymptoms(savingList: [SavingList]) {
         

          let encodedSymptoms = SymptomsViewModal().getEncodedSymptomParam(savingList)
          let baseURL = baseURL7082 + "api/PatientIPDPrescription/InsertSymtoms"
          let fullURLString = "\(baseURL)?uhID=UHID01235&userID=0&doctorId=0&jsonSymtoms=\(encodedSymptoms)&clientID=\(clientID)"

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
          }
         DispatchQueue.main.async {
             self.triggerSuccess()
             SymptomsViewModal().savingList = []

         }
          task.resume()
      }
    
     
}

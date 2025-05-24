//
//  DietViewmodal.swift
//  vitalio_native
//
//  Created by HID-18 on 23/04/25.
//

import Foundation

class DietViewModel : ObservableObject {
    @Published var uniqueTimes: [String] = []
    @Published var foodItems: [DietFoodItem] = []
    @Published var loading : Bool = false
    
    

    
    func  getDietIntake(time : String) async{
        DispatchQueue.main.async {
            self.loading = true
        }
      do {
          let result = try await APIService.shared.fetchRawData(
              fromURL: baseURL7096 + "api/FoodIntake/GetFoodIntake",
              parameters: ["UhID": "\(UserDefaultsManager.shared.getUserData()?.uhID ?? "" )", "entryType":"D", "fromDate" : time]
          )

          let jsonData = try JSONSerialization.data(withJSONObject: result)
          print(jsonData)
          let decodedData = try JSONDecoder().decode(DietAllresponse.self, from: jsonData)
          print(decodedData)
          DispatchQueue.main.async {
              self.foodItems = decodedData.foodIntakeList
          }
          
      }catch {
          DispatchQueue.main.async {
              self.foodItems = []
          }
      }
        DispatchQueue.main.async {
            self.loading = false
        }
    }
    func saveFoodInntake(dietId : Int)async{

            let currentTime = getCurrentFormattedTime()
            let uhid = "\(UserDefaultsManager.shared.getUserData()?.uhID ?? "")"
            let userId = "8"

            guard let givenAtEncoded = currentTime.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Failed to encode time")
                return
            }

            let urlString = baseURL7096+"api/FoodIntake/IntakeByDietID?Uhid=\(uhid)&userID=\(userId)&dietID=\(dietId)&givenAt=\(givenAtEncoded)"

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let jsonString = String(data: prettyData, encoding: .utf8) {
                    print("Formatted JSON Response:\n\(jsonString)")
                }
            } catch {
                print("Error during API call:", error)
            
        }
        
        await getDietIntake(time: getCurrentDateString())
    }
    
    
    
    func getCurrentFormattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: Date())
    }

    
}

func getCurrentDateString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: Date())
}



// https://api.medvantage.tech:7096/api/FoodIntake/GetFoodIntake?Uhid=UHID01235&entryType=D&fromDate=2025-04-23

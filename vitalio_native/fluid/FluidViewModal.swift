
import Foundation
import SwiftUI

class FluidaViewModal  : ObservableObject {
    @Published  var isIntakeSelected = true
    @Published var selectedGlassSize: Int = 150
    @Published var selectedDrink: String = "Water"
    @Published var selectedFoodId: Int = 0
    @Published var color: Color = .white
    @Published var containerImage: String = "beverage"
    @Published var imageOuter: String = "beverageoutline"
    @Published var imageOutLastLayer: String = ""
    @Published var fluidLevel: Int = 50
    @Published var fluidList: [DrinkItemViewModel] = []
    @Published var outputList: [OutputRecord] = []
    @Published var saveLoading : Bool = false
    @Published var isOutputLoading : Bool = false
    @Published var showOutput: Bool = false
    @Published var showIntake: Bool = false
    @Published var isLoading: Bool = false
    
    
    
    func intakeSuccess() {
        showIntake = true

           // Auto-dismiss after 2 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.showIntake = false
           }
       }
        func outputSuccess() {
            showOutput = true

           // Auto-dismiss after 2 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               self.showOutput = false
           }
       }
    
    

//    let uhid =  UserDefaultsManager.shared.getUHID() ?? ""

    func getIcon(for foodID: Int) -> String? {
        return staticDrinks.first(where: { $0.foodID == foodID })?.icon
    }
              func getOuter(for foodID: Int) -> String? {
            return staticDrinks.first(where: { $0.foodID == foodID })?.outerImage
    }
        func getContainerImage(for foodID: Int) -> String? {
            return staticDrinks.first(where: { $0.foodID == foodID })?.containerImage
    }
    func getColor(for foodID: Int) -> Color? {
        return staticDrinks.first(where: { $0.foodID == foodID })?.color
    }

    
    func getBarQuantity(for foodID: Int) -> Double? {
        return Double(fluidList.first(where: { $0.foodID == foodID })?.quantity ?? "0")
        }
    
    
    let staticDrinks: [(foodID: Int, icon: String, containerImage: String, outerImage: String, color: Color)] = [
        (97694, "WaterBtn", "water", "wateroutline", .waterBlue),
        (66, "JuiceBtn", "Juice", "juiceoutline", .orange),
        (76, "MilkBtn", "milk", "milkoutline", .white),
        (114973, "TeaBtn", "tea", "teaoutline", .chaiColor),
        (168, "CoffeeBtn", "coffee", "coffeeoutlin2", .brown)
    ]

    
    @Published var  glassSizes = [150, 250, 300, 400]
    
    
    func saveIntake() async {
        
        DispatchQueue.main.async{
            self.saveLoading = true
        }
        
        print(String(Double(fluidLevel))+" is Fluid Level")
        
        let currentDate = ISO8601DateFormatter().string(from: Date())
        
        let body = FoodIntakeRequest(
            givenQuanitityInGram: 0,
            uhid: UserDefaultsManager.shared.getUHID() ?? "",
            foodId: selectedFoodId,
            pmId: 0,
            givenFoodQuantity: Double(fluidLevel),
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
            print("API Success:", result)
            await getFoodList(hours: "24")
        } catch {
            print("Error sending food intake:", error)
        }
        DispatchQueue.main.async{
            self.saveLoading = false
            self.intakeSuccess()
            
        }
        
    }
    
    func getOutputList() async {
 
        do{
            let params = ["UHID": UserDefaultsManager.shared.getUHID() ?? ""]
            let response = try await APIService.shared.fetchRawData(fromURL: baseURL7082 + getpatientOutputList, parameters: params)
            print(response)
        } catch {
            
        }

    }
    
    func saveOutput (fluidLevel : String) async {
        DispatchQueue.main.async{
            self.isOutputLoading = true
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current // or set a specific one
        let formattedDate = formatter.string(from: Date())


        let body =
        ["clientId": clientID, "id": "0", "uhid": UserDefaultsManager.shared.getUHID() ?? "", "outputDate": formattedDate, "outputTypeID": "51", "pmID": "0", "quantity": fluidLevel, "unitID": "1", "userID": "0"]
        print(body)

        do {
            let result = try await APIService.shared.postRawData(
                toURL: baseURL7082 + savePatientOutput,
                body: body
            )
            print("API Success:", result)
        } catch {
            print("Error sending food intake:", error)
        }
        
        DispatchQueue.main.async{
            self.isOutputLoading = false
            self.outputSuccess()
        }
        await outputByDate(hours: "24")
        
    }
    
    
    
    func getFoodHistoryList() async{
        
        do{
            let params = ["Uhid": UserDefaultsManager.shared.getUHID() ?? "","intervalTimeInHour": "24"]
            let response = try await APIService.shared.fetchRawData(fromURL: baseURL7096 + getFoodAssignList , parameters: params)
            print(response)
        } catch {

        }
    }
    
    func outputByDate(hours: String) async {
        print ("working")
        do{
            let params = ["Uhid": UserDefaultsManager.shared.getUHID() ?? "",
                          "intervalTimeInHour": hours
//                          "fromDate": "2025-04-12", "toDate": "2025-04-13"
            ]
            let response = try await APIService.shared.fetchRawData(fromURL: baseURL7082 + getpatientOutputList, parameters: params)
            
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
            let decoded = try JSONDecoder().decode(OutputResponse.self, from: jsonData)

            outputList = decoded.responseValue
            
            print(decoded)
            print(response)
        } catch {
            
        }
    }
    
    
    func getFoodList(hours: String?) async {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let params = ["Uhid": UserDefaultsManager.shared.getUHID() ?? "", "intervalTimeInHour": hours ?? "24"]
            
            let data = try await APIService.shared.fetchRawData(
                fromURL: baseURL7096 + foodaAssignList,
                parameters: params
            )
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let decoded = try JSONDecoder().decode(FoodResponse.self, from: jsonData)
            DispatchQueue.main.async {
                self.fluidList = decoded.responseValue
            }
     
            print(decoded)
        } catch {
            print("Error decoding food list: \(error)")
            
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
        
    }

    @Published var fluidSummaryList: [FluidSummaryItem] = [] // for weekly/monthly

    func fluidSummaryByDateRange(fromDate: String, toDate : String) async {
        do {
            let params = ["Uhid": UserDefaultsManager.shared.getUHID() ?? "", "fromDate": fromDate , "toDate" : toDate]
            let data = try await APIService.shared.fetchRawData(
                fromURL: baseURL7096 + FluidSummaryByDateRange,
                parameters: params
            )
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            let decoded = try JSONDecoder().decode(FluidSummaryResponse.self, from: jsonData)
            
            DispatchQueue.main.async {
                self.fluidSummaryList = decoded.responseValue
            }
            print(decoded)
        } catch {
            print("Error decoding fluid summary list: \(error)")
            DispatchQueue.main.async {
                self.fluidSummaryList = []
            }
        }
    }




    
}

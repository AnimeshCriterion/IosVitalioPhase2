import Foundation

// MARK: - Response Model
struct DietAllresponse: Codable {
    let status: Int
    let message: String
    let foodIntakeList: [DietFoodItem]
}

// MARK: - Single Food Item Model
struct DietFoodItem: Codable, Identifiable {
    var id: Int { dietId }
    
    let dietId: Int
    let foodId: Int
    let foodQty: Double
    let foodUnitID: Int
    let foodName: String
    let unitName: String
    let foodEntryDate: String
    let foodEntryTime: String
    let recommendedUser: String
    let entryUserId: Int
    let givenUser: String
    let isGiven: Int
    let timeSlot: String?
    let foodGivenAt: String
    let translation: String
}

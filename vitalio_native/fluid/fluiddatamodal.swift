//
//  fluiddatamodal.swift
//  vitalio_native
//
//  Created by HID-18 on 16/04/25.
//

import Foundation

// Model for the response
struct FoodListResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [FoodItem]
}

// Model for each food item
struct FoodItem: Codable {
    let id: Int
    let pmID: Int
    let outputID: Int
    let quantity: Double
    let unitID: Int
    let outputDate: String
    let userID: Int
    let userName: String
    let outputType: String
    let unitName: String
    let outputDateFormat: String
    let outputTimeFormat: String
    let colour: String
}


struct FoodIntakeRequest: Codable {
    let givenQuanitityInGram: Int
    let uhid: String
    let foodId: Int
    let pmId: Int
    let givenFoodQuantity: Double
    let givenFoodDate: String
    let givenFoodUnitID: Int
    let recommendedUserID: Int
    let jsonData: String
    let fromDate: String
    let isGiven: Int
    let entryType: String
    let isFrom: Int
    let dietID: Int
    let userID: Int
}


struct FoodResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [DrinkItemViewModel]
}

struct DrinkItemViewModel: Identifiable, Codable {
    var id: Int { foodID }
    let foodID: Int
    var foodName: String
    let quantity: String 
    let givenFoodDate: String
//    let icon: String
//    let containerImage: String
//    let outerImage: String
}





struct OutputRecord: Identifiable , Decodable {
    let id: Int
    let outputDate: String
    let outputDateFormat: String
    let outputID: Int
    let outputTimeFormat: String
    let outputType: String
    let pmID: Int
    let quantity: Int
    let unitID: Int
    var unitName: String
    let userID: Int
    let userName: String
    let colour: String
}

struct OutputResponse: Decodable {
    let status: Int
    let responseValue: [OutputRecord]
    let message: String
}

struct FluidSummaryItem: Identifiable, Decodable {
    let id = UUID()
    let foodQuantity: String
    let foodId: Int
    let givenFoodDate: String
    let assignedLimit: Double
}

struct FluidSummaryResponse: Decodable {
    let status: Int
    let message: String
    let responseValue: [FluidSummaryItem]
}

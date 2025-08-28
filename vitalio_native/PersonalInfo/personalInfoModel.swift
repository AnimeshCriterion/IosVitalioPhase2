//
//  personalInfoModel.swift
//  vitalio_native
//
//  Created by Test on 12/08/25.
//

struct ChronicDisease: Identifiable, Codable, Hashable {
    let id: Int
    let problemName: String
    let problemTypeID: Int
}
struct Country: Codable, Identifiable, CustomStringConvertible {
    let id: Int
    let countryName: String
    let status: Bool
    let userId: Int
    let countryCode: String

    var description: String { countryName } // for display in dropdown
}

struct StateResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [States]
}

struct States: Codable, Identifiable, CustomStringConvertible {
    let id: Int
    let countryId: Int
    let stateName: String
    let status: Bool
    let userId: Int
    let countryName: String

    
    var description: String { stateName }
}
struct CityResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [City]
}

struct City: Codable, Identifiable, CustomStringConvertible {
    let id: Int
    let name: String
    let stateId: Int
    let stateName: String
    let status: Bool
    let userId: Int

    var description: String {
        name
    }
}
struct BloodGroup: Identifiable, CustomStringConvertible {
    let id: String  // Unique identifier (e.g., "A+")
    var description: String { id }  // How it's displayed in UI
}

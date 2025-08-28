//
//  vitaldatamodal.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/15/25.
//

import Foundation


struct VitalResponse: Codable ,Equatable  {
    let status: Int
    let message: String
    let responseValue: VitalData
}

struct VitalData: Codable ,Equatable {
    let lastVital: [Vital]
    let allVitalAvg: [VitalAverage]
}

struct Vital: Codable ,Equatable , Identifiable{
    let uhid: String
    let pmId: Int
    let vitalID: Int
    var vitalName: String
    let vitalValue: Double
    var unit: String
    let vitalDateTime: String
    let userId: Int
    let rowId: Int
    
    // Use a unique identifier, e.g., rowId
    var id: UUID { UUID() } // New UUID every time it's accessed

}

struct VitalAverage: Codable ,Equatable{
    let vmId: Int
    let pmId: Int
    let avgVmValue: Double
}



/// vital history data modal



import Foundation

struct VitalHistoryResponse: Decodable {
    let status: Int
    let message: String
    let responseValue: VitalResponseValue
}

struct VitalResponseValue: Decodable {
    let patientGraph: [PatientGraph]
    let patientVital: [PatientVital]
    let vitalsDate: [VitalsDate]
}

struct PatientGraph: Decodable {
    let vitalDateTime: String
    let vitalDetails: String
    
    var decodedVitalDetails: [VitalDetail]? {
        guard let data = vitalDetails.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([VitalDetail].self, from: data)
    }
}

struct VitalDetail: Decodable {
    let vitalid: Int
    let vitalName: String
    let vitalValue: Double
    let vitaldate: String
}

struct PatientVital: Decodable {
    let id: Int
    let vitalName: String
    let vitalIcon: String
}

struct VitalsDate: Decodable {
    let vitalDate: String
}

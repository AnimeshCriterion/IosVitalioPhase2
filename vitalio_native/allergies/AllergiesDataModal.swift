//
//  AllergiesDataModal.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/24/25.
//

import Foundation

// MARK: - Root Response
struct AllergiesResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [AllergyRecord]
}

// MARK: - Allergy Record
struct AllergyRecord: Codable, Identifiable {
    var id: Int { subCategoryParameterIdAssignId }
    
    let subCategoryParameterIdAssignId: Int
    let parameterValueId: Int
    let parameterStatement: String
    let parameterValue: String
    let parameterName: String
    let date: String
    let jsonHistory: String

    var decodedHistory: [AllergyDetail]? {
        guard let data = jsonHistory.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([AllergyDetail].self, from: data)
    }
}

// MARK: - Allergy Detail
struct AllergyDetail: Codable, Identifiable {
    let rowId: Int
    let remark: String
    let substance: String
    let severityLevel: String
    let isFromPatient: Int

    var id: Int { rowId }
}




struct ParameterResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [ParameterItem]
}

struct ParameterItem: Identifiable, Codable, Hashable, CustomStringConvertible {
    var id: Int { parameterId } // `id` needed for SwiftUI List/Picker

    let subCategoryId: Int
    let subCategoryName: String
    let categoryId: Int
    let categoryName: String
    let remark: String?
    let createdDate: String
    let userId: Int
    let historyParameterAssignId: Int
    let parameterId: Int
    let parameterName: String
    let inspectedAs: Int
    let dataType: String
    let isTaken: Int
    let clinicalDataType: Int
    let isDateShow: Int
    let apiUrl: String
    let status: [StatusItem]
    
    var description: String { parameterName }
}

struct StatusItem: Codable, Hashable {
    let id: Int
    let remark: String
}

//
//  SymptomsDataModel.swift
//  vitalio_native
//
//  Created by HID-18 on 21/04/25.
//

import Foundation

struct ProblemResponse: Codable {
    let responseCode: Int
    let responseMessage: String
    let responseValue: [Problem]
}

struct Problem: Codable {
    let problemId: Int
    let problemName: String
    let isVisible: Int
    let displayIcon: String
    let translation: String?
}

import Foundation

struct OtherSymptomModel: Codable {
    let responseCode: Int
    let responseMessage: String
    let responseValue: [OtherSymptom]
}

struct OtherSymptom: Codable, Identifiable {
    let problemId: Int
    let problemName: String
    let isVisible: Int

    var id: Int { problemId }
}

struct SavingList: Codable, Identifiable {
    let detailID: String
    let detailsDate: String
    let details: String
    let isFromPatient: String

    var id: String { detailID } // To conform to Identifiable
}

struct StillHaveSymptomsResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [StillHaveSymptom]
}

struct StillHaveSymptom: Codable, Identifiable {
    let id = UUID()
    let uhID: String
    let pmID: Int
    let pdmID: Int
    let detailID: Int
    let details: String
    let detailsDate: String
    let isProvisionalDiagnosis: Int

    private enum CodingKeys: String, CodingKey {
        case uhID, pmID, pdmID, detailID, details, detailsDate, isProvisionalDiagnosis
    }
}


struct SymptomsHistoryAPIResponse: Codable {
    let message: String
    let responseValue: [SymptomsHistoryItem]
    let status: Int
}

struct SymptomsHistoryItem: Identifiable, Codable {
    var id: Int { detailID } // Use detailID as the unique identifier
    let detailID: Int
    let details: String
    let detailsDate: String?
    let isProvisionalDiagnosis: Int
    let pdmID: Int
    let pmID: Int
    let uhID: String
}


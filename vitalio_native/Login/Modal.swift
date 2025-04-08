//
//  Modal.swift
//  vitalio_native
//
//  Created by HID-18 on 01/04/25.
//

import Foundation


import Foundation

struct PatientDetailDataModal: Codable {
    let status: Int
    let message: String
    let responseValue: [Patient]
}

struct PatientDetailDataModal2: Codable {
}

struct Patient: Codable {
    let pid: String
    let patientName: String
    let registrationDate: String
    let address: String
    let age: String
    let gender: String
    let mobileNo: String
    let uhID: String
    let departmentName: String
    let profileUrl: String?

    enum CodingKeys: String, CodingKey {
        case pid, patientName, registrationDate, address, age, gender, mobileNo, uhID, departmentName, profileUrl
    }
}

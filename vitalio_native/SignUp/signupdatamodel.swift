//
//  signupdatamodel.swift
//  vitalio_native
//
//  Created by HID-18 on 21/05/25.
//

import Foundation


struct PatientDetail: Identifiable, Codable, Equatable {
    var id: String { detailID }
    let detailID: String
    let detailsDate: String
    let details: String
    let isFromPatient: String
}

enum FamilyMember: String, CaseIterable, Identifiable, Hashable {
    case mother = "Mother"
    case father = "Father"
    case brother = "Brother"
    case sister = "Sister"
    case grandParent = "Grand Parent"

    var id: String { rawValue }
}

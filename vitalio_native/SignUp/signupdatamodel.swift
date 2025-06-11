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


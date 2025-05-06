//
//  ReportDataModel.swift
//  vitalio_native
//
//  Created by HID-18 on 24/04/25.
//

import Foundation


struct AllReportResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [AllReport]
}

struct AllReport: Codable, Identifiable {
    let id: Int
    let pmId: Int
    let url: String
    let category: String
    let fileType: String
    let fileName: String
    let filePath: String?
    let subCategory: String?
    let remark: String
    let dateTime: String
    let createdDate: String
    let status: Int
    let userId: Int
    let clientID: Int
    let uhid: String
}

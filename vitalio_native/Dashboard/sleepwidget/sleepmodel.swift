////
////  sleepmodel.swift
////  vitalio_native
////
////  Created by HID-18 on 07/08/25.
////
//
//import SwiftUI
//
//
//struct SleepDataResponse: Codable {
//    let data: SleepData
//}
//
//struct SleepData: Codable {
//    let metric_data: [Metric]
//}
//
//struct Metric: Codable {
//    let type: String
//    let object: SleepObject?
//}
//
//struct SleepObject: Codable {
//    let title: String?
//    let score: Int?
//    let details: SleepDetails?
//}
//
//struct SleepDetails: Codable {
//    let quick_metrics: [QuickMetric]
//    let sleep_stages: [SleepStage]
//}
//
//struct QuickMetric: Codable {
//    let title: String
//    let display_text: String
//    let type: String
//}
//
//struct SleepStage: Codable {
//    let title: String
//    let type: String
//    let percentage: Double
//}
//

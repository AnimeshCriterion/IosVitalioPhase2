////
////  SleepTrackerViewModel.swift
////  vitalio_native
////
////  Created by HID-18 on 07/08/25.
////
//
//import SwiftUI
//
//class SleepTrackerViewModel: ObservableObject {
//    @Published var sleepDuration: (hours: Int, minutes: Int) = (0, 0)
//    
//    func loadMockSleepData() -> SleepObject? {
//        guard let url = Bundle.main.url(forResource: "mockData", withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let decoded = try? JSONDecoder().decode(SleepDataResponse.self, from: data)
//        else {
//            return nil
//        }
//
//        // Find the "sleep" type metric
//        return decoded.data.metric_data.first(where: { $0.type == "sleep" })?.object
//    }
//
//}

//
//  Internet.swift
//  vitalio_native
//
//  Created by HID-18 on 30/05/25.
//

import Network
import Foundation

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    private init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
//                showGlobalError(message:"Internet is connected")
                print("Internet is connected")
            } else {
                showGlobalError(message:"Internet is not connected")
                print("Internet is not connected")
            }
        }
        monitor.start(queue: queue)
    }
}

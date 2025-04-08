//
//  network.swift
//  vitalio_native
//
//  Created by HID-18 on 25/03/25.
//

import SwiftUI

enum NetworkError: Error, LocalizedError {
    case badUrl
    case badResponse
    case badStatus(Int)
    case failedToDecodeResponse
    case timeout
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .badUrl:
            return "Invalid URL"
        case .badResponse:
            return "Invalid response from the server"
        case .badStatus(let code):
            return "Received HTTP status code: \(code)"
        case .failedToDecodeResponse:
            return "Failed to decode the response"
        case .timeout:
            return "The request timed out"
        case .unknownError(let message):
            return message
        }
    }
}

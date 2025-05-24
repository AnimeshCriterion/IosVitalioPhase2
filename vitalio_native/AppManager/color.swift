//
//  color.swift
//  Vitalio
//
//  Created by HID-18 on 15/03/25.
//

import SwiftUI

extension Color {
    static let customBackground = Color(hex: "#F5F8FC")
    static let customBackground2 = Color(hex: "#F7F9FB")
    static let customBackgroundDark = Color(hex: "#141415")
    static let customBackgroundDark2 = Color(hex: "#252527")
    static let waterBlue = Color(hex: "#98BEFF")
    static let chaiColor = Color(hex: "#d99d73")
    static let primaryBlue = Color(hex: "#1564ED")
    static let textGrey = Color(hex: "#5F6471")
    static let textGrey2 = Color(hex: "#202529")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (No Alpha)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

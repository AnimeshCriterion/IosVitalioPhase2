//
//  Darkmode.swift
//  vitalio_native
//
//  Created by HID-18 on 26/03/25.
//

import SwiftUI


class ThemeManager: ObservableObject {
    @Published var selectedAppearance: Appearance
    init() {
        let storedValue = UserDefaults.standard.string(forKey: "appearance") ?? Appearance.system.rawValue
        self.selectedAppearance = Appearance(rawValue: storedValue) ?? .system
    }
    
    var colorScheme: ColorScheme? {
        switch selectedAppearance {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    
    func updateAppearance(_ newAppearance: Appearance) {
        selectedAppearance = newAppearance
        UserDefaults.standard.setValue(newAppearance.rawValue, forKey: "appearance")
    }
}



enum Appearance: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
}
struct Darkmode: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            Text("Select Appearance")
                .font(.headline)
                .padding()
            
            Picker("Appearance", selection: Binding(
                get: { themeManager.selectedAppearance },
                set: { themeManager.updateAppearance($0) }
            )) {
                ForEach(Appearance.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Spacer()
        }
        .preferredColorScheme(themeManager.colorScheme) // Apply theme globally
    }
}



#Preview {
    Darkmode()
        .environmentObject(ThemeManager())
}

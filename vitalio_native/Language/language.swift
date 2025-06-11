import SwiftUI
import Foundation

// MARK: - LocalizationManager

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String = UserDefaults.standard.string(forKey: "appLanguage") ?? Locale.preferredLanguages.first ?? "en"
    
    private var bundle: Bundle?

    private init() {
        setLanguage(currentLanguage)
    }

    func setLanguage(_ language: String) {
        UserDefaults.standard.set(language, forKey: "appLanguage")
        currentLanguage = language

        if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
            bundle = Bundle(path: path)
        } else {
            bundle = Bundle.main
        }

        objectWillChange.send() // Refresh SwiftUI views
    }

    func localizedString(for key: String) -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}

// MARK: - LocalizedText View

struct LocalizedText: View {
    var key: String
    @ObservedObject var localizer = LocalizationManager.shared

    var body: some View {
        Text(localizer.localizedString(for: key))
    }
}

// MARK: - Language Picker View

struct LanguageSettingsView: View {
    @ObservedObject var localizer = LocalizationManager.shared

    var body: some View {
        VStack(spacing: 16) {
            Text("Select Language").font(.headline)

            Button("English") {
                localizer.setLanguage("en")
            }

            Button("हिन्दी") {
                localizer.setLanguage("hi")
            }
        }
        .padding()
    }
}


struct Language: View {
    var body: some View {
        VStack(spacing: 30) {
            LocalizedText(key: "test 1")
                .font(.largeTitle)
                .padding()

            LanguageSettingsView()
        }
    }
}


//
//  LocalData.swift
//  Vitalio
//
//  Created by HID-18 on 12/03/25.
//

import Foundation

final class UserDefaultsManager {
    
    // ✅ Singleton Instance
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {} // Prevent direct initialization
    
    func set<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func get<T>(forKey key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    func clearAll() {
        defaults.dictionaryRepresentation().keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}


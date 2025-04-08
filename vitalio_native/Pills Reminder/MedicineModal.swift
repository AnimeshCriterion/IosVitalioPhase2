//
//  MedicineModal.swift
//  vitalio_native
//
//  Created by HID-18 on 07/04/25.
//

import Foundation
// Root model
struct MedicationResponse: Codable {
    let status: Int
    let message: String
    let responseValue: ResponseValue
}

// Response value model
struct ResponseValue: Codable {
    let date: [DateItem]
    let drugName: [DrugName]
    let medicationNameAndDate: [Medication]
    let dosageForm: [DosageForm]
}

// Individual date entry
struct DateItem: Codable {
    let date: String
}


struct Medication: Codable, Identifiable {
    var id: Int { prescriptionRowID ?? UUID().hashValue }

    let prescriptionRowID: Int?
    let pmId: Int?
    let date: String?
    let drugName: String
    let dosageForm: String
    let frequency: String?
    let doseFrequency: String?
    let remark: String?
    let medicineId: Int?
    let drugId: Int?
    let jsonTime: String?
    let translation: String?
    let createdDate: String?

    // Computed property to decode `jsonTime` string
    var decodedJsonTime: [JsonTimeItem] {
        guard let jsonTime = jsonTime,
              let data = jsonTime.data(using: .utf8) else { return [] }

        do {
            return try JSONDecoder().decode([JsonTimeItem].self, from: data)
        } catch {
            print("❌ Failed to decode jsonTime: \(error)")
            return []
        }
    }
}


// Dosage form entry
struct DosageForm: Codable {
    let dosageForm: String
}

// ✅ Corrected DrugName struct
struct DrugName: Codable {
    let drugName: String
    let dosageForm: String
    let createdDate: String
}

struct JsonTimeItem: Codable {
    let time: String
    let durationType: String
    let icon: String
    let intakeTime: String
}

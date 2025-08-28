//
//  reminder_viewModal.swift
//  vitalio_native
//
//  Created by Test on 01/08/25.
//
import Foundation

class ReminderViewModel : ObservableObject {
    
    let tabs = ["Upcoming", "Past", "Missed"]
    
    @Published var selectedTabs : String = "Upcoming"
    @Published var reminders: [Reminder] = [
           Reminder(title: "Vitamin D, 10 mg", detail: "1 Tablet, after meal", date: Date(), isCompleted: false),
           Reminder(title: "Paracetamol", detail: "500mg, before meal", date: Date(), isCompleted: false)
       ]
}


struct Reminder: Identifiable {
    let id = UUID()
    var title: String
    var detail: String
    var date: Date
    var isCompleted: Bool
}

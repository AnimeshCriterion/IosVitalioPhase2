//
//  notification_view.swift
//  vitalio_native
//
//  Created by Baqar on 28/07/25.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var route: Routing
    @State var reminders: [MedicationReminder] = [
        MedicationReminder(name: "Amoxicillin", time: "09:00 AM", pills: "1 Pills", note: "After Dinner", isChecked: true),
        MedicationReminder(name: "Aspirin", time: "08:00 PM", pills: "2 Pills", note: "Before Dinner", isChecked: false),
        MedicationReminder(name: "NexGard Chewables", time: "", pills: "1 Pills", note: "Any Time", isChecked: true)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // Top bar
            HStack {
                Button(action: {
                    // Back action
                    route.back()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }
                
                Text("Notifications")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    // Clear all action
                }) {
                    Text("Clear All")
                        .font(.callout)
                        .foregroundColor(.blue)
                        .padding(.trailing)
                }
            }
            .padding(.top)

            // Reminder List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(reminders.indices, id: \.self) { index in
                        ReminderCard(reminder: reminders[index])
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden()
        .padding(.bottom)
        .background(Color.white)
    }
}

struct ReminderCard: View {
    let reminder: MedicationReminder

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: reminder.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(.gray)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.name)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 6) {
                    if !reminder.time.isEmpty {
                        Text(reminder.time)
                    }
                    Text(reminder.pills)
                    Text(reminder.note)
                }
                .font(.footnote)
                .foregroundColor(.gray.opacity(0.7))
            }

            Spacer()

            Image(systemName: "checkmark.circle")
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct MedicationReminder {
    var name: String
    var time: String
    var pills: String
    var note: String
    var isChecked: Bool
}

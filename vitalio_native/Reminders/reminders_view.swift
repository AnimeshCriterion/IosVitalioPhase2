//
//  reminders_view.swift
//  vitalio_native
//
//  Created by Test on 01/08/25.
//
import SwiftUI

struct ReminderTabView: View {
    @StateObject var viewModel = ReminderViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Tab buttons section
                HStack(spacing: 0) {
                    ForEach(viewModel.tabs, id: \.self) { tab in
                        tabButton(for: tab)
                    }
                }
                .padding(4)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(height: 50)
                
                // CRITICAL: List must be inside NavigationView for swipe actions to work
                List {
                    ForEach(viewModel.reminders, id: \.id) { reminder in
                        reminderRowSimple(for: reminder)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    print("✅ Mark as done: \(reminder.title)")
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    print("🔔 Remind later: \(reminder.title)")
                                } label: {
                                    Label("Later", systemImage: "bell.badge")
                                }
                                .tint(.orange)
                                
                                Button {
                                    print("😴 Snooze: \(reminder.title)")
                                } label: {
                                    Label("Snooze", systemImage: "zzz")
                                }
                                .tint(.blue)
                            }
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }

    @ViewBuilder
    private func tabButton(for tab: String) -> some View {
        Button(action: {
            viewModel.selectedTabs = tab
        }) {
            Text(tab)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(viewModel.selectedTabs == tab ? .white : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(
                    viewModel.selectedTabs == tab ? Color.blue : Color.clear
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // Simplified row for testing
    @ViewBuilder
    private func reminderRowSimple(for reminder: Reminder) -> some View {
        HStack {
            Image(systemName: "pill")
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(reminder.title)
                    .font(.headline)
                Text(reminder.detail)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8)).padding(.bottom, 8)
    }
}


#Preview {
    ReminderTabView()
}

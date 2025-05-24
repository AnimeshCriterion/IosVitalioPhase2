import SwiftUI

enum TimeFilter: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}


struct SymptomsHistory: View {
    @EnvironmentObject var viewmodel: SymptomsViewModal
    @State private var selectedDate = Date()
    @EnvironmentObject var themeManager: ThemeManager
       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }
    var body: some View {
        VStack {
            // MARK: - Filter Buttons
//            HStack(spacing: 8) {
//                ForEach(TimeFilter.allCases, id: \.self) { filter in
//                    Button(action: {
//                        viewmodel.selectedFilter = filter
//                        Task {
//                            await viewmodel.SymptomsHistory()
//                        }
//                    }) {
//                        Text(filter.rawValue)
//                            .padding(.vertical, 8)
//                            .background(viewmodel.selectedFilter == filter ? Color.blue : Color.gray.opacity(0.2))
//                            .foregroundColor(viewmodel.selectedFilter == filter ? .white : .black)
//                            .cornerRadius(8)
//                    }
//                }
//            }
//            .padding()

            // MARK: - Date Selector
//            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
//                .datePickerStyle(.compact)
//                .padding(.horizontal)
//                .onChange(of: selectedDate) { newValue in
//                    Task {
//                        await viewmodel.SymptomsHistory()
//                    }
//                }

            Divider()

            // MARK: - Scrollable List
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewmodel.groupedSymptoms.keys.sorted(by: >), id: \.self) { date in
                        Text(viewmodel.customdate(from: date))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.leading, 16)
                            .padding(.top, 12)

                        ForEach(viewmodel.groupedSymptoms[date] ?? [], id: \.id) { symptom in
                            HStack(alignment: .top, spacing: 8) {
                                VStack {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 10, height: 10)
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.5))
                                        .frame(width: 2, height: 60)
                                }
                                .padding(.leading, 16)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(symptom.details)
                                        .font(.headline)
                                        .foregroundColor(isDarkMode ? .white : .black)

                                    if let dateStr = symptom.detailsDate {
                                        Text(dateStr)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(isDarkMode ? Color.customBackgroundDark2 : Color.white)
                                .cornerRadius(12)
                            }
                            .padding(8)
                        }
                    }
                }
                .padding(.bottom, 16)
            }
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            Task {
                let currentDate = Date()
                await viewmodel.SymptomsHistory()
                
            }
        }
    }
}

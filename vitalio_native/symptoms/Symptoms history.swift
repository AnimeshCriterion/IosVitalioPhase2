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

            List {
                ForEach(viewmodel.groupedSymptomsByDate.keys.sorted(), id: \.self) { dateKey in
                    Section(header: Text(dateKey)
                                .font(.headline)
                                .foregroundColor(isDarkMode ? .white : .black)
                                .padding(.leading, 16)
                                .padding(.top, 12)) {
                        ForEach(viewmodel.groupedSymptomsByDate[dateKey] ?? [], id: \.id) { symptom in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(symptom.details)
                                    .font(.headline)
                                    .foregroundColor(isDarkMode ? .white : .black)

                                // If you want to hide the time because date is already a header, skip this
                                // Text(viewmodel.formattedOnly(from: symptom.detailsDate ?? ""))
                                //     .font(.caption)
                                //     .foregroundColor(isDarkMode ? .white : .black)
                            }
                            .padding()
                            .background(isDarkMode ? Color.customBackgroundDark2 : Color.white)
                            .cornerRadius(12)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())


                .padding(.bottom, 16)
            
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            Task {
//                let currentDate = Date()
                await viewmodel.SymptomsHistory()
                
            }
        }
    }
    

}



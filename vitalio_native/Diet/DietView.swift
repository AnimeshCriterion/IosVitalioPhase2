//
//  Suppliment_checklist.swift
//  vitalio_native
//
//  Created by HID-18 on 04/04/25.
//



import SwiftUI

struct Diet: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel = DietViewModel()
    @EnvironmentObject var route: Routing
    @State private var selectedFormattedDate: String = "" // Will be in "yyyy-MM-dd"
    
    var isDarkMode : Bool {
        themeManager.colorScheme == .dark
    }
    
    var body: some View {
        VStack {
            CustomNavBarView(title: "Diet Checklist", isDarkMode: isDarkMode){
                route.back()
            }
            DateLabelView { formattedDate in
                selectedFormattedDate = formattedDate
                Task{
                    await viewModel.getDietIntake(time: selectedFormattedDate)
                }
                
            }
            SupplimentChecklist() .environmentObject(viewModel) // Inject the ViewModel
            Spacer()
        }
        .task {
            await viewModel.getDietIntake(time: getCurrentDateString())
        }
        .background(isDarkMode ? Color.customBackgroundDark2 : Color.customBackground)
            .navigationBarHidden(true)
    }
}

#Preview {
    Diet()
        .environmentObject(ThemeManager())
}

import SwiftUI

struct SupplimentChecklist: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject private var viewModel : DietViewModel
    
    private var isDark: Bool { themeManager.colorScheme == .dark }
    
    // ◉ Your eight static headings:
    private let columns = [
      "MID MORNING", "LUNCH", "EVENING TIME", "EARLY MORNING",
      "DINNER", "BREAKFAST", "BED TIME", "ALL DAY MEALS"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Diet for the day")
                .bold()
                .foregroundColor(isDark ? .white : .black)
                .padding(.leading, 20)
            
            if viewModel.loading == true {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else  if $viewModel.foodItems.isEmpty {
                Text("No Data found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // ─── Header Row ───────────────────────────────────
                        HStack(spacing: 0) {
                            Text("Food Intake")
                                .bold()
                                .frame(width: 150, alignment: .leading)
                                .foregroundColor(isDark ? .white : .black)
                            
                            ForEach(columns, id: \.self) { slot in
                                Text(slot)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .frame(width: 120)
                            }
                        }
                        .padding(.horizontal)
                        .background(isDark
                            ? Color.customBackgroundDark2
                            : Color.customBackground
                        )
                        
                        Divider().background(Color.white.opacity(0.5))
                        
                        // ─── Data Rows ───────────────────────────────────
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(spacing: 0) {
                                ForEach(viewModel.foodItems, id: \.dietId) { item in
                                    DietRowView(item: item, columns: columns, isDark: isDark)
                                    Divider().background(Color.white.opacity(0.2))
                                }
                            }
                        }

                    }
                }
            }
        }
        .padding(.vertical)
        .background(isDark
            ? Color.customBackgroundDark2.edgesIgnoringSafeArea(.all)
            : Color.customBackground.edgesIgnoringSafeArea(.all)
        )

    }
    
}
struct DietRowView: View {
    let item: DietFoodItem
    let columns: [String]
    let isDark: Bool
    @EnvironmentObject var viewModel : DietViewModel
    var body: some View {
        HStack(spacing: 0) {
            // ➤ Medicine name & translation
            VStack(alignment: .leading, spacing: 4) {
                Text(item.foodName)
                    .font(.headline)
                    .foregroundColor(isDark ? .white : .black)
                Text(item.translation)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(width: 150, alignment: .leading)
            .padding(.vertical, 8)

            // ➤ Render icon only for matched slot
            let itemSlot = item.foodGivenAt.uppercased()
            ForEach(columns, id: \.self) { slot in
                Group {
                    if slot == itemSlot {
                        Image(item.isGiven == 1 ? "taken" : "missed")
                            .frame(width:30)
                            .scaledToFit()
                    } else {
                        Text("–")
                            .foregroundColor(.gray)
                    }
                }
                .onTapGesture {
                    Task{
                        await viewModel.saveFoodInntake(dietId: item.dietId)
                    }
                
                }
                .frame(width: 120, height: 40)
            }
        }
        .background(isDark ? Color.customBackgroundDark : Color.white)
    }
}




// Medicine Data Model
struct Supplimnt: Identifiable {
    let id = UUID()
    let name: String
    let dosage: String
    let schedule: [String]
    
    var isHighlighted: Bool {
        return name == "Metoprolol" || name == "Atorvastatin" || name == "Ramipril" || name == "Warfarin"
    }
}

//// Preview
//struct MedicineScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        MedicineScheduleView(isDarkMode)
//            .environmentObject(ThemeManager())
//    }
//}
//





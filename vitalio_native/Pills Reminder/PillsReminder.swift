

import SwiftUI

struct PillsReminder: View {
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var pillsViewModal: PillsViewModal
    @State private var selectedFormattedDate: String = "" // Will be in "yyyy-MM-dd"
    var isDarkMode : Bool {
        themeManager.colorScheme == .dark
    }

    
    func getData(){
        Task{
            await pillsViewModal.getMedication()
        }

    }
    
    var body: some View {
        ZStack {
            VStack {
//                Button("Save/Submit") {
//                    
//                    pillsViewModal.triggerSuccess()
////                    withAnimation {
////                        showSuccess = true
////                        
////                    }
//                }
                CustomNavBarView(title: "Pills Timeline", isDarkMode: isDarkMode){
                    route.back()
                    
                }
                Spacer(minLength: 20)
                DateLabelView { formattedDate in
                    selectedFormattedDate = formattedDate
                }
                .padding(.leading,20)
                MedicineScheduleView(isDarkMode: isDarkMode,selectedDate: selectedFormattedDate)
                
                    .navigationBarHidden(true)
                    .background(isDarkMode ? Color.customBackgroundDark : Color.customBackground)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            Task{
                                await  pillsViewModal.getMedication()
                            }
                            
                        }
                    }}
            SuccessPopupView(show: $pillsViewModal.showSuccess)
                .zIndex(1)
        }
    }
       
}

#Preview {
    PillsReminder()
        .environmentObject(ThemeManager())
}

struct MedicineScheduleView: View {
    
    var  isDarkMode : Bool;
    var selectedDate : String;
    

    @EnvironmentObject var pillsViewModal: PillsViewModal

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Scrollable Table
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Your pills for the day")
                                              .bold()
                                              .foregroundColor(isDarkMode ?  .white :.black )
                                              .padding(.leading,20)
                    Spacer(minLength: 30)
                    // Header Row (Time Slots)
                    HStack {
                        Text("Medicine")
                            .padding(.horizontal)
                            .bold()
                            .frame(width: 200, alignment: .leading)
                            .foregroundColor(isDarkMode ? .white : .black)
                        
                        if pillsViewModal.uniqueTimes.isEmpty {
                                       Text("")
                                   } else {
                                       ForEach(pillsViewModal.uniqueTimes, id: \.self) { time in
                                           Text(time)
                                               .font(.caption)
                                               .foregroundColor(.gray)
                                               .frame(width: 80)
                                       }
                                   }
                   
                    }
                    .background(isDarkMode ? Color.customBackgroundDark2 :  Color.customBackground  )
//                    .padding(.horizontal)
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    // Medicine List (Scrollable Vertically)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            ExtractedView(selectedDate: selectedDate, pillsViewModal: _pillsViewModal,isDarkMode: isDarkMode )


                        }

                    }

                }
            }
        }

        .padding(.vertical)
        .background(isDarkMode ? Color.customBackgroundDark2.edgesIgnoringSafeArea(.all) : Color.customBackground.edgesIgnoringSafeArea(.all))
    }
}

// Medicine Data Model
struct Medicine: Identifiable {
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




struct MedicineItem: Identifiable {
    let id = UUID()
    let time: String
    let name: String
    let dosage: String
    let instruction: String
    let icon: String
    let color: Color
    let backgroundColor: Color
    let isHighlighted: Bool
}

struct MedicineScheduleView2: View {
    let medicines: [MedicineItem] = [
        MedicineItem(time: "08:00 AM", name: "Omega 3", dosage: "", instruction: "Take on an empty stomach", icon: "capsule.fill", color: .gray, backgroundColor: .black.opacity(0.7), isHighlighted: false),
        MedicineItem(time: "09:00 AM", name: "Vitamin B12", dosage: "1 pill", instruction: "Take on an empty stomach", icon: "pills.fill", color: .green, backgroundColor: .teal, isHighlighted: true),
        MedicineItem(time: "09:00 AM", name: "Probiotics", dosage: "1 spoon", instruction: "Take 30 mins before a meal", icon: "drop.fill", color: .purple, backgroundColor: .purple.opacity(0.8), isHighlighted: true),
        MedicineItem(time: "11:00 AM", name: "Vitamin D3", dosage: "1 pill", instruction: "Take after a meal", icon: "pills.fill", color: .red, backgroundColor: .red.opacity(0.7), isHighlighted: false)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(medicines) { medicine in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(medicine.time)
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        HStack {
                            if medicine.isHighlighted {
                                Capsule()
                                    .fill(Color.purple)
                                    .frame(width: 60, height: 8)
                                    .overlay(
                                        Text(medicine.time)
                                            .foregroundColor(.white)
                                            .font(.caption)
                                            .bold()
                                    )
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: medicine.icon)
                                    .foregroundColor(medicine.color)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    if !medicine.dosage.isEmpty {
                                        Text(medicine.dosage)
                                            .font(.caption)
                                            .bold()
                                            .padding(6)
                                            .background(medicine.color.opacity(0.2))
                                            .cornerRadius(8)
                                            .foregroundColor(medicine.color)
                                    }
                                    
                                    Text(medicine.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(medicine.instruction)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(medicine.backgroundColor)
                            .cornerRadius(12)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.customBackground)
    }
}

struct MedicineScheduleView2_Previews: PreviewProvider {
    static var previews: some View {
        MedicineScheduleView2()
    }
}

struct ExtractedView: View {
    var selectedDate: String
    @EnvironmentObject var pillsViewModal: PillsViewModal
    var isDarkMode: Bool

    var body: some View {
        ForEach(Array(pillsViewModal.medications.enumerated())
            .filter { selectedDate.isEmpty || $0.element.date == selectedDate },
                id: \.offset) { index, med in
            
            MedicationRowView(
                med: med,
                index: index,
                uniqueTimes: pillsViewModal.uniqueTimes,
                isDarkMode: isDarkMode,
                onTap: { time, duration in
                    Task {
                        await pillsViewModal.medcineIntake(
                            pmID: med.pmId ?? 0,
                            prescriptionID: med.prescriptionRowID ?? 0,
                            convertedTime: time,
                            durationType: duration,
                            date: med.date ?? ""
                        )
                    }
                }
            )
        }
    }
}

struct MedicationRowView: View {
    var med: Medication // Replace with your actual model type
    var index: Int
    var uniqueTimes: [String]
    var isDarkMode: Bool
    var onTap: (_ time: String, _ durationType: String) -> Void

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(med.drugName)
                        .font(.subheadline)
                        .foregroundColor(isDarkMode ? .white : .black)
                    Text(med.dosageForm)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(width: 200, alignment: .leading)

                HStack(spacing: 0) {
                    ForEach(uniqueTimes, id: \.self) { masterTime in
                        if let match = med.decodedJsonTime.first(where: { $0.time == masterTime }) {
                            if match.icon == "upcoming" {
                                Image(systemName: "clock.fill")
                                    .frame(width: 80, height: 50)
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        onTap(match.time, match.durationType)
                                    }
                            } else {
                                Image(match.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .frame(width: 80)
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        onTap(match.time, match.durationType)
                                    }
                            }
                        } else {
                            Text("_")
                                .frame(width: 80)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            .background(
                isDarkMode
                ? (index.isMultiple(of: 2) ? Color.customBackgroundDark2 : Color.customBackgroundDark)
                : (index.isMultiple(of: 2) ? Color.white : Color.customBackground2)
            )

            Divider().background(Color.white.opacity(0.2))
        }
    }
}

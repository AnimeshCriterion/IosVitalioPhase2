

import SwiftUI

struct PillsReminder: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var pillsViewModal: PillsViewModal

    var isDarkMode : Bool {
        themeManager.colorScheme == .dark
    }
    
    
    func getData(){
        Task{
            await pillsViewModal.getMedication()
        }

    }
    
    var body: some View {
        VStack {
            CustomNavBarView(title: "Pills Timeline", isDarkMode: isDarkMode){}
            Spacer(minLength: 20)
            DateLabelView()
                .padding(.leading,20)
            MedicineScheduleView(isDarkMode: isDarkMode)
        }.background(isDarkMode ? Color.customBackgroundDark2 : Color.customBackground)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Task{
                        await  pillsViewModal.getMedication()
                    }

                }
            }
    }
       
}

#Preview {
    PillsReminder()
        .environmentObject(ThemeManager())
}

struct MedicineScheduleView: View {
    
    var  isDarkMode : Bool;
//    @EnvironmentObject var themeManager: ThemeManager

//       var isDarkMode: Bool {
//           themeManager.colorScheme == .dark
//       }
    
    let columns = ["8:00 AM", "12:00 PM", "6:00 PM", "9:00 PM"]

    @EnvironmentObject var pillsViewModal: PillsViewModal
    let medicines: [Medicine] = [
        Medicine(name: "Metoprolol", dosage: "50 mg Metoprolol Succinate", schedule: ["taken", "-", "-", "-"]),
        Medicine(name: "Aspirin", dosage: "75 mg Acetylsalicylic Acid", schedule: ["missed", "-", "-", "-"]),
        Medicine(name: "Atorvastatin", dosage: "10 mg Atorvastatin Calcium", schedule: ["-", "taken", "-", "-"]),
        Medicine(name: "Clopidogrel", dosage: "75 mg Clopidogrel Bisulfate", schedule: ["-", "-", "taken", "-"]),
        Medicine(name: "Ramipril", dosage: "5 mg Ramipril", schedule: ["missed", "-", "missed", "taken"]),
        Medicine(name: "Furosemide", dosage: "20 mg Furosemide", schedule: ["-", "taken", "-", "-"]),
        Medicine(name: "Warfarin", dosage: "2.5 mg Warfarin Sodium", schedule: ["taken", "-", "-", "-"]),
        Medicine(name: "Nitroglycerin", dosage: "0.4 mg Nitroglycerin (Sublingual Tablet)", schedule: ["missed", "-", "-", "-"])
    ]
    
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
                            .bold()
                            .frame(width: 200, alignment: .leading)
                            .foregroundColor(isDarkMode ? .white : .black)
                        ForEach(columns, id: \.self) { time in
                            Text(time)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(width: 80)
                        }
                    }
                    .background(isDarkMode ? Color.customBackgroundDark2 :  Color.customBackground  )
                    .padding(.horizontal)
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    // Medicine List (Scrollable Vertically)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(pillsViewModal.medications, id: \.prescriptionRowID) { med in
                                HStack {
                                    // Fixed Column (Medicine Name & Dosage)
                                    VStack(alignment: .leading) {
                                        Text(med.drugName)
                                            .font(.headline)
                                            .foregroundColor(isDarkMode ?   .white : .black)
                                        Text(med.dosageForm)
                                            .font(.caption)
                                            .foregroundColor( .gray)
                                    }
                                    .frame(width: 200, alignment: .leading) // Freeze first column
                                    
                                    // Scrollable Schedule
                                    ForEach(med.decodedJsonTime, id: \.time) { item in
                                      
                                    
                                            Text(item.durationType)
                                                .frame(width: 80)
                                                .foregroundColor( .gray)
                                      
                                        
                                      
                                    }
                                }
                                .padding()
//                                .background(isDarkMode ? Color.customBackground2 : Color.customBackground)
                                .background(isDarkMode ?  Color.customBackgroundDark2 : Color.white )
                                
                                Divider().background(Color.white.opacity(0.2))
                            }
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

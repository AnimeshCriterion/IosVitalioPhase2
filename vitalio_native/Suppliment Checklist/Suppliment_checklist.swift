//
//  Suppliment_checklist.swift
//  vitalio_native
//
//  Created by HID-18 on 04/04/25.
//



import SwiftUI

struct Suppliment: View {
    @EnvironmentObject var themeManager: ThemeManager

    var isDarkMode : Bool {
        themeManager.colorScheme == .dark
    }
    
    var body: some View {
        VStack {
            CustomNavBarView(title: "Suppliment Checklist", isDarkMode: isDarkMode){}
            Spacer(minLength: 20)
//            DateLabelView()
                .padding(.leading,20)
//            MedicineScheduleView(isDarkMode: isDarkMode)
        }.background(isDarkMode ? Color.customBackgroundDark2 : Color.customBackground)
    }
}

#Preview {
    Suppliment()
        .environmentObject(ThemeManager())
}

struct SupplimentChecklist: View {
    var  isDarkMode : Bool;
//    @EnvironmentObject var themeManager: ThemeManager

//       var isDarkMode: Bool {
//           themeManager.colorScheme == .dark
//       }
    
    let columns = ["8:00 AM", "12:00 PM", "6:00 PM", "9:00 PM"]

    
    let medicines: [Supplimnt] = [
        Supplimnt(name: "Metoprolol", dosage: "50 mg Metoprolol Succinate", schedule: ["taken", "-", "-", "-"]),
        Supplimnt(name: "Aspirin", dosage: "75 mg Acetylsalicylic Acid", schedule: ["missed", "-", "-", "-"]),
        Supplimnt(name: "Atorvastatin", dosage: "10 mg Atorvastatin Calcium", schedule: ["-", "taken", "-", "-"]),
        Supplimnt(name: "Clopidogrel", dosage: "75 mg Clopidogrel Bisulfate", schedule: ["-", "-", "taken", "-"]),
        Supplimnt(name: "Ramipril", dosage: "5 mg Ramipril", schedule: ["missed", "-", "missed", "taken"]),
        Supplimnt(name: "Furosemide", dosage: "20 mg Furosemide", schedule: ["-", "taken", "-", "-"]),
        Supplimnt(name: "Warfarin", dosage: "2.5 mg Warfarin Sodium", schedule: ["taken", "-", "-", "-"]),
        Supplimnt(name: "Nitroglycerin", dosage: "0.4 mg Nitroglycerin (Sublingual Tablet)", schedule: ["missed", "-", "-", "-"])
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
                            .frame(width: 150, alignment: .leading)
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
                            ForEach(medicines) { medicine in
                                HStack {
                                    // Fixed Column (Medicine Name & Dosage)
                                    VStack(alignment: .leading) {
                                        Text(medicine.name)
                                            .font(.headline)
                                            .foregroundColor(isDarkMode ?   .white : .black)
                                        Text(medicine.dosage)
                                            .font(.caption)
                                            .foregroundColor( .gray)
                                    }
                                    .frame(width: 150, alignment: .leading) // Freeze first column
                                    
                                    // Scrollable Schedule
                                    ForEach(medicine.schedule, id: \.self) { status in
                                      
                                        if(status == "-"){
                                            Text(status)
                                                .frame(width: 80)
                                                .foregroundColor( .gray)
                                        }
                                        else{
                                            Image(status)
                                                .frame(width: 80)
                                        }
                                        
                                      
                                    }
                                }
                                .padding()
//                                .background(isDarkMode ? Color.customBackground2 : Color.customBackground)
                                .background(isDarkMode ? (medicine.isHighlighted ? Color.customBackgroundDark2 : Color.customBackgroundDark) : ( medicine.isHighlighted ? Color.customBackground : Color.white ))
                                
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





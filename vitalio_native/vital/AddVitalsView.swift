

import SwiftUI

struct AddVitalsView: View {
    @State private var showPopup = false
    @State private var value: String = ""
    @State private var valueSecond: String = ""
    @State private var pulseValue: String = ""
    @EnvironmentObject var vitalsVM: VitalsViewModal
    @EnvironmentObject var route: Routing
    @EnvironmentObject var theme: ThemeManager
    
    var isDark: Bool {
        theme.colorScheme == .dark
    }
 
    var body: some View {
        VStack {
            CustomNavBarView(title: "Add Vitals", isDarkMode: isDark) {
                route.back()
            }

            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 12) {
                    Image("home")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50) // Adjust as needed

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Omron Automatic BP Monitor (HEM-7156)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .truncationMode(.tail)

                        Text("BP Machine")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(isDark ? Color.customBackgroundDark : Color.white)
                .cornerRadius(15)
            }

            Spacer()

            Button(action: {
                showPopup = true
            }) {
                Text("Add Vital Manually")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isDark ? Color.customBackgroundDark : Color.customBackground2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.primaryBlue, lineWidth: 1)
                    )
                    .cornerRadius(14)
            }
            .padding(.horizontal, 37)
        }
        .padding(.horizontal, 20)
        .background(isDark ? Color.customBackgroundDark : Color.customBackground2)
        .sheet(isPresented: $showPopup) {
            VitalPopupView(showPopup: $showPopup, value: $value,valueSecond: $valueSecond,pulseValue: $pulseValue)
                .presentationDetents([.height(350)])
                .presentationDragIndicator(.visible)
                .environmentObject(vitalsVM)
        }
        .navigationBarHidden(true)
    }

}







struct VitalPopupView: View {
    
    @EnvironmentObject var route: Routing
    @Binding var showPopup: Bool
    @Binding var value: String
    @Binding var valueSecond: String
    @Binding var pulseValue: String
    @EnvironmentObject var vitalsVM: VitalsViewModal
    

    var body: some View {
        ZStack(alignment: .topTrailing) {
            

            VStack(alignment: .leading, spacing: 24) {
                Spacer().frame(height: 20)
                Text("Enter \(vitalsVM.data) Value")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(.leading)
                    .padding(.top, 20)

                VStack(spacing: 8) {
                    if vitalsVM.data == "Blood Pressure" {
                        
                        
                        VitalRow(title: "Sys", unit: vitalsVM.unitData,value: $value)
                        VitalRow(title: "Dias", unit: vitalsVM.unitData,value: $valueSecond)
                        VitalRow(title: "Pulse", unit: "BMP",value: $pulseValue)
                    } else {
                        VitalInputField(value: $value, suffix: vitalsVM.unitData)
                    }

                }
                // ✅ Form validation logic here
                            let isFormValid: Bool = {
                                if vitalsVM.data == "Blood Pressure" {
                                    return !value.isEmpty && !valueSecond.isEmpty && !pulseValue.isEmpty
                                } else {
                                    return !value.isEmpty
                                }
                            }()
                Button("Save Vital") {
                    Task {
                        
                        if vitalsVM.data == "Blood Pressure" {
                            print("vitalsVM.data Blood Pressure \(vitalsVM.data)")
                            if !value.isEmpty && !valueSecond.isEmpty {
                                await vitalsVM.addVitals([
                                    vitalsVM.matchSelectedValue[0]: value,
                                    vitalsVM.matchSelectedValue[1]: valueSecond,
                                    vitalsVM.matchSelectedValue[2]: pulseValue,
                                ])
                                // Clear values only after adding
                                value = ""
                                valueSecond = ""
                                pulseValue = ""
                                showPopup = false
                            }
                        } else {
                            print("vitalsVM.data other \(vitalsVM.data)")
                            if !value.isEmpty {
                                await vitalsVM.addVitals([
                                    vitalsVM.matchSelectedValue[0]: value
                                ])
                                value = ""
                                showPopup = false
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(isFormValid ? Color.blue : Color(.systemGray5))
                .foregroundColor(.white)
                .cornerRadius(10)
                Spacer()
            }

           
            Button(action: {
                showPopup = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .padding(10)
            }
            Spacer()
        }
        .padding()
    }
    
}


struct VitalRow: View {
    var title: String
    var unit: String
    @Binding var value: String   // Make it editable

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                Text(unit)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            // Editable field
            TextField("00", text: $value)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .font(.system(size: 32, weight: .semibold))
                .foregroundColor(.gray.opacity(0.2))
                .frame(width: 60) // Adjust as needed
        }
    }
}
struct VitalInputField: View {
    @Binding var value: String
    var suffix: String

    var body: some View {
        HStack(spacing: 4) {
            TextField("000", text: $value)
                .keyboardType(.numberPad)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            Text(suffix)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

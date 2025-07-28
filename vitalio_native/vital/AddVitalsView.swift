

import SwiftUI

struct AddVitalsView: View {
    @State private var showPopup = false
    @State private var value: String = ""
    @State private var valueSecond: String = ""
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
            VitalPopupView(showPopup: $showPopup, value: $value,valueSecond: $valueSecond)
                .presentationDetents([.height(300)])
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
    @EnvironmentObject var vitalsVM: VitalsViewModal

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showPopup = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding(10)
                }
            }

            VStack(alignment: .leading) {
                Text("Enter \(vitalsVM.data) Value")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .padding(.leading)
                    .padding(.top, 20)

                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(vitalsVM.data)
                                .font(.largeTitle)

                            Text(vitalsVM.unitData)
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                        }

                        Spacer()

                        if vitalsVM.data == "Blood Pressure" {
                                                VStack {
                                                    TextField("Sys", text: $value)
                                                        .font(.body)
                                                        .foregroundColor(.black)
                                                        .padding(.vertical, 8)
                                                        .frame(width: 60)
                                                        .multilineTextAlignment(.trailing)

                                                    TextField("Dias", text: $valueSecond)
                                                        .font(.body)
                                                        .foregroundColor(.black)
                                                        .padding(.vertical, 8)
                                                        .frame(width: 60)
                                                        .multilineTextAlignment(.trailing)
                                                }
                                            } else {
                                                TextField("00", text: $value)
                                                    .font(.largeTitle)
                                                    .foregroundColor(.black)
                                                    .padding(.vertical, 12)
                                                    .frame(width: 60)
                                                    .multilineTextAlignment(.trailing)
                                            }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }

            Button("Done") {
                Task {
                    if vitalsVM.data == "Blood Pressure" {
                        if !value.isEmpty && !valueSecond.isEmpty {
                            await vitalsVM.addVitals([
                                vitalsVM.matchSelectedValue[0]: value,
                                vitalsVM.matchSelectedValue[1]: valueSecond
                            ])
                            // Clear values only after adding
                            value = ""
                            valueSecond = ""
                            showPopup = false
                        }
                    } else {
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
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
    }
}

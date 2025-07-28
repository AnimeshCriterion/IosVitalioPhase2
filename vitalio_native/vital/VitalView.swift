//
//  VitalView.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/15/25.
//

import SwiftUI

struct VitalView: View {
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
            ScrollView{
                ZStack{
                    VStack {
                        ForEach(vitalsVM.groupedVitals) { vital in
                            Button(action: {
                                route.navigate(to: .vitalHistory)
                                vitalsVM.selectedVital = vital
                                Task{
                                    await  vitalsVM.vitalsHistory()
                                }

                            }) {
                            VStack (alignment: .leading){
                                HStack {
                                    Text(vital.vitalName)
                                        .font(.headline)
                                        .foregroundColor(isDark ? .white : .black)
                                        
                                    Spacer()
                                    Button(action: {
                                        route.navigate(to: .addVitals)
                                        vitalsVM.data = vital.vitalName
                                        vitalsVM.unitData = vital.unit
                                        print(vitalsVM.data)
                                        print(vital.vitalName)
                                        switch vital.vitalName {
                                          case "Blood Pressure":
                                            vitalsVM.matchSelectedValue.append(contentsOf: ["vmValueBPSys", "vmValueBPDias"])
//                                            vitalsVM.matchSelectedValue = "vmValueBPSys"
//                                            vitalsVM.matchSelectedValue = "vmValueBPDias"
                                          case "Spo2":
                                            vitalsVM.matchSelectedValue.append("vmValueSPO2")
//                                            vitalsVM.matchSelectedValue = "vmValueSPO2"
                                          case "RespRate":
                                            vitalsVM.matchSelectedValue.append("vmValueRespiratoryRate")
//                                            vitalsVM.matchSelectedValue = "vmValueRespiratoryRate"
                                          case "HeartRate":
                                            vitalsVM.matchSelectedValue.append("vmValueHeartRate")
//                                            vitalsVM.matchSelectedValue = "vmValueHeartRate"
                                          case "Pulse":
                                            vitalsVM.matchSelectedValue.append("vmValuePulse")
//                                            vitalsVM.matchSelectedValue = "vmValuePulse"
                                          case "RBS":
                                            vitalsVM.matchSelectedValue.append("vmValueRbs")
//                                            vitalsVM.matchSelectedValue = "vmValueRbs"
                                          case "Temperature":
                                            vitalsVM.matchSelectedValue.append("vmValueTemperature")
//                                            vitalsVM.matchSelectedValue = "vmValueTemperature"
                                          case "Weight":
                                            vitalsVM.matchSelectedValue.append("weight")
//                                            vitalsVM.matchSelectedValue = "weight"
                                          case "Height":
                                            vitalsVM.matchSelectedValue.append("height")
//                                            vitalsVM.matchSelectedValue = "height"
                                          default:
                                            vitalsVM.matchSelectedValue = []
//                                            vitalsVM.matchSelectedValue = "" // or show an error
                                          }
                                        
                                        
                                        
                                    }) {
                                        Text("Add Vital")
                                            .font(.subheadline)
                                            .foregroundColor(isDark ? .white : .black)
                                    }
                                }
                                
                                HStack {
                                            if vital.vitalName == "Blood Pressure" {
                                                let sys = vitalsVM.vitals.first(where: { $0.vitalName == "BP_Sys" })?.vitalValue ?? 0
                                                let dias = vitalsVM.vitals.first(where: { $0.vitalName == "BP_Dias" })?.vitalValue ?? 0

                                                let sysStatus = vitalsVM.getVitalStatus(for: "BP_Sys", value: "\(sys)")
                                                let diasStatus = vitalsVM.getVitalStatus(for: "BP_Dias", value: "\(dias)")

                                                HStack(spacing: 0) {
                                                    Text(sys == 0 ? "--" : "\(Int(sys))")
                                                        .font(.largeTitle)
                                                        .foregroundStyle(sysStatus.color)

                                                    Text("/")
                                                        .font(.largeTitle)
                                                        .foregroundColor(.gray)

                                                    Text(dias == 0 ? "--" : "\(Int(dias))")
                                                        .font(.largeTitle)
                                                        .foregroundStyle(diasStatus.color)
                                                }

                                                Text(vital.unit)
                                                    .font(.footnote)
                                                    .foregroundColor(.gray)
                                            } else {
                                                Text(vital.vitalValue == 0 ? "--" : "\(vital.vitalValue.cleanString())")
                                                    .font(.largeTitle)
                                                    .foregroundStyle(
                                                        vitalsVM.getVitalStatus(for: vital.vitalName, value: "\(vital.vitalValue)").color
                                                    )

                                                Text(vital.unit)
                                                    .font(.footnote)
                                                    .foregroundColor(.gray)
                                            }
                                        }



                                if !vital.vitalDateTime.isEmpty {
                                    Text("\(vitalsVM.timeAgoSince(vital.vitalDateTime))")
                                        .font(.footnote)
                                        .foregroundStyle(
                                            vitalsVM.getVitalStatus(for: vital.vitalName, value: "\(vital.vitalValue)").color
                                        )
                                }
                            }
                        }
                                
                                .padding()
                                
                                .background(isDark ? Color.customBackgroundDark2 :Color.white)
                                .cornerRadius(15)
                        }
                        .cornerRadius(15)
                        .background(isDark ? Color.customBackgroundDark2 : Color.customBackground2)
                    }.padding(.horizontal, 20)
                    .onAppear(){
                        Task{
                            await vitalsVM.getVitals()
                        }
                    }
                    if vitalsVM.isLoading {
                        LoaderView(text: "Fetching Vitals...")
                    }
                }
                
                
            }
            .navigationBarHidden(true)
            .background(isDark ? Color.customBackgroundDark : Color.customBackground2)
            
        }
        
    }
        
}
extension Double {
    func cleanString() -> String {
        return self == floor(self) ? String(Int(self)) : String(format: "%.1f", self)
    }
}

#Preview {
    VitalView()
}



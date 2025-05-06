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
                        ForEach(vitalsVM.vitals) { vital in
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
                                        switch vital.vitalName {
                                          case "BP_Sys":
                                            vitalsVM.matchSelectedValue = "vmValueBPSys"
                                          case "BP_Dias":
                                            vitalsVM.matchSelectedValue = "vmValueBPDias"
                                          case "Spo2":
                                            vitalsVM.matchSelectedValue = "vmValueSPO2"
                                          case "RespRate":
                                            vitalsVM.matchSelectedValue = "vmValueRespiratoryRate"
                                          case "HeartRate":
                                            vitalsVM.matchSelectedValue = "vmValueHeartRate"
                                          case "Pulse":
                                            vitalsVM.matchSelectedValue = "vmValuePulse"
                                          case "RBS":
                                            vitalsVM.matchSelectedValue = "vmValueRbs"
                                          case "Temperature":
                                            vitalsVM.matchSelectedValue = "vmValueTemperature"
                                          default:
                                            vitalsVM.matchSelectedValue = "" // or show an error
                                          }
                                        
                                        
                                        
                                    }) {
                                        Text("Add Vital")
                                            .font(.subheadline)
                                            .foregroundColor(isDark ? .white : .black)
                                    }
                                }
                                
                                HStack {
                                    Text("\(vital.vitalValue, specifier: "%.0f")")
                                        .font(.largeTitle)
                                        .foregroundStyle(
                                                    vitalsVM.getVitalStatus(for: vital.vitalName, value: "\(vital.vitalValue)").color
                                                )
                                    Text(vital.unit)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                
                                Text("\(vitalsVM.timeAgoSince(vital.vitalDateTime))")
                                    .font(.footnote)
                                    .foregroundStyle(
                                                vitalsVM.getVitalStatus(for: vital.vitalName, value: "\(vital.vitalValue)").color
                                            )
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

#Preview {
    VitalView()
}



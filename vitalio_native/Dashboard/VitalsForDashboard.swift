//
//  VitalsForDashboard.swift
//  vitalio_native
//
//  Created by HID-18 on 04/08/25.
//

import SwiftUI

struct VitalsForDashboard: View {
    @EnvironmentObject var viewModel : DashboardViewModal
    @EnvironmentObject var vitalsVM: VitalsViewModal
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager
    var isDarkMode: Bool {
        themeManager.colorScheme == .dark
    }

    func getRandomColor() -> Color {
        let colors: [Color] = [
            .red, .green, .blue, .orange, .purple, .pink, .yellow, .gray, .teal, .indigo
        ]
        return colors.randomElement() ?? .black
    }

    var body: some View {
        HStack(spacing: 16) {
            ForEach(vitalsVM.groupedVitals) { vital in
                Button(action: {
                    route.navigate(to: .vitalHistory)
                    vitalsVM.selectedVital = vital
                    Task {
                        await vitalsVM.vitalsHistory()
                    }
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                         Image("hr")
                                .resizable()
                                .frame( width: 46 , height: 46)
                                       .blendMode(.overlay) // Apply blend mode
                            Spacer()
                     
                            VStack {
                                Button(action: {
                                    route.navigate(to: .addVitals)
                                    vitalsVM.data = vital.vitalName
                                    vitalsVM.unitData = vital.unit
                                    print(vitalsVM.data)
                                    switch vital.vitalName {
                                    case "Blood Pressure":
                                        vitalsVM.matchSelectedValue.append(contentsOf: ["vmValueBPSys", "vmValueBPDias"])
                                    case "Spo2":
                                        vitalsVM.matchSelectedValue.append("vmValueSPO2")
                                    case "RespRate":
                                        vitalsVM.matchSelectedValue.append("vmValueRespiratoryRate")
                                    case "HeartRate":
                                        vitalsVM.matchSelectedValue.append("vmValueHeartRate")
                                    case "Pulse":
                                        vitalsVM.matchSelectedValue.append("vmValuePulse")
                                    case "RBS":
                                        vitalsVM.matchSelectedValue.append("vmValueRbs")
                                    case "Temperature":
                                        vitalsVM.matchSelectedValue.append("vmValueTemperature")
                                    case "Weight":
                                        vitalsVM.matchSelectedValue.append("weight")
                                    case "Height":
                                        vitalsVM.matchSelectedValue.append("height")
                                    default:
                                        vitalsVM.matchSelectedValue = []
                                    }
                                }) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.gray)
                            }
                            }
                        }
                        Spacer()
                        Text(vital.vitalName)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(isDarkMode ? .white : .black)
                        HStack {
                            if vital.vitalName == "Blood Pressure" {
                                let sys = vitalsVM.vitals.first(where: { $0.vitalName == "BP_Sys" })?.vitalValue ?? 0
                                let dias = vitalsVM.vitals.first(where: { $0.vitalName == "BP_Dias" })?.vitalValue ?? 0
                                let sysStatus = vitalsVM.getVitalStatus(for: "BP_Sys", value: "\(sys)")
                                let diasStatus = vitalsVM.getVitalStatus(for: "BP_Dias", value: "\(dias)")

                                HStack(spacing: 0) {
                                    Text(sys == 0 ? "--" : "\(Int(sys))")
                                        .font(.system(size: 18))
                                        .fontWeight(.semibold)
                                        .foregroundColor(isDarkMode ? .white : .black)
                                    Text("/")
                                        .font(.system(size: 18))
                                        .fontWeight(.semibold)
                                        .foregroundColor(isDarkMode ? .white : .black)
                                    Text(dias == 0 ? "--" : "\(Int(dias))")
                                        .font(.system(size: 18))
                                        .fontWeight(.semibold)
                                        .foregroundColor(isDarkMode ? .white : .black)
                                }

                                Text(vital.unit)
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                    .foregroundColor(isDarkMode ? .white : .black)
                            } else {
                                Text(vital.vitalValue == 0 ? "--" : "\(vital.vitalValue.cleanString())")
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(isDarkMode ? .white : .black)

                                Text(vital.unit)
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(isDarkMode ? .white : .black)
                            }
                        }
//                        if !vital.vitalDateTime.isEmpty {
//                            Text("\(vitalsVM.timeAgoSince(vital.vitalDateTime))")
//                                .font(.footnote)
//                                .foregroundStyle(vitalsVM.getVitalStatus(for: vital.vitalName, value: "\(vital.vitalValue)").color)
//                        }
                    }
                    .frame(width: 150, height: 159) // Makes it square
                    .padding()
                    .background(getRandomColor().opacity(0.1))
                    .cornerRadius(20)
                }
            }
        }
        .padding(.trailing)
    }
}

#Preview {
    VitalsForDashboard()
}

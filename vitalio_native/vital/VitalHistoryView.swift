//
//  VitalHistoryView.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/16/25.
//

import SwiftUI
import Charts

struct Insect: Identifiable {
    let id = UUID()
    let name: String
    let family: String
    let wingLength: Double
    let wingWidth: Double
    let time: Date
}

struct VitalHistoryView: View {
    @EnvironmentObject var vitalsVM: VitalsViewModal
    @State private var selectedPeriod: Period = .daily
    @State private var isSelecttedGraph = false
    
    func makeTime(_ timeString: String) -> Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.date(from: timeString) ?? Date()
        }
    
   
    var data: [Insect] {
           [
               Insect(name: "Hepialidae", family: "Lepidoptera", wingLength: 61, wingWidth: 52,  time: makeTime("06:00")),
               Insect(name: "Danaidae", family: "Lepidoptera", wingLength: 60, wingWidth: 48,  time: makeTime("07:00")),
               Insect(name: "Riodinidae", family: "Lepidoptera", wingLength: 53, wingWidth: 43, time: makeTime("08:00")),
               Insect(name: "Riodinidae", family: "Lepidoptera", wingLength: 53, wingWidth: 43,  time: makeTime("09:00")),
               Insect(name: "Riodinidae", family: "Lepidoptera", wingLength: 53, wingWidth: 43, time: makeTime("10:00")),
               Insect(name: "Riodinidae", family: "Lepidoptera", wingLength: 53, wingWidth: 43,  time: makeTime("11:00")),
           ]
       }
    
    
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager

    var isDark: Bool {
        themeManager.colorScheme == .dark
    }

    
    var body: some View {
        VStack(alignment: .leading){
            CustomNavBarView(title: "Vitals history", isDarkMode: isDark) {
                route.back()
            }
            ScrollView{
            VStack {
                PeriodToggleView(selectedPeriod: $selectedPeriod)
                //                   Text("Selected: \(selectedPeriod.title)")
                    .onChange(of: selectedPeriod) { newPeriod in
                        vitalsVM.historyFilter = vitalsVM.mapPeriodToFilter(newPeriod)
                        Task { await vitalsVM.vitalsHistory() }
                    }
            }
            
            
            //            HStack {
            //                Spacer()
            //                DateSelectorView()
            //                Spacer()
            //            }
                HStack{
                             Image(systemName: "chevron.left")
                                 .foregroundColor(.gray).padding(.horizontal, 20)
                             Spacer()
                             if selectedPeriod.title == "Weekly" {
                                 Text("\(vitalsVM.formattedDate(vitalsVM.startDate)) - \(vitalsVM.formattedDate(vitalsVM.currentDate))")
              
                             } else if selectedPeriod.title == "Monthly" {
                                 Text("\(vitalsVM.formattedDate(vitalsVM.startDate)) - \(vitalsVM.formattedDate(vitalsVM.currentDate))")
                             } else {
                                 Text("Today")
                             }
                           
                             Spacer()
                             Image(systemName: "chevron.right")
                                 .foregroundColor(.gray).padding(.horizontal, 20)
                     }
                         .padding(.vertical,20)
            .padding(.vertical,20)
            
            
            
            if selectedPeriod.title != "Monthly" && selectedPeriod.title != "Weekly" {
                
                ZStack {
                    ZStack {
                        Image("heart")
                            .frame(height: 260)
                        
                        
                        VStack {
                            HStack {
                                Text("\(vitalsVM.selectedVital?.vitalValue ?? 0, specifier: "%.0f")")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.primaryBlue)
                                Text((vitalsVM.selectedVital?.unit ?? ""))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.bottom,10)
                            
                            Text("Today")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                    .padding(.bottom,20)
                    
                    
                    Image("heart-circle")
                        .offset(x:80,y:50)
                }
                Text("Add Vital")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primaryBlue)
                
            }
            VStack{
                HStack {
                    Text(vitalsVM.selectedVital?.vitalName ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            isSelecttedGraph = false
                        }) {
                            Image("list-ul")
                                .renderingMode(.template)
                                .foregroundColor(isSelecttedGraph ? .gray : Color.primaryBlue)
                                .frame(width: 36, height: 36)
                                .background(isDark ? Color.customBackgroundDark : Color.customBackground2)
                                .cornerRadius(30)
                        }
                        Spacer()
                            .frame(width: 30)
                        
                        Button(action: {
                            isSelecttedGraph = true
                        }) {
                            Image("graph-up")
                                .renderingMode(.template)
                                .foregroundColor(isSelecttedGraph ? Color.primaryBlue : .gray)
                                .frame(width: 36, height: 36)
                                .background(isDark ? Color.customBackgroundDark : Color.customBackground2)
                                .cornerRadius(30)
                        }
                    }
                }
                
                if isSelecttedGraph {
                    
                    Chart(data) { insect in
                        PointMark(
                            x: .value("Time", insect.time),
                            y: .value("Wing Length", insect.wingLength)
                        )
                        //.foregroundStyle(by: .value("Family", insect.family))
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .hour)) {
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.hour().minute(), centered: true)
                        }
                    }
                    
                    .chartYAxis {
                        AxisMarks(position: .leading) {
                            AxisGridLine()
                            AxisValueLabel()
                        }
                    }
                    .frame(height: 170)
                    .padding()
                } else {
                    
                    ScrollView {
                        if vitalsVM.patientGraph.isEmpty {
                            VStack {
                                Spacer()
                                Text("No Data Found")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.top, 50)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(vitalsVM.patientGraph.reversed(), id: \.vitalDateTime) { data in
                                    if let details = data.decodedVitalDetails {
                                        ForEach(details.reversed(), id: \.vitalid) { vital in
                                            VStack(alignment: .leading, spacing: 8) {
                                                HStack {
                                                    // Value and Unit
                                                    HStack {
                                                        Text("\(Int(vital.vitalValue))")
                                                            .font(.title2)
                                                            .foregroundStyle(.red)
                                                        
                                                        Text(vital.vitalName)
                                                            .font(.footnote)
                                                            .foregroundStyle(.secondary)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    // Timestamp
                                                    HStack {
                                                        Image(systemName: "clock")
                                                            .font(.footnote)
                                                        
                                                        Text(vitalsVM.timeAgoSince(vital.vitaldate))
                                                            .font(.caption)
                                                    }
                                                    .foregroundStyle(.secondary)
                                                }
                                                Divider()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .frame(width: .infinity,height: 272)
            .background(isDark ? Color.customBackgroundDark2 : Color.customBackground2)
            .cornerRadius(10)
            .padding()
            Spacer()
        }}
        .navigationBarHidden(true)
        .background(isDark ? Color.customBackgroundDark : Color.customBackground2)
    }
}

#Preview {
    VitalHistoryView()
}



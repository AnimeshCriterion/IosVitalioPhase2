//
//  outputHistory.swift
//  vitalio_native
//
//  Created by HID-18 on 12/04/25.
//

import SwiftUI


struct OutputData: Identifiable {
    let id = UUID()
    let type: String
    let time: String
    let amount: Int
    let color: Color
}

struct OutputHistoryView: View {
    @EnvironmentObject var route: Routing
    @State private var showChart = false
    @State private var selectedPeriod: Period = .daily
    let inputData: [InputEntry] = [
        .init(type: "Water", time: "05:50 AM", amount: 200, color: .cyan),
        .init(type: "Water", time: "06:30 AM", amount: 300, color: .cyan),
        .init(type: "Milk", time: "08:12 AM", amount: 350,color:.yellow),
        .init(type: "Water", time: "11:55 AM", amount: 400, color: .cyan),
        .init(type: "Juice", time: "02:00 PM", amount: 200,color:.orange),
        .init(type: "Water", time: "05:15 PM", amount: 200, color: .cyan),
        .init(type: "Tea", time: "05:22 PM", amount: 50, color: .orange)
    ]

    var body: some View {
        ScrollView{
            
            
            VStack(alignment: .leading, spacing: 16) {
                CustomNavBarView(title: "Fluid Output History", isDarkMode: false) {
                    
                    route.back()
                }
                PeriodToggleView(selectedPeriod: $selectedPeriod)
                
                HStack {
                    Spacer()
                    DateSelectorView()
                    Spacer()
                }
                HStack {
                    Text("Fluid Intake Log")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            showChart = false
                        }) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(showChart ? .gray : .blue)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            showChart = true
                        }) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(showChart ? .blue : .gray)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                }
                
                if showChart {
                    OutputChartView(data: inputData)
                } else {
                    OutputHistoryList(data: inputData)
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
        }}
}

struct OutputHistoryList: View {
    let data: [InputEntry]

    var body: some View {
        VStack(spacing: 20) {
            ForEach(data.reversed()) { item in
                HStack {
                    Circle()
                             .fill(Color.yellow)
                             .frame(width: 45, height: 45)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.type)
                            .font(.system(size: 16, weight: .semibold))
                        Text(item.time)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(item.amount) ml")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct OutputChartView: View {
    let data: [InputEntry]

    var body: some View {
        GeometryReader { geo in
            let maxY = 1000.0
            let spacing = geo.size.width / 24

            ZStack(alignment: .topLeading) {
                // Y-axis labels
                VStack(spacing: geo.size.height / 5) {
                    ForEach((1...5).reversed(), id: \.self) { i in
                        Text("\(i * 200) ml")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
                .offset(x: -5, y: 0)

                // Graph path
                Path { path in
                    for (i, item) in data.enumerated() {
                        let x = spacing * CGFloat(hourFromTime(item.time))
                        let y = geo.size.height - (CGFloat(item.amount) / CGFloat(maxY) * geo.size.height)
                        let point = CGPoint(x: x, y: y)

                        if i == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)

                // Points and Labels
                ForEach(data) { item in
                    let x = spacing * CGFloat(hourFromTime(item.time))
                    let y = geo.size.height - (CGFloat(item.amount) / CGFloat(maxY) * geo.size.height)

                    Circle()
                        .fill(item.color)
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)

                    Text("\(item.amount)ml")
                        .font(.system(size: 10, weight: .bold))
                        .padding(4)
                        .background(item.color)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .position(x: x, y: y - 16)
                }
            }
        }
        .frame(height: 300)
        .padding(.top, 10)
    }

    func hourFromTime(_ time: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        if let date = formatter.date(from: time) {
            return Calendar.current.component(.hour, from: date)
        }
        return 0
    }
}

#Preview {
    InputView()
}


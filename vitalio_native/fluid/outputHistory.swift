

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
    @EnvironmentObject var viewModel: FluidaViewModal
    @EnvironmentObject var themeManager: ThemeManager
    var isFromChat: Bool = false  // Optional-like, with default


       var isDark: Bool {
           themeManager.colorScheme == .dark
       }
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
                if isFromChat != true {
                    CustomNavBarView(title: "Fluid Output History", isDarkMode: isDark) {
                        
                        route.back()
                    }
                    
                    PeriodToggleView(selectedPeriod: $selectedPeriod)
                    
                }
             
                
                HStack {
                    Spacer()
                    DateSelectorView(isFromChat: isFromChat)  
                        .onAppear(){
                        Task{
                            await viewModel.outputByDate(hours: getCurrentHourString());
                        }
                    }
                    Spacer()
                }
                HStack {
                    Text("Fluid Output Log")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isDark ? .white : .black)
                    
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
                    OutputChartView()
                } else {
                    OutputHistoryList()
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .padding()
            .background(isDark ?Color.customBackgroundDark2 : Color.white)
            .cornerRadius(20)
        }}
}

// MARK: - OutputHistoryList
struct OutputHistoryList: View {
    @EnvironmentObject var themeManager: ThemeManager
    
       var isDark: Bool {
           themeManager.colorScheme == .dark
       }

//    let data: [InputEntry]
    @EnvironmentObject var viewModel : FluidaViewModal
    var body: some View {
        VStack(spacing: 20) {
            ForEach(viewModel.outputList) { item in
                HStack {
                    Circle()
                        .fill(Color(hex: item.colour.isEmpty ? "#FFF176" : item.colour))
                        .frame(width: 45, height: 45)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.outputType)
                            .font(.system(size: 16, weight: .semibold))
                        Text(item.outputDate)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(item.quantity) \(item.unitName)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isDark ? .white : .black)
                }
            }
        }  .background(isDark ? Color.customBackgroundDark2 :Color.white)
    }
}

struct OutputChartView: View {
    @EnvironmentObject var viewModel : FluidaViewModal
    let maxY: Double = 1000.0
    
    var body: some View {
        GeometryReader { geo in
            let spacing = viewModel.outputList.count > 1
            ? geo.size.width / CGFloat(viewModel.outputList.count - 1)
            : 0
            
            ZStack(alignment: .topLeading) {
                // Y-axis grid
                VStack(spacing: geo.size.height / 5) {
                    ForEach((0...5).reversed(), id: \.self) { i in
                        let value = Int(Double(i) * maxY / 5)
                        HStack(spacing: 4) {
                            Text("\(value) ml")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                                .frame(width: 40, alignment: .trailing)
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height: 1)
                        }
                    }
                }
                
                // Path line
                Path { path in
                    for (i, item) in viewModel.outputList.enumerated() {
                        let x = spacing * CGFloat(i)
                        let y = geo.size.height - (CGFloat(item.quantity) / CGFloat(maxY) * geo.size.height)
                        let point = CGPoint(x: x, y: y)
                        
                        if i == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(Color.gray, lineWidth: 1.5)
                
                // Data points and labels
                ForEach(Array(viewModel.outputList.enumerated()), id: \.1.id) { index, item in
                    let x = spacing * CGFloat(index)
                    let y = geo.size.height - (CGFloat(item.quantity) / CGFloat(maxY) * geo.size.height)
                    let color = colorFromString(item.colour)
                    
                    VStack(spacing: 4) {
                        Text("\(item.quantity)\(item.unitName)")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(color)
                            .foregroundColor(.black)
                            .cornerRadius(4)
                        
                        Circle()
                            .fill(color)
                            .frame(width: 6, height: 6)
                    }
                    .position(x: x, y: y - 12)
                }
                
                // Time Labels
                HStack(spacing: spacing) {
                    ForEach(viewModel.outputList) { item in
                        Text(formatTime(item.outputDate))
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .frame(width: spacing, alignment: .center)
                    }
                }
                .position(x: geo.size.width / 2, y: geo.size.height + 10)
            }
        }
        .frame(height: 300)
        .padding()
        .cornerRadius(16)
    }
    
    func colorFromString(_ color: String) -> Color {
        switch color.lowercased() {
        case "yellow": return .yellow
        case "cyan": return .cyan
        case "orange": return .orange
        case "white": return .white
        case "blue": return .blue
        default: return .yellow.opacity(0.7)
        }
    }
    
    func formatTime(_ datetime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        if let date = formatter.date(from: datetime) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "hh:mm a"
            return displayFormatter.string(from: date)
        }
        return datetime
    }
    
    
}

#Preview {
    InputView()
}



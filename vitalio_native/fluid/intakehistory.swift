import SwiftUI

struct InputEntry: Identifiable {
    let id = UUID()
    let type: String
    let time: String
    let amount: Int
    let color: Color
}

struct InputView: View {
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
        VStack(alignment: .leading, spacing: 16) {
            CustomNavBarView(title: "Fluid Intake History", isDarkMode: false) {
                
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
                InputChartView(data: inputData)
            } else {
                InputHistoryView(data: inputData)
            }

            Spacer()
        }
        .navigationBarHidden(true) // Hides the default AppBar
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct InputHistoryView: View {
    let data: [InputEntry]

    var body: some View {
        VStack(spacing: 20) {
            ForEach(data.reversed()) { item in
                HStack {
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

struct InputChartView: View {
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

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}

struct PeriodToggleView: View {
    @Binding var selectedPeriod: Period

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 44)

            GeometryReader { geometry in
                let buttonWidth = geometry.size.width / 3

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                    .frame(width: buttonWidth - 4, height: 40)
                    .offset(x: CGFloat(selectedPeriod.index) * buttonWidth)
                    .animation(.easeInOut(duration: 0.25), value: selectedPeriod)
            }
            .frame(height: 44)
            .padding(.horizontal, 2)

            HStack(spacing: 0) {
                ForEach(Period.allCases, id: \.self) { period in
                    Button(action: {
                        withAnimation {
                            selectedPeriod = period
                        }
                    }) {
                        Text(period.title)
                            .foregroundColor(selectedPeriod == period ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                    }
                }
            }
        }
        .cornerRadius(14)
        .frame(height: 44)
        .padding(.horizontal)
    }
}

enum Period: Int, CaseIterable {
    case daily = 0, weekly, monthly

    var index: Int { rawValue }

    var title: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        }
    }
}

struct DateSelectorView: View {
    @State private var selectedDate: Date = Date()
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation(.easeInOut) {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray).padding(.horizontal, 20)
            }

            ZStack {
                if Calendar.current.isDateInToday(selectedDate) {
                    Text("Today")
                        .font(.system(size: 16, weight: .semibold))
                        .matchedGeometryEffect(id: "dateText", in: animation)
                        .transition(.slide)
                } else {
                    Text(dateFormatted(selectedDate))
                        .font(.system(size: 16, weight: .semibold))
                        .matchedGeometryEffect(id: "dateText", in: animation)
                        .transition(.slide)
                }
            }
            .frame(width: 200, alignment: .center)

            Button(action: {
                withAnimation(.easeInOut) {
                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray).padding(.horizontal, 20)
            }
        }
        .frame(height: 44)
    }

    func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
}

struct DateSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        DateSelectorView()
            .previewLayout(.sizeThatFits)
    }
}

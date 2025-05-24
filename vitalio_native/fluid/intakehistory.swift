import SwiftUI

struct InputEntry: Identifiable {
    let id = UUID()
    let type: String
    let time: String
    let amount: Int
    let color: Color
}

func getCurrentHourString() -> String {
    let hour = Calendar.current.component(.hour, from: Date())
    return "\(hour)"
}

struct InputView: View {
    @EnvironmentObject var viewModel: FluidaViewModal
    @EnvironmentObject var route: Routing
    @State private var selectedPeriod: Period = .daily
    @State private var showChart = false
    @EnvironmentObject var themeManager: ThemeManager
    var isFromChat: Bool = false  // Optional-like, with default


       var isDark: Bool {
           themeManager.colorScheme == .dark
       }
    
//      let inputData: [InputEntry] = [
//        .init(type: "Water", time: "05:50 AM", amount: 200, color: .cyan),
//        .init(type: "Water", time: "06:30 AM", amount: 300, color: .cyan),
//        .init(type: "Milk", time: "08:12 AM", amount: 350,color:.yellow),
//        .init(type: "Water", time: "11:55 AM", amount: 400, color: .cyan),
//        .init(type: "Juice", time: "02:00 PM", amount: 200,color:.orange),
//        .init(type: "Water", time: "05:15 PM", amount: 200, color: .cyan),
//        .init(type: "Tea", time: "05:22 PM", amount: 50, color: .orange)
//    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            if isFromChat != true {
                CustomNavBarView(title: "Fluid Intake History", isDarkMode: isDark) {
                    route.back()
                }
            }
          
            ScrollView{
                PeriodToggleView(selectedPeriod: $selectedPeriod)
                    .environmentObject(viewModel)
                
                if selectedPeriod == .daily {
                    HStack {
                        Spacer()
                        DateSelectorView(isFromChat: isFromChat)
                            .environmentObject(viewModel)
                        Spacer()
                    }
                } else {
                    RangeDateSelectorView(selectedPeriod: $selectedPeriod)
                        .environmentObject(viewModel)
                }
                
                //            }
                HStack {
                    Text("Fluid Intake Log")
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
//                    InputChartView(data: inputData)
                    InputHistoryView2(selectedPeriod: selectedPeriod)
                } else {
                    InputHistoryView(selectedPeriod: selectedPeriod)
                    
                }
                
                Spacer()
            }}
        .navigationBarHidden(true) // Hides the default AppBar
        .padding()
        .background(isDark ? Color.customBackgroundDark2 :Color.white)
        .cornerRadius(20)
    }
}

struct InputHistoryView: View {
    @EnvironmentObject var viewModel: FluidaViewModal
    var selectedPeriod: Period
    @EnvironmentObject var themeManager: ThemeManager
    
       var isDark: Bool {
           themeManager.colorScheme == .dark
       }
    var body: some View {
        VStack(spacing: 20) {
            if selectedPeriod == .daily {
                ForEach(viewModel.fluidList) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.foodName)
                                .font(.system(size: 16, weight: .semibold))
                            Text(item.givenFoodDate)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("\(item.quantity) ml")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(isDark ? .white : .black)
                    }
                }
            } else {
                ForEach(viewModel.fluidSummaryList) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(formatDate(item.givenFoodDate))
                                .font(.system(size: 14, weight: .semibold))
                            Text("Assigned Limit: \(item.assignedLimit, specifier: "%.0f") ml")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("\(item.foodQuantity) ml")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(isDark ? .white : .black)
                    }
                }
            }
        }
    }

    func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd MMM yyyy"
            return displayFormatter.string(from: date)
        }
        return isoString
    }
}

import SwiftUI
import Charts

struct InputHistoryView2: View {
    @EnvironmentObject var viewModel: FluidaViewModal
    var selectedPeriod: Period
    @EnvironmentObject var themeManager: ThemeManager

    var isDark: Bool {
        themeManager.colorScheme == .dark
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Chart Section
                if selectedPeriod == .daily {
                    Chart {
                        ForEach(viewModel.fluidList.filter { Double($0.quantity) != nil }) { item in
                            BarMark(
                                x: .value("Drink", item.foodName),
                                y: .value("Quantity", (Double(item.quantity) ?? 0) / 100)
                            )
                            .foregroundStyle(isDark ? .white : .blue)
                        }
                    }
                    .frame(height: 250)
                    .padding(.horizontal)
                }else {
                    Chart {
                        ForEach(viewModel.fluidSummaryList.filter { Double($0.foodQuantity) != nil }) { item in
                            BarMark(
                                x: .value("Date", formatDate(item.givenFoodDate)),
                                y: .value("Quantity", (Double(item.foodQuantity) ?? 0) / 100) // divide if needed
                            )
                            .foregroundStyle(isDark ? .white : .blue)
                        }
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                }

//
//                // List Section
//                if selectedPeriod == .daily {
//                    ForEach(viewModel.fluidList) { item in
//                        HStack {
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text(item.foodName)
//                                    .font(.system(size: 16, weight: .semibold))
//                                Text(item.givenFoodDate)
//                                    .font(.system(size: 12))
//                                    .foregroundColor(.gray)
//                            }
//                            Spacer()
//                            Text("\(item.quantity) ml")
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundColor(isDark ? .white : .black)
//                        }
//                        .padding(.horizontal)
//                    }
//                } else {
//                    ForEach(viewModel.fluidSummaryList) { item in
//                        HStack {
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text(formatDate(item.givenFoodDate))
//                                    .font(.system(size: 14, weight: .semibold))
//                                Text("Assigned Limit: \(item.assignedLimit, specifier: "%.0f") ml")
//                                    .font(.system(size: 12))
//                                    .foregroundColor(.gray)
//                            }
//                            Spacer()
//                            Text("\(item.foodQuantity) ml")
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundColor(isDark ? .white : .black)
//                        }
//                        .padding(.horizontal)
//                    }
//                }
            }
            .padding(.top)
        }
    }

    // Helper: Convert ISO8601 string to display date
    func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "dd MMM yyyy"
            return displayFormatter.string(from: date)
        }
        return isoString
    }

    // Helper: Format time from ISO string
    func formattedTime(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: date)
        }
        return isoString
    }
}



struct InputChartView: View {
    let data: [InputEntry]
    let maxY: Double = 1500.0 // Adjust according to your fluid quantity range

    var body: some View {
        GeometryReader { geo in
            let spacing = geo.size.width / 24

            ZStack(alignment: .topLeading) {
                // Y-axis grid and labels
                VStack(spacing: geo.size.height / 5) {
                    ForEach((1...5).reversed(), id: \.self) { i in
                        HStack(spacing: 2) {
                            Text("\(Int(Double(i) * maxY / 5)) ml")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                                .frame(width: 40, alignment: .trailing)
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                        }
                    }
                }
                .frame(height: geo.size.height)
                .offset(x: 0, y: 0)

                // Graph line
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
                .stroke(Color.blue, lineWidth: 2)

                // Points and Labels
                ForEach(data) { item in
                    let x = spacing * CGFloat(hourFromTime(item.time))
                    let y = geo.size.height - (CGFloat(item.amount) / CGFloat(maxY) * geo.size.height)

                    VStack(spacing: 2) {
                        Text("\(Int(item.amount))ml")
                            .font(.system(size: 10, weight: .bold))
                            .padding(4)
                            .background(item.color)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                        Circle()
                            .fill(item.color)
                            .frame(width: 8, height: 8)
                    }
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
        InputView().environmentObject(FluidaViewModal())
    }
}
import SwiftUI

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

struct PeriodToggleView: View {
    @Binding var selectedPeriod: Period
    @EnvironmentObject var viewModel: FluidaViewModal

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

struct DateSelectorView: View {
    @State private var selectedDate: Date = Date()
    @Namespace private var animation
    @EnvironmentObject var viewModel: FluidaViewModal
    var isFromChat: Bool = false  // Optional-like, with default

    func hoursTillNow(from selectedDate: Date) -> Int {
        let now = Date()
        let components = Calendar.current.dateComponents([.hour], from: selectedDate, to: now)
        return components.hour ?? 0
    }

    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation(.easeInOut) {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                    Task {
                        if viewModel.isIntakeSelected {
                            await viewModel.getFoodList(hours: String(hoursTillNow(from: selectedDate)))
                        } else {
                            await viewModel.outputByDate(hours: String(hoursTillNow(from: selectedDate)))
                        }
                    }
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
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
            .frame(width: isFromChat ? 100 : 200)

            if selectedDate > Calendar.current.startOfDay(for: Date()) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.2))
                    .padding(.horizontal, 20)
            } else {
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                        Task {
                            if viewModel.isIntakeSelected {
                                await viewModel.getFoodList(hours: String(hoursTillNow(from: selectedDate)))
                            } else {
                                await viewModel.outputByDate(hours: String(hoursTillNow(from: selectedDate)))
                            }
                        }
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                }
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

struct RangeDateSelectorView: View {
    @EnvironmentObject var viewModel: FluidaViewModal
    @Binding var selectedPeriod: Period
    @State private var currentDate: Date = Date()

    var body: some View {
        let (startDate, endDate) = dateRange(for: selectedPeriod, from: currentDate)

        HStack {
            Button(action: {
                // Move range back
                shiftRange(by: -1)
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            Spacer()
            Text("\(formattedDate(startDate)) - \(formattedDate(endDate))")
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal)

            Spacer()


            Button(action: {
                // Move range forward
                shiftRange(by: 1)
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .frame(height: 44)
        .onChange(of: selectedPeriod) { _ in
            Task {
                let (from, to) = dateRange(for: selectedPeriod, from: currentDate)
                await viewModel.fluidSummaryByDateRange(fromDate: formattedDate(from), toDate: formattedDate(to))
            }
        }
    }

    func shiftRange(by value: Int) {
        switch selectedPeriod {
        case .weekly:
            currentDate = Calendar.current.date(byAdding: .day, value: 7 * value, to: currentDate) ?? currentDate
        case .monthly:
            currentDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) ?? currentDate
        default: break
        }

        Task {
            let (from, to) = dateRange(for: selectedPeriod, from: currentDate)
            await viewModel.fluidSummaryByDateRange(fromDate: formattedDate(from), toDate: formattedDate(to))
        }
    }

    func dateRange(for period: Period, from date: Date) -> (Date, Date) {
        switch period {
        case .weekly:
            let start = Calendar.current.date(byAdding: .day, value: -6, to: date) ?? date
            return (start, date)
        case .monthly:
            let start = Calendar.current.date(byAdding: .day, value: -29, to: date) ?? date
            return (start, date)
        default:
            return (date, date)
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}






import Foundation
import SwiftUI

#Preview{
    Dashboard()
        .environmentObject(ThemeManager())
}

struct Dashboard: View {

    @EnvironmentObject var route: Routing
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var viewModel : DashboardViewModal

    @EnvironmentObject var loginVM : LoginViewModal
    @EnvironmentObject var vitalsVM: VitalsViewModal
    @State private var selectedTab: Tab = .home
    @State private var dragOffset: CGFloat = 0
    @ObservedObject private var localizer = LocalizationManager.shared
    @GestureState private var isPressing = false
    @EnvironmentObject var popupManager: PopupManager

       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }

    var body: some View {
        ZStack{
            
            
            VStack {
                Button(action: {
                    viewModel.isDrawerOpen.toggle()
                    Task{
//                      await  loginVM.logOut(uhid: "uhid01235");
                    }
                }) {
                    CustomAppBar(onBack: {
                        presentationMode.wrappedValue.dismiss()
                    }, dark: isDarkMode)}
                ScrollView {
                    Group {
                                   switch selectedTab {
                                   case .home:
                                       HomeView(isDarkMode: isDarkMode)
                                   case .reminders:
                                       ReminderTabView()
                                   case .chat:
                                       ChatBotView()
                                   }
                               }
                               .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    VStack(alignment: .leading){
//                        
//                        LocalizedText(key:"vitals")
//                            .font(.system(size: 18, weight: .semibold))
//                            .foregroundColor( isDarkMode ? .white :  .black)
//                   
//                            VitalsCard(dark: isDarkMode)
//        
////                        Button("Show Global Popup") {
////                            
////                            viewModel.showError(message: "Error check")
//////                            popupManager.show(
//////                               
//////                                message: "This is test popup")
////                        }
//
//
//                        LocalizedText(key: "primary_actions")
//                            .font(.system(size: 18, weight: .semibold))
//                            .foregroundColor( isDarkMode ? .white :  .black)
//                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
//                            Button(action: {
//                                route.navigate(to: .vitals)
//                            }) {
//                                ActionButton(icon: "vitals_icon", title: "vitals_details",dark: isDarkMode).padding(8)
//                            }
//                            
//                            Button(action: {
//                                route.navigate(to: .fluid)
//                            }) {
//                                ActionButton(icon: "fluid_icon", title: "fluid_intake_output",dark: isDarkMode).padding(8)
//                            }
//                            Button(action: {
//                                route.navigate(to: .symptoms)
//                            }) {
//                                ActionButton(icon: "symptoms_icon", title: "symptom_tracker", dark: isDarkMode)
//                                    .padding(8)
//                            }
//                            
//                            Button(action: {
//                                route.navigate(to: .pillsReminder)  
//                            }) {
//                            ActionButton(icon: "pills_icon", title: "pills_reminder",dark: isDarkMode).padding(8)
//                            
//                        }
//                            Button(action: {
//                                route.navigate(to: .suppliment)
//                            }) {
//                                ActionButton(icon: "diet", title: "diet_checklist",dark: isDarkMode).padding(8)
//                                
//                            }
//                            
//
////                                ActionButton(icon: "supplement_icon", title: "Supplement Checklist",dark: isDarkMode).padding(8)
//
//                        }
//                        LocalizedText(key: "other")
//                            .font(.system(size: 18, weight: .semibold))
//                            .foregroundColor( isDarkMode ? .white :  .black)
//                        
//                        HStack(spacing: 12) {
////                            ChronicleCard(dark: isDarkMode)
//                            VStack(spacing: 12) {
//                                Button(action: {
//                                    route.navigate(to: .reportViewUI)
//                                }) {
//                                    OtherCard(icon: "upload_icon", title: "upload_report",dark: isDarkMode)}
////                                OtherCard(icon: "lifestyle_icon", title: "Lifestyle Intervention",dark: isDarkMode)
//                            }
//                        }
//                        
//                    }.padding(.horizontal,20)
                    
//                    Text("Dashboard Screen")
//                    Button("Back") {
//                        route.back()
//                    }
//                    Button("Go to Root") {
//                        let okInstance = Ok(route: route)
//                        okInstance.myNavigation()
//                        //                           route.navigatoToRoot()
//                    }
                }
                CustomTabBar(dark: isDarkMode, selectedTab: $selectedTab)
//                CustomTabBar(dark: isDarkMode, selectedTab: $selectedTab) // Moved inside VStack
                
                    .onAppear(){
                        Task{
                                await vitalsVM.getVitals()
                        }
                    }
                    .sheet(isPresented: $viewModel.showConfirmationSheet) {
                        VStack(spacing: 16) {
                            Text("please_confirm_symptoms")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.top, 20)

                            ScrollView {
                                ForEach(viewModel.pendingSymptoms, id: \.id) { symptom in
                                    Text("• \(symptom.details)")
                                        .font(.title3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 16)
                                        .padding(.top, 4)
                                }
                            }.scrollIndicators(.visible)

                            HStack {
                                Button("cancel") {
                                    viewModel.showConfirmationSheet = false
                                }
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .background(Color.textGrey.opacity(0.1))
                                .foregroundColor(.textGrey)
                                .cornerRadius(8)
                                .padding(.horizontal, 16)

                                Spacer()

                                Button("yes_save") {
                                    viewModel.confirmSymptoms()
                                }
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.horizontal, 16)
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 24)

                            Spacer()
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                        .cornerRadius(20)  // Added corner radius to the sheet
                        .presentationDetents([.height(350)])
                    }

            }


            .navigationBarHidden(true) // Hides the default AppBar
            
           
            if viewModel.showVoiceAssistant {
                Voiceassistantview()
                           .transition(.move(edge: .bottom))
             
                   }
            
            VStack{
                Spacer()
                HStack {
                    Spacer()
                
                        
                    
                    Image(systemName: "mic.fill")
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Circle().fill(Color.blue))
                        .padding(.trailing, 20)
                        .padding(.bottom, 80)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if !viewModel.showVoiceAssistant {
                                        viewModel.showVoiceAssistant = true
                                        print("started")
                                    }
                                }
                                .onEnded { _ in
                                    viewModel.hidePage()
                                }
                        )
                }
            }
            ZStack {
                if viewModel.isDrawerOpen {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                viewModel.isDrawerOpen.toggle()
                            }
                        }
                }
                SuccessPopupView(show: $viewModel.showSuccess, message: "symptoms_added_success")
                    .zIndex(1)
                SuccessPopupView(show: $viewModel.showVitalSuccess, message: "vitals_added_success")
                    .zIndex(1)
                SuccessPopupView(show: $viewModel.showFluidSuccess, message: "fluid_added_success")
                    .zIndex(1)
                
                SideMenuView()
                    .offset(x: viewModel.isDrawerOpen ? 0 : -500 + dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.width > 0 {
                                    dragOffset = value.translation.width
                                }
                            }
                            .onEnded { value in
                                if value.translation.width > 100 {
                                    viewModel.isDrawerOpen = true
                                } else {
                                    viewModel.isDrawerOpen = false
                                }
                                dragOffset = 0
                            }
                    )
            }
          
            .animation(.easeInOut, value: viewModel.isDrawerOpen)
            
            
        }
        
        .preferredColorScheme(themeManager.colorScheme) // Apply theme globally
        
    }
    
}


struct HomeView: View {
    @EnvironmentObject var route: Routing
    let isDarkMode: Bool
    

    var body: some View {
        VStack(alignment: .leading){
            
            LocalizedText(key:"vitals")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor( isDarkMode ? .white :  .black)
       
                VitalsCard(dark: isDarkMode)

//                        Button("Show Global Popup") {
//
//                            viewModel.showError(message: "Error check")
////                            popupManager.show(
////
////                                message: "This is test popup")
//                        }


            LocalizedText(key: "primary_actions")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor( isDarkMode ? .white :  .black)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                Button(action: {
                    route.navigate(to: .vitals)
                }) {
                    ActionButton(icon: "vitals_icon", title: "vitals_details",dark: isDarkMode).padding(8)
                }
                
                Button(action: {
                    route.navigate(to: .fluid)
                }) {
                    ActionButton(icon: "fluid_icon", title: "fluid_intake_output",dark: isDarkMode).padding(8)
                }
                Button(action: {
                    route.navigate(to: .symptoms)
                }) {
                    ActionButton(icon: "symptoms_icon", title: "symptom_tracker", dark: isDarkMode)
                        .padding(8)
                }
                
                Button(action: {
                    route.navigate(to: .pillsReminder)
                }) {
                ActionButton(icon: "pills_icon", title: "pills_reminder",dark: isDarkMode).padding(8)
                
            }
                Button(action: {
                    route.navigate(to: .suppliment)
                }) {
                    ActionButton(icon: "diet", title: "diet_checklist",dark: isDarkMode).padding(8)
                    
                }
                

//                                ActionButton(icon: "supplement_icon", title: "Supplement Checklist",dark: isDarkMode).padding(8)

            }
            LocalizedText(key: "other")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor( isDarkMode ? .white :  .black)
            
            HStack(spacing: 12) {
//                            ChronicleCard(dark: isDarkMode)
                VStack(spacing: 12) {
                    Button(action: {
                        route.navigate(to: .reportViewUI)
                    }) {
                        OtherCard(icon: "upload_icon", title: "upload_report",dark: isDarkMode)}
//                                OtherCard(icon: "lifestyle_icon", title: "Lifestyle Intervention",dark: isDarkMode)
                }
            }
            
        }.padding(.horizontal,20)
    }
}

struct GreetingView: View {
    let dark: Bool

    var body: some View {
        CustomText(greetingMessage(), color: dark ? .white : .black)
            .font(.footnote)
    }

    func greetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<10:
            return "good_morning"
        case 10..<15:
            return "good_afternoon"
        case 15..<19:
            return "good_evening"
        default:
            return "good_night"
        }
    }
}


struct CustomAppBar: View {
    var userData = UserDefaultsManager.shared.getUserData()
    var onBack: (() -> Void)?
    var onMenuTap: (() -> Void)?
    let dark: Bool
    @EnvironmentObject var viewModel : DashboardViewModal
    @EnvironmentObject var editProfileVM : EditProfileViewModal
    @EnvironmentObject var route: Routing
    @State private var showSosSheet = false

    
    var body: some View {
        HStack {
            Button(action: {
                onMenuTap?()
                viewModel.isDrawerOpen.toggle()
            }) {
                HStack(spacing: 10) {
                    if editProfileVM.loadingImage {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    } else {
                        RemoteImage(url: UserDefaultsManager.shared.getUserData()?.profileUrl)
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        GreetingView(dark: dark)
                        CustomText(userData?.patientName ?? "", color: dark ? .white : .black)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle()) // Avoid default blue tint on tap

            Spacer()
            Button(action:{
                route.navigate(to: .NotificationView)
            }){
                Image("Notification")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            

            Button(action: {
                showSosSheet = true
            }) {
                Image(dark ? "sosDark" : "sos")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
            }
        }
        .padding()
        .background(dark ? Color.black : Color.white)
        .sheet(isPresented: $showSosSheet) {
            SosBottomSheet(showSheet: $showSosSheet)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
    }

}
 

struct CustomTabBar: View {
    let dark: Bool
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(icon: "home", title: "home", tab: .home, selectedTab: $selectedTab)
            TabBarItem(icon: "reminder", title: "reminders", tab: .reminders, selectedTab: $selectedTab)
            TabBarItem(icon: "chat", title: "chat", tab: .chat, selectedTab: $selectedTab)
        }
        .padding(.horizontal, 16)
        .frame(height: 70)
        .background(
            (dark ? Color.black : Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -4)
        )
    }
}


struct TabBarItem: View {
    var icon: String
    var title: String
    var tab: Tab
    @Binding var selectedTab: Tab

    var body: some View {
        VStack(spacing: 6) {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(selectedTab == tab ? .blue : .gray)
            
            Text(title.capitalized)
                .font(.caption2)
                .foregroundColor(selectedTab == tab ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
        .onTapGesture {
            selectedTab = tab
        }
    }
}



enum Tab {
    case home, reminders, chat
}





struct VitalsCard: View {
    let dark: Bool
    @EnvironmentObject var vitalsVM: VitalsViewModal
    @EnvironmentObject var route: Routing
    @State private var currentVitalIndex = 0
    @State private var currentVital: Vital?

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(dark ? Color.customBackgroundDark : Color.customBackground)
                .overlay(
                    HStack {
                        // Left section: icon + name + time
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: vitalsVM.iconName(for: currentVital?.vitalName))
                                    .foregroundColor(.blue)
                                Text(currentVital?.vitalName ?? "—")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(dark ? .white : .black)
                            }

                            Text(vitalTimeText())
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        // Right section: value or Add button
                        VStack(alignment: .trailing, spacing: 6) {
                            if  vitalDisplayValue  > "0" {
                                Text("\(vitalDisplayValue) \(currentVital?.unit ?? "")")
                                    .font(.system(size: 20, weight: .light))
                                    .foregroundColor(dark ? .white : .black)
                                    .transition(.opacity.combined(with: .scale))
                                    .id(currentVital?.vitalID)

                                Button {
                                    Task {
                                        await vitalsVM.getVitals()
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text("Update")
                                        Image(systemName: "arrow.clockwise")
                                    }
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            } else {
                                Button {
                                    print("currentVital?.vitalName \(currentVital!.vitalName)")
                                    // Handle add vital action
                                    switch currentVital!.vitalName {
                                      case "Blood Pressure":
                                        vitalsVM.data = currentVital!.vitalName
                                        vitalsVM.unitData = vitalTimeText()
                                        vitalsVM.matchSelectedValue.append(contentsOf: ["vmValueBPSys", "vmValueBPDias"])
//                                            vitalsVM.matchSelectedValue = "vmValueBPSys"
//                                            vitalsVM.matchSelectedValue = "vmValueBPDias"
                                      case "Blood Oxygen (spo2)":
                                        vitalsVM.data = currentVital!.vitalName
                                        vitalsVM.unitData = vitalTimeText()
                                        vitalsVM.matchSelectedValue.append("vmValueSPO2")
//                                            vitalsVM.matchSelectedValue = "vmValueSPO2"
                                      case "Respiratory Rate":
                                        vitalsVM.data = currentVital!.vitalName
                                        vitalsVM.unitData = vitalTimeText()
                                        vitalsVM.matchSelectedValue.append("vmValueRespiratoryRate")
//                                            vitalsVM.matchSelectedValue = "vmValueRespiratoryRate"
                                      case "Heart Rate":
                                        vitalsVM.data = currentVital!.vitalName
                                        vitalsVM.unitData = vitalTimeText()
                                        vitalsVM.matchSelectedValue.append("vmValueHeartRate")
//                                            vitalsVM.matchSelectedValue = "vmValueHeartRate"
                                      case "Pulse":
                                        vitalsVM.data = currentVital!.vitalName
                                        vitalsVM.unitData = vitalTimeText()
                                        vitalsVM.matchSelectedValue.append("vmValuePulse")
//                                            vitalsVM.matchSelectedValue = "vmValuePulse"
                                      case "RBS":
                                        vitalsVM.data = currentVital!.vitalName
                                        vitalsVM.unitData = vitalTimeText()
                                        vitalsVM.matchSelectedValue.append("vmValueRbs")
//                                            vitalsVM.matchSelectedValue = "vmValueRbs"
                                      case "Body Temperature":
                                        vitalsVM.data = currentVital!.vitalName
                                        vitalsVM.unitData = vitalTimeText()
                                        vitalsVM.matchSelectedValue.append("vmValueTemperature")
//                                            vitalsVM.matchSelectedValue = "vmValueTemperature"
                                      case "Body Weight":
                                        vitalsVM.data = currentVital!.vitalName
                                        vitalsVM.unitData = vitalTimeText()
                                        vitalsVM.matchSelectedValue.append("weight")
//                                            vitalsVM.matchSelectedValue = "weight"
                                      case "Height":
                                        vitalsVM.data = currentVital!.vitalName
                                        vitalsVM.unitData = vitalTimeText()
                                        vitalsVM.matchSelectedValue.append("height")
//                                            vitalsVM.matchSelectedValue = "height"
                                      default:
                                        vitalsVM.matchSelectedValue = []
//                                            vitalsVM.matchSelectedValue = "" // or show an error
                                      }
                                    print("vitalsVM.matchSelectedValue \(vitalsVM.matchSelectedValue)")
                                    route.navigate(to: .addVitals)
                                } label: {
                                    HStack(spacing: 4) {
                                        Text("Add Vital")
                                        Image(systemName: "plus.circle")
                                    }
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .animation(.easeInOut(duration: 0.5), value: currentVital)
                )
                .frame(height: 80)
                .onAppear {
                    stopVitalsCycle()
                    startVitalsCycle()
                }

            // Pagination dots
            HStack(spacing: 6) {
                Spacer()
                ForEach(0..<vitalsVM.groupedVitals.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentVitalIndex ? Color.primaryBlue : Color.gray.opacity(0.3))
                        .frame(width: index == currentVitalIndex ? 20 : 6,
                               height: index == currentVitalIndex ? 8 : 6)
                        .scaleEffect(index == currentVitalIndex ? 1.2 : 1.0)
                        .animation(.bouncy(duration: 1), value: currentVitalIndex)
                }
                Spacer()
            }

            Spacer().frame(height: 20)
        }
    }

    // MARK: - Time Formatting
    func vitalTimeText() -> String {
        guard let name = currentVital?.vitalName else {
            return "Not yet uploaded"
        }

        if name == "BP_Sys" || name == "BP_Dias" || name == "Blood Pressure" {
            // Try to get datetime from BP_Sys or BP_Dias
            let sysTime = vitalsVM.vitals.first(where: { $0.vitalName == "BP_Sys" })?.vitalDateTime
            let diasTime = vitalsVM.vitals.first(where: { $0.vitalName == "BP_Dias" })?.vitalDateTime

            if let sysTime = sysTime, !sysTime.isEmpty {
                return timeAgo(from: sysTime)
            } else if let diasTime = diasTime, !diasTime.isEmpty {
                return timeAgo(from: diasTime)
            } else {
                return "Not yet uploaded"
            }
        }

        // Default case for all other vitals
        if let value = currentVital?.vitalValue, value > 0 {
            return timeAgo(from: currentVital?.vitalDateTime ?? "")
        } else {
            return "Not yet uploaded"
        }
    }



    func timeAgo(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = .current

        guard let date = formatter.date(from: dateString) else {
            return "—"
        }

        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .short
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
    
    var vitalDisplayValue: String {
        let name = currentVital?.vitalName ?? ""
        print("\(name) names")

        if name == "Blood Pressure"{
            let sys = vitalsVM.vitals.first(where: { $0.vitalName == "BP_Sys" })?.vitalValue
            let dias = vitalsVM.vitals.first(where: { $0.vitalName == "BP_Dias" })?.vitalValue

            if let sys = sys, let dias = dias {
                return "\(Int(sys))/\(Int(dias))"
            } else if let sys = sys {
                return "\(Int(sys))/--"
            } else if let dias = dias {
                return "--/\(Int(dias))"
            } else {
                return "-/-"
            }
        }

        if let value = currentVital?.vitalValue {
            return "\(Int(value))"
        } else {
            return "Not available"
        }
    }




    // MARK: - Auto cycling
    func startVitalsCycle() {
        guard !vitalsVM.groupedVitals.isEmpty else { return }
        print("currentVitalIndex \(currentVitalIndex)")
        currentVital = vitalsVM.groupedVitals[currentVitalIndex]
        print("currentVital \(currentVital!.vitalName)")
        vitalsVM.vitalsTimer?.invalidate()
        vitalsVM.vitalsTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            withAnimation {
                currentVitalIndex = (currentVitalIndex + 1) % vitalsVM.groupedVitals.count
                currentVital = vitalsVM.groupedVitals[currentVitalIndex]
            }
        }
    }

    func stopVitalsCycle() {
        vitalsVM.vitalsTimer?.invalidate()
        vitalsVM.vitalsTimer = nil
    }
}




struct ActionButton: View {
    let icon: String
    let title: String
    let dark: Bool
    @ObservedObject private var localizer = LocalizationManager.shared
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            Text(localizer.localizedString(for: title)) // ✅ Localized string here
                .font(.system(size: 14, weight: .light))
                .foregroundColor(dark ? .white : .black)
                .multilineTextAlignment(.center)
                .frame(height: 40) // Keeps text height uniform
                .lineLimit(2)
        }
        .frame(width: 100, height: 120) // Ensures uniform button size
        .padding(8) // Adds spacing around button
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(dark ? Color.customBackgroundDark : Color.customBackground)
        )
    }
}


struct ChronicleCard: View {
    let dark: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(dark ? Color.customBackgroundDark : Color.customBackground)
          
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    Text("activities")
                        .font(.system(size: 14))
                        .foregroundColor( dark ? .white : .gray)
                    
                    Text("chronicle")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor( dark ? .white : .black)
                    
                    Image("cyclist_icon") // Add to assets
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                    
                    Text("share_today_activity")
                        .font(.system(size: 14))
                        .foregroundColor( dark ? .white : .black)
                    
                    Button(action: {}) {
                        Text("add_now")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.primaryBlue)
                            .cornerRadius(8)
                    }
                }
                .padding()
            )
            .frame(width: 180, height: 240)
    }
}



struct OtherCard: View {
    let icon: String
    let title: String
    let dark: Bool
    @ObservedObject private var localizer = LocalizationManager.shared
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(dark ? Color.customBackgroundDark : Color.customBackground)
            .overlay(
                VStack(spacing: 8) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Text(localizer.localizedString(for: title)) // ✅ Localized string here
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor( dark ? .white : .black)
                }
                .padding()
            )
            .frame(width: 180, height: 100)
    }
}



class Ok {
    var route: Routing
    
    init(route: Routing) {
        self.route = route
    }
    
    func myNavigation() {
        route.navigatoToRoot()
    }
}

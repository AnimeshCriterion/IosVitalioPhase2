
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

    @GestureState private var isPressing = false

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
                    VStack(alignment: .leading){
                        Text("Vitals")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor( isDarkMode ? .white :  .black)
                   
                        if(vitalsVM.vitals.isEmpty) {
                            ProgressView()
                        }else{
                            VitalsCard(dark: isDarkMode)
                        
                        }
         

                        Text("Primary Actions")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor( isDarkMode ? .white :  .black)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            Button(action: {
                                route.navigate(to: .vitals)
                            }) {
                                ActionButton(icon: "vitals_icon", title: "Vitals Details",dark: isDarkMode).padding(8)
                            }
                            
                            Button(action: {
                                route.navigate(to: .fluid)
                            }) {
                                ActionButton(icon: "fluid_icon", title: "Fluid Intake\n/Output",dark: isDarkMode).padding(8)
                            }
                            Button(action: {
                                route.navigate(to: .symptoms)
                            }) {
                                ActionButton(icon: "symptoms_icon", title: "Symptom Tracker", dark: isDarkMode)
                                    .padding(8)
                            }
                            
                            Button(action: {
                                route.navigate(to: .pillsReminder)  
                            }) {
                            ActionButton(icon: "pills_icon", title: "Pills Reminder",dark: isDarkMode).padding(8)
                            
                        }
                            Button(action: {
                                route.navigate(to: .suppliment)
                            }) {
                                ActionButton(icon: "diet", title: "Diet Checklist",dark: isDarkMode).padding(8)
                                
                            }
                            

//                                ActionButton(icon: "supplement_icon", title: "Supplement Checklist",dark: isDarkMode).padding(8)

                        }
                        Text("Other")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor( isDarkMode ? .white :  .black)
                        
                        HStack(spacing: 12) {
//                            ChronicleCard(dark: isDarkMode)
                            VStack(spacing: 12) {
                                Button(action: {
                                    route.navigate(to: .reportViewUI)
                                }) {
                                    OtherCard(icon: "upload_icon", title: "Upload Report",dark: isDarkMode)}
//                                OtherCard(icon: "lifestyle_icon", title: "Lifestyle Intervention",dark: isDarkMode)
                            }
                        }
                        
                    }.padding(.horizontal,20)
                    
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
                CustomTabBar(dark: isDarkMode, selectedTab: $selectedTab) // Moved inside VStack
                
                    .onAppear(){
                        Task{
                                await vitalsVM.getVitals()
                        }
                    }
                    .sheet(isPresented: $viewModel.showConfirmationSheet) {
                        VStack(spacing: 16) {
                            Text("Please confirm Symptoms")
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
                                Button("Cancel") {
                                    viewModel.showConfirmationSheet = false
                                }
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .background(Color.textGrey.opacity(0.1))
                                .foregroundColor(.textGrey)
                                .cornerRadius(8)
                                .padding(.horizontal, 16)

                                Spacer()

                                Button("Yes, Save") {
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
                SuccessPopupView(show: $viewModel.showSuccess, message: "Symptoms Added Successfully!")
                    .zIndex(1)
                SuccessPopupView(show: $viewModel.showVitalSuccess, message: "Vitals Added Successfully!")
                    .zIndex(1)
                SuccessPopupView(show: $viewModel.showFluidSuccess, message: "Fluid Added Successfully!")
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




struct GreetingView: View {
    let dark: Bool

    var body: some View {
        CustomText(greetingMessage(), color: dark ? .white : .black)
            .font(.footnote)
    }

    func greetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<21:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
}


struct CustomAppBar: View {
    var userData = UserDefaultsManager.shared.getUserData()
    var onBack: (() -> Void)?
    var onMenuTap: (() -> Void)?
    let dark: Bool
 
    @State private var showSosSheet = false
 
    var body: some View {
        HStack {
            Button(action: {
                onMenuTap?()
            }) {
                Image("dp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
 
            VStack(alignment: .leading) {
                CustomText("Good Morning", color: dark ? .white : .black)
                    .font(.footnote)
                CustomText(userData!.patientName, color: dark ? .white : .black)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
 
            Spacer()
 
            Image("Notification")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
 
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
        HStack {
            TabBarItem(icon: "home", title: "Home", tab: .home, selectedTab: $selectedTab)
//                       TabBarItem(icon: "activity", title: "Activity", tab: .activity, selectedTab: $selectedTab)
     
                TabBarItem(icon: "reminder", title: "Reminders", tab: .reminders, selectedTab: $selectedTab)
                    .padding()
            
             
                       TabBarItem(icon: "Chat", title: "Chat", tab: .chat, selectedTab: $selectedTab)
        }
        .frame(height: 70)
        .background(
            (dark ? Color.customBackgroundDark :  Color.white)
                       .overlay(
                           Rectangle()
                               .fill(Color.black.opacity(0.1))
                               .frame(height: 1) // Height of the shadow line
                               .offset(y: -5), // Offset to place the shadow at the top
                           alignment: .top
                       )
               )
    }
}

struct TabBarItem: View {
    var icon: String
    var title: String
    var tab: Tab
    @Binding var selectedTab: Tab
    @EnvironmentObject var route: Routing
    var body: some View {
        VStack(spacing: 4) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(icon == "home" ? .blue : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(icon == "home" ? .blue : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
        .onTapGesture {
            
            selectedTab = tab
            print("Reminders tab tapped")
            
            if(selectedTab == .reminders){
              route.navigate(to: .pillsReminder)
            }
        }
    }
}


enum Tab {
    case home, activity, reminders, chat
}




struct VitalsCard: View {
    let dark: Bool
    @EnvironmentObject var vitalsVM: VitalsViewModal
    
    @State private var currentVitalIndex = 0
    @State private var currentVital: Vital?

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(dark ? Color.customBackgroundDark : Color.customBackground)
                .overlay(
                    HStack {
                        VStack(alignment: .leading) {
                            Text(currentVital?.vitalName ?? "—")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(dark ? .white : .black)
                            
                            Text(timeAgo(from: currentVital?.vitalDateTime ?? ""))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)

                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            // Animate the vital value
                            Text("\(Int(currentVital?.vitalValue ?? 0)) \(currentVital?.unit ?? "")")
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(dark ? .white : .black)
                                .transition(.opacity.combined(with: .scale))
                                .id(currentVital?.vitalID) // trigger animation on change
                            
                            Button("Update") {
                                
                                Task{
                                  
                                        Task{
                                            await vitalsVM.getVitals()
                                        }
                                      
                                    
                                }
                            }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray.opacity(0.7))
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
        }
        HStack(spacing: 6) {
            Spacer()
            ForEach(0..<vitalsVM.vitals.count, id: \.self) { index in
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
    func timeAgo(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = .current
        
        guard let date = formatter.date(from: dateString) else {
            return dateString // fallback
        }
        
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .short // e.g. "1 hr ago"
        
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }



     func startVitalsCycle() {
        guard !vitalsVM.vitals.isEmpty else { return }
        currentVital = vitalsVM.vitals[currentVitalIndex]
        
        // Invalidate if an existing timer is running
         vitalsVM.vitalsTimer?.invalidate()
        
         vitalsVM.vitalsTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            withAnimation {
                currentVitalIndex = (currentVitalIndex + 1) % vitalsVM.vitals.count
                currentVital = vitalsVM.vitals[currentVitalIndex]
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

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            Text(title)
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
                    Text("Activities")
                        .font(.system(size: 14))
                        .foregroundColor( dark ? .white : .gray)
                    
                    Text("Chronicle")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor( dark ? .white : .black)
                    
                    Image("cyclist_icon") // Add to assets
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                    
                    Text("Share today's activities with us to understand your health pattern.")
                        .font(.system(size: 14))
                        .foregroundColor( dark ? .white : .black)
                    
                    Button(action: {}) {
                        Text("Add Now")
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
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(dark ? Color.customBackgroundDark : Color.customBackground)
            .overlay(
                VStack(spacing: 8) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Text(title)
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

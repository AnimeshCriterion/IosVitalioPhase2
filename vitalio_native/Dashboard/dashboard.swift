
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
    @State private var selectedTab: Tab = .home
    @State private var dragOffset: CGFloat = 0

       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }

    var body: some View {
        ZStack{
            VStack {
                Button(action: {
                    viewModel.isDrawerOpen.toggle()
                }) {
                    CustomAppBar(onBack: {
                        presentationMode.wrappedValue.dismiss()
                    }, dark: isDarkMode)}
                ScrollView {
                    VStack(alignment: .leading){
                        Text("Vitals")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor( isDarkMode ? .white :  .black)
                        VitalsCard(dark:  isDarkMode)
                        Text("Primary Actions")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor( isDarkMode ? .white :  .black)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            ActionButton(icon: "vitals_icon", title: "Vitals Details",dark: isDarkMode).padding(8) // Adds padding around each button
                            
                            Button(action: {
                                route.navigate(to: .fluid)
                            }) {
                                ActionButton(icon: "fluid_icon", title: "Fluid Intake\n/Output",dark: isDarkMode).padding(8) // Adds padding around each button
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
                            ActionButton(icon: "pills_icon", title: "Pills Reminder",dark: isDarkMode).padding(8) // Adds padding around each button
                            
                        }
                            ActionButton(icon: "diet", title: "Diet Checklist",dark: isDarkMode).padding(8) // Adds padding around each button
                            
                            
                            
                            Button(action: {
                                route.navigate(to: .suppliment)
                            }) {
                                ActionButton(icon: "supplement_icon", title: "Supplement Checklist",dark: isDarkMode).padding(8) // Adds padding around each button
                            }
                        }
                        Text("Other")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor( isDarkMode ? .white :  .black)
                        
                        HStack(spacing: 12) {
                            ChronicleCard(dark: isDarkMode)
                            VStack(spacing: 12) {
                                OtherCard(icon: "upload_icon", title: "Upload Report",dark: isDarkMode)
                                OtherCard(icon: "lifestyle_icon", title: "Lifestyle Intervention",dark: isDarkMode)
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
            }
            .navigationBarHidden(true) // Hides the default AppBar
            
            
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
            
        }  .preferredColorScheme(themeManager.colorScheme) // Apply theme globally
        
    }
}







struct CustomAppBar: View {
    var onBack: (() -> Void)?
    @State private var isDrawerOpen = false
    @State private var dragOffset: CGFloat = 0
    let dark: Bool
 
    
    var body: some View {
        HStack {

                Image("dp") // Load from assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
          
            VStack(alignment: .leading) {
            
                CustomText("Good Morning", color: dark ? .white : .black)
                    .font(.footnote)
                CustomText("Abhay Sharma", color:  dark ? .white : .black)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            Spacer()
            Image("Notification")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24) 
            Image( dark ? "sosDark": "sos")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
        }
        .padding()
        .background(dark ? Color.black : Color.white)
    }
}


struct CustomTabBar: View {
    let dark: Bool
    @Binding var selectedTab: Tab

    var body: some View {
        HStack {
            TabBarItem(icon: "home", title: "Home", tab: .home, selectedTab: $selectedTab)
                       TabBarItem(icon: "activity", title: "Activity", tab: .activity, selectedTab: $selectedTab)
                       TabBarItem(icon: "reminder", title: "Reminders", tab: .reminders, selectedTab: $selectedTab)
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

    var body: some View {
        VStack(spacing: 4) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(selectedTab == tab ? .blue : .gray)

            Text(title)
                .font(.caption)
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
    case home, activity, reminders, chat
}


struct VitalsCard: View {
    let dark: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(dark ? Color.customBackgroundDark :Color.customBackground)
            .overlay(
                HStack {
                    VStack(alignment: .leading) {
                        Text("Heart Rate")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(dark ? .white : .black)
                        Text("1hr ago")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("60 BPM")
                            .font(.system(size: 20, weight: .light))
                            .foregroundColor(dark ? .white : .black)
                    Button("Update") {}
                        .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.7))}
                }
                .padding()
            )
            .frame(height: 80)
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

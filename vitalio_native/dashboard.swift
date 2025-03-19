
import Foundation
import SwiftUI

struct Dashboard: View {
    
    @EnvironmentObject var route: Routing
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedTab: Tab = .home
    var body: some View {
           VStack {
              CustomAppBar(onBack: {
                              presentationMode.wrappedValue.dismiss()
                          })
               ScrollView {
                   VStack(alignment: .leading){
                       Text("Vitals")
                           .font(.system(size: 18, weight: .semibold))
                           .foregroundColor(.black)
                       VitalsCard()
                       Text("Primary Actions")
                           .font(.system(size: 18, weight: .semibold))
                           .foregroundColor(.black)
                       LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                           ActionButton(icon: "vitals_icon", title: "Vitals Details")
                           ActionButton(icon: "fluid_icon", title: "Fluid Intake\n/Output")
                           ActionButton(icon: "symptoms_icon", title: "Symptom Tracker")
                           ActionButton(icon: "pills_icon", title: "Pills Reminder")
                           ActionButton(icon: "diet", title: "Diet Checklist")
                           ActionButton(icon: "supplement_icon", title: "Supplement Checklist")
                       }
                       Text("Other")
                           .font(.system(size: 18, weight: .semibold))
                           .foregroundColor(.black)

                       HStack(spacing: 12) {
                           ChronicleCard()
                           VStack(spacing: 12) {
                               OtherCard(icon: "upload_icon", title: "Upload Report")
                               OtherCard(icon: "lifestyle_icon", title: "Lifestyle Intervention")
                           }
                       }

                   }.padding(.horizontal,20)
                      
                   Text("Dashboard Screen")
                   Button("Back") {
                       route.back()
                   }
                   Button("Go to Root") {
                       let okInstance = Ok(route: route)
                                  okInstance.myNavigation()
//                           route.navigatoToRoot()
                   }
                          }
    

               CustomTabBar(selectedTab: $selectedTab) // Moved inside VStack
           }
           .navigationBarHidden(true) // Hides the default AppBar
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


struct CustomAppBar: View {
    var onBack: (() -> Void)? // Optional back action

    var body: some View {
        HStack {
            Image("dp") // Load from assets
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
          
            VStack(alignment: .leading) {
            
                Text("Good Morning")
                    .font(.footnote)
                Text("Abhay Sharma")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            Spacer()
            Image("Notification") // Load from assets
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24) 
            Image("sos") // Load from assets
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
        }
        .padding()
        .background(Color.white)
    }
}


struct CustomTabBar: View {
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
                   Color.white
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
            Image(icon) // Load from assets
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
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.customBackground)
            .overlay(
                HStack {
                    VStack(alignment: .leading) {
                        Text("Heart Rate")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                        Text("1hr ago")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("60 BPM")
                            .font(.system(size: 20, weight: .light))
                            .foregroundColor(.black)
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
    
    var body: some View {
        VStack( alignment: .center, spacing: 8) {
            
            Image(icon) // Image from assets
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text(title)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.customBackground)
        )
    }
}


struct ChronicleCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.customBackground)
          
            .overlay(
                VStack(alignment: .leading, spacing: 8) {
                    Text("Activities")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Text("Chronicle")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Image("cyclist_icon") // Add to assets
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                    
                    Text("Share today's activities with us to understand your health pattern.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Button(action: {}) {
                        Text("Add Now")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
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
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.customBackground)
            .overlay(
                VStack(spacing: 8) {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Text(title)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.black)
                }
                .padding()
            )
            .frame(width: 180, height: 100)
    }
}


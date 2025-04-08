//
//  drawer.swift
//  vitalio_native
//
//  Created by HID-18 on 24/03/25.
//

import SwiftUI


struct SideMenuView: View {
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager
       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }
    
    var body: some View {
        ZStack {
            (isDarkMode ? Color.customBackgroundDark : Color.customBackground2).ignoresSafeArea()
            ScrollView{
                VStack {
                    VStack(
                        alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                            Spacer()
                            
                            HStack {
                                Image("left").frame(maxWidth:  .infinity, alignment: .leading).padding(10)
                                Image(systemName: "ellipsis")
                                    .font(.title3)
                                    .padding(10)
                                    .rotationEffect(.degrees(90))
                            }
                            Spacer()
                            Image("dp").frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            
                            CustomText("Abhay Sharma", color:    isDarkMode ? Color.white:  Color.black, size: 24, weight: Font.Weight.semibold)
                            
                            CustomText("+91 xxxxxxxx",color: Color.gray, size: 18, weight: Font.Weight.semibold)
                            Spacer()
                            Button(action: {
                                route.navigate(to: .editProfile)
                            }) {
                                HStack {
                                    Text("Edit Profile")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .frame(height: 30)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.primaryBlue)
                                .cornerRadius(15)
                            }
                            Spacer()
                        }
                        .frame(height: 310)
                        .background(isDarkMode ? Color.customBackgroundDark2 : Color.white)
                        .cornerRadius(15)
                        .padding()
                    VStack{
                        
                        DrawerTile(title: "Allergies", iconName: "allergies", dark: isDarkMode )
                        
                        DrawerTile(title: "Switch account", iconName: "addmember", dark: isDarkMode )
                        DrawerTile(title: "Connect Smart Watch", iconName: "watch", dark: isDarkMode )
                        DrawerTile(title: "Add Member", iconName: "addmember", dark: isDarkMode )
                        
                    }
                    .padding(10)
                    
                    VStack{
                        
                        GroupedDrawerTile(title: "Language", iconName: "language", dark: isDarkMode)
                        Button(action: {
                            route.navigate(to: .darkmode)
                        }) {
                            GroupedDrawerTile(title: "Dark Mode", iconName: "darkmode", dark: isDarkMode)}
                        Button(action: {
                            route.navigate(to: .faqView)
                        }) {
                            GroupedDrawerTile(title: "FAQs", iconName: "faq", dark: isDarkMode)
                        }
                        Button(action: {
                            route.navigate(to: .feedback)
                        }) {
                            GroupedDrawerTile(title: "Feedback", iconName: "feedback", dark: isDarkMode)
                        }
                        
                    }
                    .background( isDarkMode ?Color.customBackgroundDark2 : Color.white)
                    .cornerRadius(15)
                    .padding(10)
                }
            }
        }
    }
}

struct drawer: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isDrawerOpen = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Button(action: {
                isDrawerOpen.toggle()
            }) {
                Text("Main Content")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            ZStack {
                if isDrawerOpen {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isDrawerOpen.toggle()
                            }
                        }
                }
                
                SideMenuView()
                    .offset(x: isDrawerOpen ? 0 : -500 + dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.width > 0 {
                                    dragOffset = value.translation.width
                                }
                            }
                            .onEnded { value in
                                if value.translation.width > 100 {
                                    isDrawerOpen = true
                                } else {
                                    isDrawerOpen = false
                                }
                                dragOffset = 0
                            }
                    )
            }
            .preferredColorScheme(themeManager.colorScheme) // Apply theme globally
            .animation(.easeInOut, value: isDrawerOpen)
        }
    }
}




#Preview {
    drawer()
        .environmentObject(ThemeManager())
}

struct DrawerTile: View {
    var title: String
    var iconName: String
    var dark : Bool

    var body: some View {
        HStack {
            Image(iconName)
                .font(.title2)
                .frame(height: 20)
                .foregroundColor( dark ? .red : .gray).padding(.leading, 16)
            CustomText(title,color: dark ? Color.white : Color.black)
                .font(.title3)
                .padding(.leading, 10)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(10)
        }
        .padding(5)
        .background(dark ? Color.customBackgroundDark2 : Color.white)
        .cornerRadius(8)
    }
}

struct GroupedDrawerTile: View {
    
    var title: String
    var iconName: String
    var dark : Bool

    var body: some View {
        HStack {
            Image(iconName)
                .font(.title2)
                .frame(height: 20)
                .foregroundColor(.blue).padding(.leading, 16)
            CustomText(title,color: dark ? Color.white: Color.black)
                .font(.title3)
                .padding(.leading, 10)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(10)
        }
        .padding(5)
        .background(dark ? Color.customBackgroundDark2 :  Color.white)
    }
}

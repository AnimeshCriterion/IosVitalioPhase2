//
//  login.swift
//  Vitalio
//
//  Created by HID-18 on 17/03/25.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var viewModel: LoginViewModal
    @EnvironmentObject var themeManager: ThemeManager
    
    
       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }
    
    
    @EnvironmentObject var route: Routing
    
    
    var body: some View {
        ZStack {
            ScrollView{
//                Text("Empower Your Health with")
//                    .font(.system(size: 26, weight: .light))
//                    .foregroundColor(.white)        
                Text("Our Smart App!")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                VStack{
                    
//                    Spacer().frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                  
                    Image("loginDr")
                    VStack(alignment: .leading){
                        Spacer()
                            .frame(height:20)
                        Text("Login/Signup")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.blue)
                        
                        Spacer()
                            .frame(height: 13)
                        Text("Access your health records and services.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Spacer()
                            .frame(height: 32)
                        VStack(alignment: .leading) {
                            Text("Enter UHID/Mobile No.")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(height: 10)
                            HStack {
                                Image(systemName: "creditcard")
                                    .foregroundColor(.gray)
                                
                                TextField("Enter UHID/Mobile No.", text: $viewModel.uhidNumber)
                                    .font(.system(size: 14))
                                    .foregroundColor(isDarkMode ? .white : .black)
                                    .padding(.vertical, 12)
                                    .keyboardType(.default)
                                    .onChange(of: viewModel.uhidNumber) { newValue in
                                        // Allow only A-Z, a-z, 0-9 and limit to 10 characters
                                        let filtered = newValue.filter { $0.isLetter || $0.isNumber }
                                        viewModel.uhidNumber = String(filtered.prefix(10))
                                    }

                            }
                            .padding(.horizontal)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        Button(action: {
                            Task{
                                await viewModel.login(uhid: viewModel.uhidNumber, isLoggedIn: "0")
                                if case .success = viewModel.apiState {
                                    route.navigate(to: .otp)
                                }
                            }
                            
                        }) {
                            if case .loading = viewModel.apiState {
                                ProgressView()
                                
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                            } else {
                                Text("Send OTP")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(viewModel.uhidNumber.count  <= 6  ?   Color.gray.opacity(0.4) : Color.primaryBlue)
                                    .cornerRadius(10)
                            }
                        }
                        .disabled(viewModel.uhidNumber.isEmpty)
                        Spacer()
                            .frame(height: 32)
//                        Button(action: {
//                            Task{
//                    
//                                route.navigate(to: .createAccountView)
//                                
//                            }
//                            
//                        }) {
//                            Text("Dont have an account? **Sign Up.**")
//                                .font(.system(size: 12))
//                                .foregroundColor(.primaryBlue)
//                                .multilineTextAlignment(.center)
//                            .padding(.top, 8)
//                        }
                        Text("By signing in you agree to our **Terms & Conditions** and **Privacy Policy**")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }.padding(20)
                        .background(isDarkMode ? Color.customBackgroundDark : Color.white)
                        .cornerRadius(20)
                }
                .navigationBarHidden(true) // Hides the default AppBar
                .preferredColorScheme(themeManager.colorScheme)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primaryBlue)
                .edgesIgnoringSafeArea(.all)
            }
            .background(Color.primaryBlue)
            if viewModel.isLoggedIn == true {
                DeviceLimitPopup()
            }
        }
    }
}

#Preview {
    Login()
        .environmentObject(ThemeManager())
        .environmentObject(LoginViewModal())
}

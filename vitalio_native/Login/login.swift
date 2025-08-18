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
                        HStack {
                            Spacer()
                            Text("Login/Signup")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 13)
                        HStack {
                            Spacer()
                            Text("Access your health records and services.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 32)
                        VStack(alignment: .leading) {
                            Text("Employee ID ")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(height: 10)
                            HStack {
                                //                                Image(systemName: "creditcard")
                                //                                    .foregroundColor(.gray)
                                //
                                VStack{
                                    TextField("Employee ID ", text: $viewModel.uhidNumber)
                                        .font(.system(size: 14))
                                        .foregroundColor(isDarkMode ? .white : .black)
                                        .padding(.vertical, 12)
                                        .keyboardType(.default)
                                        .padding(.horizontal)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .onChange(of: viewModel.uhidNumber) { newValue in
                                            // All'onChange(of:perform:)' was deprecated in iOS 17.0: Use `onChange` with a two or zero parameter action closure instead.ow only A-Z, a-z, 0-9 and limit to 10 characters
                                            let filtered = newValue.filter { $0.isLetter || $0.isNumber }
                                            //                                            viewModel.uhidNumber = String(filtered.prefix(10))
                                        }
                                    HStack {
                                        Text("Enter Password")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    Spacer()
                                        .frame(height: 10)
                                    TextField("Password", text: $viewModel.password)
                                        .font(.system(size: 14))
                                        .foregroundColor(isDarkMode ? .white : .black)
                                        .padding(.vertical, 12)
                                        .keyboardType(.default)
                                        .onChange(of: viewModel.password) { newValue in
                                            // All'onChange(of:perform:)' was deprecated in iOS 17.0: Use `onChange` with a two or zero parameter action closure instead.ow only A-Z, a-z, 0-9 and limit to 10 characters
                                        }
                                        .padding(.horizontal)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                
                            }
                            
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        Button(action: {
                            Task{
                                await viewModel.CorporateEmployeeLogin()
                                if case .success = viewModel.apiState {
                                    route.navigateOnly(to: .dashboard)
                                }
                            }
                        }) {
                            if case .loading = viewModel.apiState {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                            } else {
                                Text("Login")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(
                                        LinearGradient(
                                            colors: viewModel.isButtonDisabled
                                            ? [Color.gray.opacity(0.4), Color.gray.opacity(0.4)] // Same color for disabled
                                            : [Color.primaryBlue, Color.cyan], // Gradient colors
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(10)
                                
                            }
                        }
                        .disabled(viewModel.isButtonDisabled || viewModel.uhidNumber.isEmpty)
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
                        Button(action: {
                            Task{
                                route.navigateOnly(to: .forgotPassword)
                            }
                        }) {
                        Text("Forgot password?")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        .padding(.top, 8)}
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

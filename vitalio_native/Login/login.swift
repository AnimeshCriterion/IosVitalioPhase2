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
            
        VStack{
            Spacer()
            Image("loginDr")
            VStack(alignment: .leading){
                Spacer()
                    .frame(height:20)
                    Text("Login!")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.blue)

               Spacer()
                    .frame(height: 13)
                     Text("Hey there! Get login to explore all features")
                         .font(.system(size: 14))
                         .foregroundColor(.gray)
                
                Spacer()
                     .frame(height: 32)
                     VStack(alignment: .leading) {
                         Text("Enter UHID No.")
                             .font(.system(size: 13))
                             .foregroundColor(.gray)
                         Spacer()
                             .frame(height: 10)
                         HStack {
                             Image(systemName: "creditcard")
                                 .foregroundColor(.gray)
                             
                             TextField("Enter UHID No.", text: $viewModel.uhidNumber)
                                 .font(.system(size: 14))
                                 .foregroundColor(isDarkMode ? .white: .black)
                                 .padding(.vertical, 12)
                                 .keyboardType(.default) // Ensures correct input type
                         }
                         .padding(.horizontal)
                         .background(Color.gray.opacity(0.1))
                         .cornerRadius(10)
                     }
                
                Spacer()
                     .frame(height: 20)
                     Button(action: {
                         Task{
                             await viewModel.login(uhid: viewModel.uhidNumber)
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
                     Text("By signing in you agree to our **Terms & Conditions** and **Privacy Policy**")
                         .font(.system(size: 12))
                         .foregroundColor(.gray)
                         .multilineTextAlignment(.center)
                         .padding(.top, 8)
            }.padding(20)
                .background(isDarkMode ? Color.customBackgroundDark :Color.white)
                .cornerRadius(20)
        }
        .preferredColorScheme(themeManager.colorScheme)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBlue)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    Login()
        .environmentObject(ThemeManager())
}

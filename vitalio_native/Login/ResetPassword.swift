//
//  ResetPassword.swift
//  vitalio_native
//
//  Created by HID-18 on 12/08/25.
//

import SwiftUI

struct ResetPassword: View {
    
    @EnvironmentObject var viewModel: LoginViewModal
    @EnvironmentObject var themeManager: ThemeManager
    
    
       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }
    
    
    @EnvironmentObject var route: Routing
    
    var body: some View {
        ZStack {
            ScrollView{
                Text("")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                VStack{
                  
                    Image("loginDr")
                    VStack(alignment: .leading){
                        Spacer()
                            .frame(height:20)
                        HStack {
                            Spacer()
                            Text("Let's keep the things safe")
                                .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.black)
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 13)
                        HStack {
                            Spacer()
                            Text("Create a strong password to protect your wellness journey.")
                                .font(.system(size: 14))
                            .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 32)
                        VStack(alignment: .leading) {
                            Text("Enter Current Password")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(height: 10)
                            HStack {
                                VStack{
                                    TextField("Enter Current Password", text: $viewModel.resetPasswordOld)
                                        .font(.system(size: 14))
                                        .foregroundColor(isDarkMode ? .white : .black)
                                        .padding(.vertical, 12)
                                        .keyboardType(.default)
                                        .padding(.horizontal)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .onChange(of: viewModel.resetPasswordOld) { newValue in
                                            
                                        }
                                }
                            }
                            
                            Text("New Password")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(height: 10)
                            HStack {
                                VStack{
                                    TextField("New Password", text: $viewModel.resetPasswordNew)
                                        .font(.system(size: 14))
                                        .foregroundColor(isDarkMode ? .white : .black)
                                        .padding(.vertical, 12)
                                        .keyboardType(.default)
                                        .padding(.horizontal)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .onChange(of: viewModel.resetPasswordNew) { newValue in
                                            
                                        }
                                }
                            }       
                            
                            
                            Text("Confirm New Password")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            Spacer()
                                .frame(height: 10)
                            HStack {
                                VStack{
                                    TextField("Confirm New Password", text: $viewModel.resetPasswordNewReEnter)
                                        .font(.system(size: 14))
                                        .foregroundColor(isDarkMode ? .white : .black)
                                        .padding(.vertical, 12)
                                        .keyboardType(.default)
                                        .padding(.horizontal)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .onChange(of: viewModel.resetPasswordNewReEnter) { newValue in
                                            
                                        }
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        Button(action: {
                            Task{
                                await viewModel.resetPasswordwithNew()
                            }
                        }) {
                            if 1 == 2 {  // Loader condition
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                            } else {
                                Text("Submit")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(
                                        LinearGradient(
                                            colors: (
                                                viewModel.resetPasswordOld.isEmpty ||
                                                viewModel.resetPasswordNew.isEmpty ||
                                                      viewModel.resetPasswordNewReEnter.isEmpty
                                                    )
                                                ? [Color.gray.opacity(0.4), Color.gray.opacity(0.4)]
                                            : [Color.primaryBlue, Color.cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(10)
                            }
                        }
                        .disabled( 
                            viewModel.resetPasswordNew.isEmpty ||
                            viewModel.resetPasswordOld.isEmpty ||
                            viewModel.resetPasswordNewReEnter.isEmpty
                        )
                        Spacer()
                            .frame(height: 32)
                    }.padding(20)
                        .background(isDarkMode ? Color.customBackgroundDark : Color.white)
                        .cornerRadius(20)
                }
                .navigationBarHidden(true)
                .preferredColorScheme(themeManager.colorScheme)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primaryBlue)
                .edgesIgnoringSafeArea(.all)
            }
            .background(Color.primaryBlue)
        }
    }
}

#Preview {
    ResetPassword()
        .environmentObject(ThemeManager())
        .environmentObject(LoginViewModal())
}

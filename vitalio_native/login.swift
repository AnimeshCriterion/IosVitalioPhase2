//
//  login.swift
//  Vitalio
//
//  Created by HID-18 on 17/03/25.
//

import SwiftUI

struct Login: View {
    @State private var uhidNumber: String = ""
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
                             
                             TextField("Enter UHID No.", text: $uhidNumber)
                                 .font(.system(size: 14))
                                 .foregroundColor(.black)
                                 .padding(.vertical, 12)
                         }
                         .padding(.horizontal)
                         .background(Color.gray.opacity(0.1))
                         .cornerRadius(10)
                     }
                
                Spacer()
                     .frame(height: 20)
                     Button(action: {
                         route.navigate(to: .otp)
                     }) {
                         Text("Send OTP")
                             .frame(maxWidth: .infinity)
                             .padding()
                             .foregroundColor(.white)
                             .background(Color.gray.opacity(0.4))
                             .cornerRadius(10)
                     }
                     .disabled(uhidNumber.isEmpty)
                Spacer()
                     .frame(height: 32)
                     Text("By signing in you agree to our **Terms & Conditions** and **Privacy Policy**")
                         .font(.system(size: 12))
                         .foregroundColor(.gray)
                         .multilineTextAlignment(.center)
                         .padding(.top, 8)
            }.padding(20)
            .background(Color.white)
                .cornerRadius(20)
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBlue)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    Login()
}

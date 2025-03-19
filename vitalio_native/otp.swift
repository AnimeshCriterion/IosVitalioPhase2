//
//  otp.swift
//  Vitalio
//
//  Created by HID-18 on 17/03/25.
//

import SwiftUI

struct OTPVerificationView: View {
    
    @State private var otp = ["", "", "", "", "", ""]
    @EnvironmentObject var route: Routing
    var body: some View {
        VStack{
            Spacer()
            Image("loginDr")
            VStack(spacing: 20) {
                // Title
                Text("Verify your UHID!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.blue)
                
                // Subtitle
                Text("Enter 6 digit verification code sent to your number")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                // OTP Fields
                HStack(spacing: 8) {
                    ForEach(0..<6, id: \.self) { index in
                        TextField("", text: $otp[index])
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 40, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .onChange(of: otp[index]) { oldValue, newValue in
                                if newValue.count > 1 {
                                    otp[index] = String(newValue.prefix(1))
                                }
                            }
                    }
                }
                
                // Verify Button
                Button(action: {
                    route.navigate(to: .dashboard)
                }) {
                    Text("Verify")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Resend OTP
                HStack {
                    Text("Didn’t receive the Code?")
                        .foregroundColor(.gray)
                    Button(action: {
                        // Action for Resend OTP
                    }) {
                        Text("Resend OTP")
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                }
                .font(.system(size: 14))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBlue)
        .edgesIgnoringSafeArea(.all)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


#Preview {
    OTPVerificationView()
}

import SwiftUI

struct OTPVerificationView: View {
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var viewModel: LoginViewModal

    var isDarkMode: Bool {
        themeManager.colorScheme == .dark
    }

    @State private var otp = ["", "", "", "", "", ""]
    @FocusState private var focusedIndex: Int?

    var body: some View {
   
                OTPContent(otp: $otp, focusedIndex: $focusedIndex, isDarkMode: isDarkMode)
//            .edgesIgnoringSafeArea(.all)
            .background(Color.primaryBlue)
            .navigationBarHidden(true)
        

    }
}

struct OTPContent: View {
    @Binding var otp: [String]
    @FocusState.Binding var focusedIndex: Int?
    var isDarkMode: Bool
    @EnvironmentObject var route: Routing
    @EnvironmentObject var viewModel: LoginViewModal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
//                Spacer()
                Image("loginDr")
                    .resizable()
                    .scaledToFit()
           

                VStack(spacing: 20) {
                    headerSection
                    otpFields
                    verifyButton
                    resendSection
                }
                .padding()
                .background(isDarkMode ? Color.customBackgroundDark : Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height, alignment: .topLeading) // ✅ This ensures full screen
            .background(Color.primaryBlue)
            .preferredColorScheme(ThemeManager().colorScheme)
            .onAppear {
                focusedIndex = 0
            }
        }


    }

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Verify your UHID!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.blue)
            Text("Enter 6 digit verification code sent to your number \(viewModel.extractedMobileNumber)")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var otpFields: some View {
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
                    .focused($focusedIndex, equals: index)
                    .onChange(of: otp[index]) { oldValue, newValue in
                        if newValue.count > 1 {
                            otp[index] = String(newValue.prefix(1))
                        }
                        if !newValue.isEmpty && index < 5 {
                            focusedIndex = index + 1
                        } else if newValue.isEmpty && index > 0 {
                            focusedIndex = index - 1
                        }
                    }
            }
        }
    }

    var verifyButton: some View {
        Button(action: {
            Task {
                print("📝 Entered UHID: \(viewModel.uhidNumber)")
                guard !viewModel.uhidNumber.isEmpty else {
                    print("⚠️ Cannot proceed! UHID is empty.")
                    return
                }

                await viewModel.verifyOTP(otp: otp.joined(), uhid: viewModel.uhidNumber)
                if case .success = viewModel.apiState {
                    route.navigateOnly(to: .dashboard)
                }
            }
        }) {
            Text("Verify")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }

    var resendSection: some View {
        HStack {
            Text("Didn’t receive the Code?")
                .foregroundColor(.gray)
            Button(action: {
                Task{
                    await viewModel.login(uhid: viewModel.uhidNumber)
                    if case .success = viewModel.apiState {
                   
                    }
                }
       
            }) {
                if case .loading = viewModel.apiState {
                    ProgressView()
                        .foregroundColor(.white)
                } else {
                    Text("Resend OTP")
                        .foregroundColor(.blue)
                    .fontWeight(.semibold)}
            }
        }
        .font(.system(size: 14))
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
        .environmentObject(ThemeManager())
        .environmentObject(LoginViewModal())
}

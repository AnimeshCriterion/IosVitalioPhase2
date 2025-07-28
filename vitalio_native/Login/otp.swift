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
        ZStack{
            ScrollView {
                VStack {
                    headerText
                    doctorImage
                    formContainer
                }
                .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height, alignment: .topLeading)
                .background(Color.primaryBlue)
                .preferredColorScheme(ThemeManager().colorScheme)
                .onAppear {
                    focusedIndex = 0
                }
            }
//            if viewModel.showToast {
//                       ToastView(message: "OTP does not matched or expired")
//                           .padding(.bottom, 40)
//                           .transition(.opacity)
//                   }
        }
    }
    
    var headerText: some View {
        VStack {
            Text("Empower Your Health with")
                .font(.system(size: 26, weight: .light))
                .foregroundColor(.white)
            Text("Our Smart App!")
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    var doctorImage: some View {
        Image("loginDr")
            .resizable()
            .scaledToFit()
    }
    
    var formContainer: some View {
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

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Login Verification!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.blue)
            
            Button(action: {
                route.navigateOnly(to: .login)
                print("Verification text tapped")
            }) {
                verificationText
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var verificationText: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Verification code sent to your mobile")
                .foregroundColor(.gray)
                .font(.system(size: 14))
            
            Text("+91 \(viewModel.uhidNumber)")
                .foregroundColor(.primaryBlue)
                .font(.system(size: 14))
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var otpFields: some View {
        VStack(alignment: .leading ,spacing: 4) {
            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { index in
                    otpTextField(for: index)
                }
            }

            if viewModel.isOTPInvalid {
                Text("OTP didn’t match!")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 4)
            }
        }
    }

    
    func otpTextField(for index: Int) -> some View {
        TextField("", text: $otp[index])
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .frame(width: 40, height: 50)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(viewModel.isOTPInvalid ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .background(viewModel.isOTPInvalid ? Color.red.opacity(0.1) : Color.gray.opacity(0.1))
            .focused($focusedIndex, equals: index)
            .onChange(of: otp[index]) { oldValue, newValue in
                handleOTPChange(index: index, oldValue: oldValue, newValue: newValue)
            }
            .onKeyPress(.delete) {
                handleBackspace(index: index)
            }
    }
    
    func handleOTPChange(index: Int, oldValue: String, newValue: String) {
        // Handle input: limit to single character
        if newValue.count > 1 {
            otp[index] = String(newValue.prefix(1))
            return
        }
        
        // Handle forward navigation (when user enters a digit)
        if !newValue.isEmpty && index < 5 {
            focusedIndex = index + 1
        }
        // Handle backward navigation (when user deletes/backspaces)
        else if newValue.isEmpty && !oldValue.isEmpty && index > 0 {
            focusedIndex = index - 1
        }
    }
    
    func handleBackspace(index: Int) -> KeyPress.Result {
        // Handle backspace when field is already empty
        if otp[index].isEmpty && index > 0 {
            focusedIndex = index - 1
            return .handled
        }
        return .ignored
    }

    var verifyButton: some View {
        Button(action: {
            Task {
                await handleVerification()
            }
        }) {
            Text("Verify")
                .frame(maxWidth: .infinity)
                .padding()
                .background(otp.joined().count < 6 ? Color.gray :Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }.disabled(otp.joined().count < 6)
    }
    
    func handleVerification() async {
        viewModel.isOTPInvalid = false // reset initially
        print("📝 Entered UHID: \(viewModel.uhidNumber)")
        guard !viewModel.uhidNumber.isEmpty else {
            print("⚠️ Cannot proceed! UHID is empty.")
            return
        }
        
        await viewModel.verifyOTP(otp: otp.joined(), uhid: viewModel.uhidNumber)
        if case .success = viewModel.apiState {
            if viewModel.isRegistered == false {
                route.navigateOnly(to: .createAccountView)
            } else {
                route.navigateOnly(to: .dashboard)
            }
        }
        else {
                viewModel.isOTPInvalid = true // trigger red error styling
            }
    }

    var resendSection: some View {
        VStack {
            Text("Didn't receive the Code?")
                .foregroundColor(.gray)
            
            Button(action: {
                Task {
                    await handleResendOTP()
                }
            }) {
                resendButtonContent
            }
        }
        .font(.system(size: 14))
    }
    
    var resendButtonContent: some View {
        Group {
            if case .loading = viewModel.apiState {
                ProgressView()
                    .foregroundColor(.white)
            } else {
                Text("Resend OTP")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
            }
        }
    }
    
    func handleResendOTP() async {
        await viewModel.login(uhid: viewModel.uhidNumber, isLoggedIn: "1")
        if case .success = viewModel.apiState {
            // Handle the successful resend logic here
        }
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

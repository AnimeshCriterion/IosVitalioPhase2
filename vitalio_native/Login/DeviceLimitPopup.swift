import SwiftUI

struct DeviceLimitPopup: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var viewModel: LoginViewModal
    @EnvironmentObject var route: Routing
    var isDarkMode: Bool {
        themeManager.colorScheme == .dark
    }
    var body: some View {
        VStack(spacing: 20) {
            Text("Already logged in on two devices")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                Task{
                    await viewModel.login(uhid: viewModel.uhidNumber, isLoggedIn: "1")
                    DispatchQueue.main.async {
                        viewModel.isLoggedIn = false
                    }
                    if case .success = viewModel.apiState {
                        route.navigate(to: .otp)
                    }
                }
              
            }) {
                Text("Logout other devices")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                DispatchQueue.main.async{
                    viewModel.isLoggedIn = false
                }

            }) {
                Text("Cancel")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(isDarkMode ? Color.white : .black)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(isDarkMode ? Color.customBackgroundDark : Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

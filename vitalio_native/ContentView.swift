import SwiftUI

struct ContentView: View {
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0

    var body: some View {
        NavigationStack(path: $route.navpath) {
            ZStack {
                Color.blue.edgesIgnoringSafeArea(.all)
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                logoScale = 1.0
                                logoOpacity = 1.0
                            }
                        }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if((UserDefaultsManager.shared.getIsLoggedIn() ?? nil) == true ){
                        route.navigate(to: .dashboard)
                    }else{
                        route.navigate(to: .login)
                    }
                }
            }
            .padding(0)
            .navigationDestination(for: Routing.AuthFlow.self) { destination in
                switch destination {
                case .onboarding:
                    Onboarding()
                case .dashboard:
                    Dashboard()
                case .login:
                    Login()
                case .otp:
                    OTPVerificationView()
                case .darkmode:
                    Darkmode()
                case .apiview:
                    APIView()
                case .symptoms:
                    SymptomTrackerView()
                case .editProfile:
                    EditProfile()
                case .pillsReminder:
                    PillsReminder()
                case .suppliment:
                    Suppliment()
                case .faqView:
                    FAQView()
                case .feedback:
                    Feedback()
                case .fluid:
                    Fluid()
                case .inputHistoryView:
                    InputView()       
                case .outputHistoryView:
                    OutputHistoryView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Routing())
}

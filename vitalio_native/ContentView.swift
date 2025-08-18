import SwiftUI

struct ContentView: View {
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager
//    @EnvironmentObject var popupManager: PopupManager
    @StateObject var popupManager = PopupManager.shared // observe shared instance
   
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0

    var body: some View {
        ZStack{
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
                        //                case .onboarding:
                        
                        //                    Onboarding()
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
                        Diet()
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
                    case .reportViewUI:
                        ReportViewUI()
                    case .sharedAccountView:
                        SharedAccountView()
                    case .addMemberView:
                        AddMemberView()
                    case .stillHaveSymptomsView:
                        StillHaveSymptomsView()
                    case .vitals:
                        VitalView()
                    case .addVitals:
                        AddVitalsView()
                    case .vitalHistory:
                        VitalHistoryView()
                    case .addLabReportView:
                        AddLabReportView()
                    case .dynamicResponseView:
                        DynamicResponseView()
                    case .allergies:
                        AllergiesView()
                    case .symptomsHistory:
                        SymptomsHistory()
                    case .chatBotView:
                        ChatBotView()
                    case .createAccountView:
                        CreateAccountView()
                    case .language:
                        Language()       
                    case .leaderboardView:
                        LeaderboardView()  
                    case .challengesView:
                        ChallengesView()        
                    case .forgotPassword:
                        FogotPassword()   
                    case .resetPassword:
                        ResetPassword()       
                    case .challengeDetailsView:
                        ChallengeDetailsView()
                    }}
            }
            // Popup layer
            if popupManager.isPresented {
                popupManager.popupContent
                    .transition(.opacity)
                    .zIndex(1)
                    .onTapGesture {
                        popupManager.hide()
                    }
            }
            }
        }
    }


#Preview {
    ContentView()
        .environmentObject(Routing())
        .environmentObject(PopupManager())
        .environmentObject(ThemeManager()) // assuming you use this
}

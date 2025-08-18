
import SwiftUI


final class Routing : ObservableObject{

    @Published var navpath = NavigationPath()
    enum AuthFlow: Hashable, Codable {
        
//        case onboarding
        case dashboard
        case login
        case otp
        case darkmode
        case apiview
        case symptoms
        case editProfile
        case pillsReminder 
        case suppliment       
        case faqView     
        case feedback   
        case fluid 
        case inputHistoryView
        case outputHistoryView 
        case reportViewUI
        case sharedAccountView
        case addMemberView
        case stillHaveSymptomsView
        case vitals
        case addVitals
        case vitalHistory
        case addLabReportView
        case dynamicResponseView   
        case allergies
        case symptomsHistory
        case chatBotView
        case createAccountView
        case language
        case leaderboardView
        case challengesView    
        case forgotPassword
        case resetPassword
        case challengeDetailsView
        
    }

    func navigate(to destination:  AuthFlow){
        navpath.append(destination)
    }
    
    
        func navigateOnly(to destination:  AuthFlow){
            navpath.removeLast()
            navpath.append(destination)
    }
    
    

    func back(){
        navpath.removeLast()
    }

    func navigatoToRoot(){
        if !navpath.isEmpty {
            navpath.removeLast(navpath.count)
        }
    }
    func replaceAllWith(_ destination: AuthFlow) {
        navpath = NavigationPath()
        navpath.append(destination)
    }

}


@MainActor
class AppState: ObservableObject {
    @Published var routing = Routing()
}

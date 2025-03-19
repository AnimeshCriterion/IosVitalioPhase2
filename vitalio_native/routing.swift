
import SwiftUI


final class Routing : ObservableObject{
    
    @Published var navpath = NavigationPath()
    enum AuthFlow: Hashable, Codable {
        case onboarding
        case dashboard
        case login
        case otp
    }
    
    func navigate(to destination:  AuthFlow){
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
    
}

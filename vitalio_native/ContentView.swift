
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var route: Routing
    
    init() {
           print("Init started")
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               print("Executed after 2 seconds!")
           }
       }
    
    var body: some View {
        NavigationStack(path: $route.navpath) {
            ZStack {
                Color.blue.edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Vitalio").foregroundColor(.white)
                        .font(.title)
                    Button("Onboarding") {
                        route.navigate(to: .onboarding)
                    }.padding()
                    .foregroundColor(.white)
                    Button("Login") {
                        route.navigate(to: .login)
                    }.padding()
                    .foregroundColor(.white)
                    Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                }}
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
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Routing())
}

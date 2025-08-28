//
//  challenges.swift
//  watchAooForTestingPurpose
//
//  Created by HID-18 on 24/07/25.
//

import SwiftUI

struct ChallengesView : View {
    @EnvironmentObject var vm : ChallengesviewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    
       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }
    
    
    @EnvironmentObject var route: Routing
    

    var body: some View {
        VStack {
//            CustomNavBarView(title: "" , isDarkMode: isDarkMode) {
//                route.back()
//            }
            HStack{
            
                Image("challengemind")
                    .resizable()
                    .frame(width: 46, height : 46)
                    .padding()
                VStack (alignment: .leading){
                    
                    Text("Challenges")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                    
                    Text("Your daily space for emotional balance and focus.")
                        .foregroundColor(.textGrey)
                        .font(.system(size: 13))
                }
            }
            ScrollView {
                VStack {
                    ChallengeToggleView()
                    if vm.JoinedChallenge == true {
                        JoinedChallenge()
                    }else{
                        NewChallenges()
                    }
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await vm.getChallenges()
                    await vm.getJoinedChallenges()
                }
            }
        }
    }
}








#Preview {
    ChallengesView()
}

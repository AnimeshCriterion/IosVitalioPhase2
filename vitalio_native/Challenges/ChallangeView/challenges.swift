//
//  challenges.swift
//  watchAooForTestingPurpose
//
//  Created by HID-18 on 24/07/25.
//

import SwiftUI

struct ChallengesView : View {
    @EnvironmentObject var vm : ChallengesviewModel

    var body: some View {
        VStack {
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

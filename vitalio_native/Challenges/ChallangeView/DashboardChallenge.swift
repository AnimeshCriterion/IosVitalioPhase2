//
//  DashboardChallenge.swift
//  vitalio_native
//
//  Created by HID-18 on 09/08/25.
//

import SwiftUI

struct DashboardChallengeView: View {
    @EnvironmentObject var vm: ChallengesviewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(vm.challenges, id: \.id) { challenge in
                    NewChallengeCard(challenge: challenge)
                        .frame(width: UIScreen.main.bounds.width * 0.99) // Optional: restrict card width
                }
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    DashboardChallengeView()
}

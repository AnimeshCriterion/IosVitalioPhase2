//
//  Toggle.swift
//  vitalio_native
//
//  Created by HID-18 on 09/08/25.
//

import SwiftUI

struct ChallengeToggleView: View {
    @EnvironmentObject var vm: ChallengesviewModel
    @State private var selectedIndex = 0
    
    var options: [String] {
        [
            "Joined Challenges (\(vm.joinedChallenges.count))",
            "New Challenges (\(vm.challenges.count))"
        ]
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<options.count, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                    if(index == 0){
                        vm.JoinedChallenge = true
                    }else{
                        vm.JoinedChallenge = false
                    }
                }) {
                    Text(options[index])
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(selectedIndex == index ? .black : Color.gray)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                if selectedIndex == index {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.blue, Color.cyan],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            lineWidth: 2
                                        )
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                            }
                        )
                }
            }
        }
        .padding(4)
        .background(Color(red: 239/255, green: 244/255, blue: 251/255)) // light background
        .cornerRadius(14)
        .padding(.horizontal)
    }
}

//
//  NewChallengeView.swift
//  vitalio_native
//
//  Created by HID-18 on 09/08/25.
//

import SwiftUI

struct NewChallenges: View {
    @EnvironmentObject var vm: ChallengesviewModel


    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(vm.challenges, id: \.id) { challenge in
             
                        NewChallengeCard(challenge: challenge)
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                    
                }
            }
            .padding(.horizontal, 16)
        }
    }
}



struct NewChallengeCard: View {
    let challenge: Challenge
    @EnvironmentObject var vm : ChallengesviewModel
    var userData = UserDefaultsManager.shared.getEmployee()
    @EnvironmentObject var route: Routing
    // Generate once per card
    let cardColor: Color = .random
    
    var body: some View {
        Button(action: {
            print("Data \(vm.challenges)")
            vm.title = challenge.title
            vm.description = challenge.description
            vm.color = cardColor
            vm.selectedChallenge = challenge
            
            route.navigate(to: .challengeDetailsView)
        }) {
            VStack(alignment: .leading, spacing: 10) {
                // Top HStack
                HStack(alignment: .top) {
                    HStack(spacing: 10) {
                        Image(systemName: "heart.text.square.fill")
                            .foregroundColor(.pink)
                            .font(.system(size: 22))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(challenge.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text(challenge.description)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image("gem")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(challenge.rewardPoints)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.5))
                    .clipShape(Capsule())
                }
                
                HStack(spacing: 6) {
                    // Avatars
                    VStack{
                        Text((challenge.peopleJoined!.isEmpty  || challenge.peopleJoined == nil) ? "" : "People Joined")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        HStack(spacing: -12) {
                            if let people = challenge.peopleJoined, !people.isEmpty {
                                ForEach(people.prefix(5)) { person in
                                    AsyncImage(url: URL(string: person.imageURL)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .frame(width: 24, height: 24)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                }
                                
                                if people.count > 5 {
                                    Text("\(people.count - 5)+")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .background(Color.waterBlue)
                                        .clipShape(Circle())
                                }
                            } else {
                                Text("No Participants")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Spacer()
                    VStack{
                        Text((challenge.startsIn == "Started" ) ? "\(challenge.startsIn)" : "Strats in \(challenge.startsIn)")
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        if !(challenge.peopleJoined?.contains(where: { $0.id == String(userData?.empId ?? "0") }) ?? false) {
                            joinNowButton(title: "Join Now", backgroundColor: cardColor) {
                                Task {
                                    await vm.join(challengeId: String(challenge.id))
                                }
                            }
                        } else {
                            joinNowButton(title: "Joined", backgroundColor: cardColor) {
                                
                            }
                        }}
                }
            }
            .padding()
            .background(cardColor.opacity(0.1)) // Same color for background
            .cornerRadius(16)}
    }
}

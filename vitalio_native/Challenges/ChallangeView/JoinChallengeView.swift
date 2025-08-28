//
//  JOinChallengeView.swift
//  vitalio_native
//
//  Created by HID-18 on 09/08/25.
//

import SwiftUI

struct JoinedChallenge: View {
    @StateObject var vm = ChallengesviewModel()

    var body: some View {
                LazyVStack(spacing: 20) {
                    ForEach(vm.joinedChallenges) { challenge in
                        JoinChallengeCard(challenge: challenge)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
          
            .task {
                await vm.getJoinedChallenges()
            }
        }
    
}



struct JoinChallengeCard: View {
    let challenge: ChallengeModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                // Left icon (replace with actual icon if needed)
                Image(systemName: "heart.text.square.fill")
                    .foregroundColor(.pink)
                    .font(.title3)

                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(.headline)

                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                // Reward Points
                ZStack {
                    HStack(spacing: 4) {
                        Image( "gem")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.red)
                        Text("\(challenge.rewardPoints)")
                            .bold()
                    }
                    .padding(6)
                    .background(Color.black)
                    .opacity(0.1)
                    .cornerRadius(12)
                    HStack(spacing: 4) {
                        Image( "gem")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.red)
                        Text("\(challenge.rewardPoints)")
                            .bold()
                    }
                    .padding(6)
                .cornerRadius(12)
                }
            }

            // Participant Row
            VStack(alignment: .leading, spacing: 6) {
                Text("Participants")
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack(spacing: -12) {
                    ForEach(Array(challenge.peopleJoined.prefix(4)), id: \.empId) { person in
                        AsyncImage(url: URL(string: person.imageURL)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }

                    if challenge.peopleJoined.count > 4 {
                        Text("+\(challenge.peopleJoined.count - 4)")
                            .font(.caption)
                            .frame(width: 32, height: 32)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
            }

            // Progress Bar (Dummy progress: 15/30 days)
            VStack(alignment: .leading, spacing: 4) {
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(height: 6)
                        .foregroundColor(Color.gray.opacity(0.2))

                    Capsule()
                        .frame(width: 150, height: 6)
                        .foregroundColor(.green)
                }

                HStack {
                    Text("15/30 days achieved")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Spacer()

                    Text("15 days left")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.random.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


extension Color {
    static var random: Color {
        let colors: [Color] = [.red, .blue, .green, .orange, .pink, .purple, .yellow, .teal]
        return colors.randomElement() ?? .blue
    }
}

//
//  leaderboard.swift
//  watchAooForTestingPurpose
//
//  Created by HID-18 on 23/07/25.
//

import SwiftUI

struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let gems: Int
    let imageName: String
    let badge: String
    let isHighlighted: Bool
}

struct LeaderboardView: View {
    @State private var showPodium = true
    @EnvironmentObject var route: Routing
    let topThree = [
        LeaderboardEntry(rank: 2, name: "Darrell Steward", gems: 200, imageName: "person1", badge: "bronze", isHighlighted: false),
        LeaderboardEntry(rank: 1, name: "Albert Flores", gems: 465, imageName: "person2", badge: "gold", isHighlighted: false),
        LeaderboardEntry(rank: 3, name: "Jacob Jones", gems: 360, imageName: "person3", badge: "silver", isHighlighted: false)
    ]
    
    let leaderboard = [
        LeaderboardEntry(rank: 4, name: "Abhay Sharma", gems: 230, imageName: "person4", badge: "green", isHighlighted: true),
        LeaderboardEntry(rank: 5, name: "Adnan", gems: 180, imageName: "person5", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 6, name: "Wajid Ali", gems: 150, imageName: "person6", badge: "red", isHighlighted: false),
        LeaderboardEntry(rank: 7, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 8, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 9, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),   LeaderboardEntry(rank: 4, name: "Abhay Sharma", gems: 230, imageName: "person4", badge: "green", isHighlighted: true),
        LeaderboardEntry(rank: 5, name: "Adnan", gems: 180, imageName: "person5", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 6, name: "Wajid Ali", gems: 150, imageName: "person6", badge: "red", isHighlighted: false),
        LeaderboardEntry(rank: 7, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 8, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 9, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),     LeaderboardEntry(rank: 4, name: "Abhay Sharma", gems: 230, imageName: "person4", badge: "green", isHighlighted: true),
        LeaderboardEntry(rank: 5, name: "Adnan", gems: 180, imageName: "person5", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 6, name: "Wajid Ali", gems: 150, imageName: "person6", badge: "red", isHighlighted: false),
        LeaderboardEntry(rank: 7, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 8, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 9, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),        LeaderboardEntry(rank: 4, name: "Abhay Sharma", gems: 230, imageName: "person4", badge: "green", isHighlighted: true),
        LeaderboardEntry(rank: 5, name: "Adnan", gems: 180, imageName: "person5", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 6, name: "Wajid Ali", gems: 150, imageName: "person6", badge: "red", isHighlighted: false),
        LeaderboardEntry(rank: 7, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 8, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),
        LeaderboardEntry(rank: 9, name: "Isha Tanvar", gems: 120, imageName: "person7", badge: "orange", isHighlighted: false),
    ]
    
    @EnvironmentObject var  vm : ChallengesviewModel
    @State private var scrollOffset: CGFloat = 0
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    route.back()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }
                Text("Leaderboard")
                    .font(.headline)
                    .padding()
                Spacer()
                Spacer()
            }
            .onAppear(){
                Task{
//                    await vm.getChallenges()
//                    await vm.getJoinedChallenges()
                }
            }
            
            HStack(alignment: .bottom, spacing: showPodium ? 0 : 10) {
                    ForEach(topThree.sorted { $0.rank < $1.rank }) { person in
                        VStack(spacing: 0) {
                            ZStack {
                                if  showPodium == false { VStack{
                                    Spacer().frame(height: showPodium ? 50 : 120 )
                                    Image("first")
                                        .resizable()
                                        .frame(width: 50 , height: 50)
                                    Spacer()
                                }
                                .frame(height:  50)
                                }
                             
                                Image(person.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                Image(systemName: "checkmark.seal.fill")
                                    .resizable()
                                    .foregroundColor(.green)
                                    .frame(width: 18, height: 18)
                                    .offset(x: 20, y: 20)
                             
                            }
                            Spacer().frame(height: showPodium ? 20 : 50 )
                            Text(person.name)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                            Spacer().frame(height: 20)
                            if showPodium {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(podiumColor(rank: person.rank))
                                        .frame(width: 100, height: CGFloat(50 + (4 - person.rank) * 30))
                                    VStack{
                                        Image("first")
                                        Spacer()
                                        Text("\(person.gems)")
                                            .foregroundColor(.white)
                                            .font(.footnote)
                                        
                                        Spacer()
                                    }.frame(height: CGFloat(50 + (4 - person.rank) * 30))
                           
                                } .transition(.opacity.combined(with: .scale))}else{
                                    HStack{
                                    
                                        Image("gem")
                                            .resizable()
                                            .frame(width: 20,height: 20)
                                        Text("350")
                                    }
                                }
                        }
                    }
                }
                .padding(.vertical, 10)
                .transition(.opacity.combined(with: .scale))
            
//            else{
//                HStack(alignment: .bottom, spacing: 0) {
//                    ForEach(topThree.sorted { $0.rank < $1.rank }) { person in
//                        VStack(spacing: 0) {
//                            ZStack {
//                                Image(person.imageName)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 60, height: 60)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                                Image(systemName: "checkmark.seal.fill")
//                                    .resizable()
//                                    .foregroundColor(.green)
//                                    .frame(width: 18, height: 18)
//                                    .offset(x: 20, y: 20)
//                            }
//                            Text(person.name)
//                                .font(.caption)
//                                .multilineTextAlignment(.center)
////                            ZStack {
////                                RoundedRectangle(cornerRadius: 10)
////                                    .fill(podiumColor(rank: person.rank))
////                                    .frame(width: 100, height: CGFloat(50 + (4 - person.rank) * 30))
////                                Text("\(person.gems)")
////                                    .foregroundColor(.white)
////                                    .font(.footnote)
////                            }
//                        }
//                    }
//                }
//                .padding(.vertical, 10)
//                .transition(.opacity.combined(with: .scale))
//
//            }

            
            ScrollView {
                VStack(spacing: 10) {
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0) // Invisible tracker

                    ForEach(leaderboard) { entry in
                        HStack {
                            Text("\(entry.rank)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 24)

                            Image(entry.imageName)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.name)
                                    .font(.subheadline)
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.yellow)
                            }
                            Spacer()

                            HStack(spacing: 4) {
                                Image( "gem")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("\(entry.gems)")
                                    .font(.subheadline)
                            }
                            .padding(.trailing)
                        }
                        .padding()
                        .background(entry.isHighlighted ? Color.white : Color(UIColor.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(entry.isHighlighted ? Color.green : Color.clear, lineWidth: 1.5)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .background(Color.white)
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = -value
                withAnimation(.easeInOut(duration: 0.3)) {
                    showPodium = scrollOffset <= 65
                }
                print("Scroll offset:", scrollOffset)
            }


        }
        .navigationBarHidden(true)
        .background(LinearGradient(colors: [Color.orange.opacity(0.8), .white], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
    }
    
    func podiumColor(rank: Int) -> Color {
        switch rank {
        case 1: return Color(red: 255/255, green: 100/255, blue: 75/255)
        case 2: return Color(red: 77/255, green: 169/255, blue: 166/255)
        case 3: return Color(red: 255/255, green: 187/255, blue: 68/255)
        default: return .gray
        }
    }
}


#Preview {
    LeaderboardView()
        .environmentObject(ChallengesviewModel())
}


struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}



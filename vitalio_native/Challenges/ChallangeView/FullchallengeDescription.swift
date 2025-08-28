//
//  FullchallengeDescription.swift
//  vitalio_native
//
//  Created by HID-18 on 09/08/25.
//

import SwiftUI

struct ChallengeDetailsView: View {
    @State private var showCongrats = false
    @EnvironmentObject var vm: ChallengesviewModel
    @EnvironmentObject var themeManager: ThemeManager
    var isDarkMode: Bool {
        themeManager.colorScheme == .dark
    }
 
    var userData = UserDefaultsManager.shared.getEmployee()
 @EnvironmentObject var route: Routing
 
    var body: some View {
        ScrollView {
            CustomNavBarView(title: "" , isDarkMode: isDarkMode) {
                route.back()
            }
            ZStack {
//                Color(vm.color.opacity(0.2))
//                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 24) {
                    Spacer().frame(height: 40)

                    // Header
                    Image(systemName: "waveform.path.ecg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .foregroundColor(Color(red: 0.87, green: 0.39, blue: 0.41))

                    Text(vm.title)
                        .font(.system(size: 20, weight: .bold))

                    Text(vm.description)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    ChallengeRewardView()

                    VStack(spacing: 16) {
                        Text("Starting in")
                            .font(.system(size: 14, weight: .semibold))

//                        Text("01ᵈ:03ʰ:17ᵐ")
//                            .font(.system(size: 20, weight: .semibold))
//                            .monospacedDigit()
                        CountdownView(timerString:  vm.startsIn)
                        Button(action: {
                            showCongrats = true
                        }) {
                  
                            VStack{
                                Text((vm.selectedChallenge!.startsIn == "Started" ) ? "\(vm.selectedChallenge!.startsIn)" : "Strats in \(vm.selectedChallenge!.startsIn)")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                if !(vm.selectedChallenge?.peopleJoined?.contains(where: { $0.id == String(userData?.empId ?? "0") }) ?? false) {
                                    Text("Join Now!")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(vm.color)
                                        .cornerRadius(10)
                                } else {
                                    HStack{
                                        //                                        Spacer()
                                        Text("Challenged joined")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(vm.color)
                                            .cornerRadius(10)
                                        //                                        Image("joined")
                                        //                                            .font(.system(size: 16, weight: .semibold))
                                        //                                            .foregroundColor(.white)
                                        //                                            .frame(maxWidth: .infinity)
                                        //                                            .padding(.vertical, 14)
                                        //                                            .background(vm.color)
                                        //                                            .cornerRadius(10)
                                        //                                        Spacer()
                                    }}
                            }
                        }
                        if !(vm.selectedChallenge?.peopleJoined?.contains(where: { $0.id == String(userData?.empId ?? "0") }) ?? false) {
                            
                        }else{
                            Button( action: {
                                Task{
                                 await   vm.leaveChallenge(challengeId: vm.selectedChallenge?.id)
                                    route.back()
                                }
                            }
                            ){
    Text("Leave challange")
        .font(.system(size: 16, weight: .bold))
        .foregroundColor(Color.red)
                            }
                           
                        }
                        Text("7 people to join you in this challenge")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        VStack{
//                            Text((vm.selectedChallenge?.peopleJoined!.isEmpty ?? false   || vm.selectedChallenge?.peopleJoined == nil) ? "" : "People Joined")
//                                .font(.system(size: 10))
//                                .foregroundColor(.gray)
                            HStack(spacing: -12) {
                                if let people = vm.selectedChallenge?.peopleJoined, !people.isEmpty {
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

//                        HStack(spacing: -12) {
//                            ForEach(0..<5) { i in
//                                Image("user\(i)")
//                                    .resizable()
//                                    .frame(width: 32, height: 32)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                            }
//
//                            Text("2+")
//                                .font(.system(size: 12, weight: .bold))
//                                .foregroundColor(.white)
//                                .frame(width: 32, height: 32)
//                                .background(Color.red)
//                                .clipShape(Circle())
//                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal)

                    Spacer()
                }  .navigationBarHidden(true) // Hides the default AppBar
                

                // Pop-up overlay
                if showCongrats {
                    CongratsPopupView(show: $showCongrats)
                        .transition(.scale)
                        .zIndex(1)
                }
            }
            .animation(.easeInOut, value: showCongrats)
        }.background(
            Color(vm.color.opacity(0.2))
            .edgesIgnoringSafeArea(.all))
    }
}


struct CongratsPopupView: View {
    @Binding var show: Bool

    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 8)
            HStack {
                Spacer()
                Button(action: {
                    show = false
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(10)
                }
            }

            VStack(spacing: 8) {
                Image(systemName: "diamond.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 32))

                Text("20")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)

                Text("Credited")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text("CONGRATS")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.black)

                Text("Target achieved!")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Button(action: {
                show = false
            }) {
                Text("Ok")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(12)
            }
        }
        .padding()
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
    }
}


#Preview{
    ChallengeDetailsView()
}



struct ChallengeRewardView: View {
    var body: some View {
        VStack(spacing: 32) {
            
            // Title Row
            HStack(spacing: 8) {
                Image("target_icon") // custom asset from design
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("3 liters/day for 30 days")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.14, green: 0.15, blue: 0.16)) // dark text
            }
            .padding()
            .padding(.horizontal, 20)
            .background(Color.black.opacity(0.05)) // transparent background
            .cornerRadius(10)
            
            // Completion Reward Title
            VStack{
                Text("Completion Reward")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.45, green: 0.47, blue: 0.55)) // grayish
                // Rewards Row
                HStack(spacing: 32) {
                    
                    RewardItem(percent: "100%", gems: 100)
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 1, height: 40)
                    
                    RewardItem(percent: "90%", gems: 80)
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 1, height: 40)
                    
                    RewardItem(percent: "80%", gems: 60)
                }
            }
            .padding()
            .background(Color.black.opacity(0.04)) // transparent background
            .cornerRadius(10)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
      
    }
}

struct RewardItem: View {
    let percent: String
    let gems: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text(percent)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.45, green: 0.47, blue: 0.55))
            
            HStack(spacing: 6) {
                Image("gem") // custom gem image from design
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("\(gems)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.14, green: 0.15, blue: 0.16))
            }
        }
    }
}

func parseTimerString(_ string: String) -> Int {
    let day = Int(string.components(separatedBy: "d").first ?? "0") ?? 0
    let hourPart = string.components(separatedBy: "d:").last?.components(separatedBy: "h").first ?? "0"
    let hour = Int(hourPart) ?? 0
    let minutePart = string.components(separatedBy: "h:").last?.components(separatedBy: "m").first ?? "0"
    let minute = Int(minutePart) ?? 0
    
    return (day * 86400) + (hour * 3600) + (minute * 60)
}



struct CountdownView: View {
    @State private var remainingSeconds: Int
    
    init(timerString: String) {
        _remainingSeconds = State(initialValue: parseTimerString(timerString))
    }
    
    var body: some View {
        Text(formattedTime())
            .font(.system(size: 20, weight: .semibold))
            .monospacedDigit()
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if remainingSeconds > 0 {
                        remainingSeconds -= 1
                    }
                }
            }
    }
    
    private func formattedTime() -> String {
        let days = remainingSeconds / 86400
        let hours = (remainingSeconds % 86400) / 3600
        let minutes = (remainingSeconds % 3600) / 60
        let seconds = remainingSeconds % 60
        
        return String(format: "%02dᵈ:%02dʰ:%02dᵐ:%02dˢ", days, hours, minutes, seconds)
    }
}


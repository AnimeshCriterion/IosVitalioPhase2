//
//  SharedAccountView.swift
//  vitalio_native
//
//  Created by HID-18 on 19/04/25.
//

import SwiftUI

struct SharedAccountView: View {
    @EnvironmentObject var route: Routing
    @EnvironmentObject var theme: ThemeManager
    
       var dark: Bool {
           theme.colorScheme == .dark
       }
    
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                CustomNavBarView(title: "Shared Account", isDarkMode: dark)
                Button(action: {
                    route.navigate(to: .addMemberView)
                }) {
                    Text("Add Member")
                        .foregroundColor(.blue)
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .stroke(Color.primaryBlue, lineWidth: 1)
                        ).padding(.horizontal, 20)}

            }
            UsersListView().background(dark ? Color.customBackgroundDark : Color.customBackground).padding(.horizontal, 20)
            Spacer()
        }.background(dark ? Color.customBackgroundDark : Color.customBackground)
    }
}



struct User: Identifiable {
    let id = UUID()
    let name: String
    let userId: String
    let imageName: String // Local image name or URL if using async
}

struct UserCardView: View {
    let user: User
    @EnvironmentObject var theme: ThemeManager
    
       var dark: Bool {
           theme.colorScheme == .dark
       }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(user.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(dark ?.white : .black)

                Text(user.userId)
                    .font(.system(size: 13))
                    .foregroundColor(dark ?.white : .gray)
            }
            
            Spacer()
            
            Button(action: {
                print("Open \(user.name)")
            }) {
                Image(systemName: "arrow.up.right.square")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(dark ?.white :  .black)
            }
        }
        .padding()
        .background( dark ? Color.customBackgroundDark2 :Color.white)
        .cornerRadius(8).navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SharedAccountView()

}

struct UsersListView: View {
    let users = [
        User(name: "Shamsa Juma", userId: "AD87958", imageName: "profile1"),
        User(name: "Ayush Dhyan", userId: "AD87958", imageName: "profile2"),
        User(name: "Surya Kala", userId: "AD87958", imageName: "profile3"),
        User(name: "Sumit Bose", userId: "AD87958", imageName: "profile4")
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(users) { user in
                UserCardView(user: user)
            }
        }
    }
}




struct AddMemberView: View {
    @State private var code: String = "EG1P56"
    @EnvironmentObject var theme: ThemeManager
    
       var dark: Bool {
           theme.colorScheme == .dark
       }

    var body: some View {
        VStack(spacing: 24) {
            // Navigation Bar
            HStack {
                CustomNavBarView(title: "Add member", isDarkMode: dark)
               
            }

            // Vitalio Logo
            Image("add_member") // Replace with actual logo asset name
                .resizable()
                .scaledToFit()
                .frame(height: 400)


            // Title
            Text("Stay Connected to Their\nHealth Metrics")
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color.blue)

            // Description and Input
            VStack(spacing: 12) {
                Text("Receive Access to Their Profile as an Observer.\nEnter the Connection Code Below to Connect.")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)

                TextField("", text: $code)
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 32)
            }

            // Submit Button
            Button(action: {
                print("Submitted code: \(code)")
            }) {
                Text("Submit")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding(.top)
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.bottom).navigationBarBackButtonHidden(true)
    }
}

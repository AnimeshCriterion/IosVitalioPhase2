//
//
//  Created by HID-18 on 19/03/25
//

import SwiftUI

struct CreateAccont: View {
    var body: some View {
        VStack(alignment: .trailing){
            HStack{
                CustomText("Create account",  color: .black,
                           size: 18,
                           weight: .medium)
                Spacer()
                Text("Skip") .foregroundColor(.blue)
            }.padding()
        }
        VStack(alignment: .leading){
            HStack {
                Text("23 %")
                    .foregroundColor(Color.primaryBlue)
                ProgressView(value: 0.7)
                    .tint(.blue)
                    .frame(height: 10)
            }
            CustomText("Getting Started")
            CustomText("Great start! You’re just beginning—let’s keep going!", color: Color.gray).padding(.top, 0.10)
        }.padding(16)
            .background(Color.customBackground)
            .cornerRadius(20)
            .padding(.horizontal, 16)
        
        
        Image("welcome")
            .resizable()
            .scaledToFit()
            .frame(height: 250)
        
        
        HStack {
            CustomText("Welcome to vitalio",color: Color.primaryBlue, size: 32, weight: .bold)
            
            Spacer()
        }
        CustomText("Let us now about you so we can manage to help you in better ways.",color: Color.textGrey, size: 16, weight: .regular).padding(.horizontal,40)
        Spacer()
    }
}

#Preview {
    CreateAccont()
}

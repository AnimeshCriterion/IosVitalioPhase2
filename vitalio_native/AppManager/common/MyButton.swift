//
//  MyButton.swift
//  vitalio_native
//
//  Created by HID-18 on 29/03/25.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var backgroundColor: Color = Color.primaryBlue
    var action: () -> Void
    

    var body: some View {
        VStack {
            Spacer()
            Button(action: action) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                    .background(backgroundColor)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
            }
        }
    }
}

#Preview {
    CustomButton(title: "Submit") {
                   print("Button Tapped")
               }
}

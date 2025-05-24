//
//  CustomTextField.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/17/25.
//
import SwiftUI

struct CustomTextField1: View {
    @Binding var text: String
    let title: String                // Label on top
    let placeholder: String          // Placeholder inside the text field
    let onChange: (String) -> Void   // Change callback

    // Optional Customization
    var titleFont: Font = .caption
    var titleColor: Color = .gray
    var textFieldFont: Font = .body
    var textColor: Color = .black
    var backgroundColor: Color = .white
    var cornerRadius: CGFloat = 20
    var placeholderFont: Font = .system(size: 14)
    var placeholderColor: Color = .gray
    var showBorder: Bool = false
       var borderColor: Color = .gray
       var borderWidth: CGFloat = 1
    
    @EnvironmentObject var themeManager: ThemeManager
       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(titleFont)
                .foregroundColor(titleColor)

            TextField(placeholder, text: $text)
                .font(placeholderFont)
                .foregroundColor(placeholderColor)
                .padding(.horizontal, 20)
                .frame(height: 50)
                .background(isDarkMode ? Color.customBackgroundDark2 :  backgroundColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: showBorder ? borderWidth : 0)
                )
                .multilineTextAlignment(.leading)
                .onChange(of: text, perform: onChange)
        }
    }
}





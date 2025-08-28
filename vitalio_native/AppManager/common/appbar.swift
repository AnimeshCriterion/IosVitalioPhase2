//
//  appbar.swift
//  vitalio_native
//
//  Created by HID-18 on 29/03/25.
//

import SwiftUI

struct CustomNavBarView: View {
    var title: String
    var isDarkMode: Bool
    var onBack: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button(action: {
              if let onBack = onBack {
                onBack()
            } else {
                dismiss()
            }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(  isDarkMode ? .white : .black)
                    .padding(.leading, 24)
            }
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor( isDarkMode ?  .white : .black)
                .padding(.leading, 12)
            Spacer()
        }
        .padding(.vertical, 12)
        .background(Color.clear)
    }
}


#Preview {
    CustomNavBarView(title: "Title" , isDarkMode: false){}
}

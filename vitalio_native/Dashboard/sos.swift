//
//  sos.swift
//  vitalio_native
//
//  Created by HID-18 on 06/05/25.
//

import SwiftUI

struct SosBottomSheet: View {
    @Binding var showSheet: Bool
    @State private var storeNumber: Bool = false
 
    let phoneNumber = "8577850281"
    @EnvironmentObject var dark : ThemeManager
//    @State private var isSheetPresented = false
    
    var isDark: Bool {
        dark.colorScheme == .dark
    }
 
 
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "phone.fill")
                .foregroundColor(.green)
                .font(.largeTitle)
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(storeNumber ? .blue : .gray)
                Text("Helpline No. \(phoneNumber)")
            }
            .font(.body)
            .foregroundColor(isDark ? .white : .black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isDark ? Color.customBackgroundDark2 : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
            .padding(.horizontal)
            .onTapGesture {
                storeNumber = true
                print("FaheemCheck")
            }
 
            Button(action: {
                guard storeNumber else { return }
                if let url = URL(string: "tel://\(phoneNumber)") {
                    UIApplication.shared.open(url)
                }
                showSheet = false
            }) {
                Text("Call now")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(storeNumber ? Color.blue :( isDark ? Color.customBackgroundDark2 : Color.gray))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .disabled(!storeNumber)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(isDark ? Color.customBackgroundDark : Color.white)
        .cornerRadius(20)
    }
}

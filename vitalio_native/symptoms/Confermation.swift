//
//  Confermation.swift
//  vitalio_native
//
//  Created by HID-18 on 29/03/25.
//

import SwiftUI

struct Confirmation: View {
    var body: some View {
        VStack {
            CustomNavBarView(title: "Symptom Tracker" , isDarkMode: true){}
            Spacer()
            Image("confirm")
            Spacer()
        }
    }
}

#Preview {
    Confirmation()
}

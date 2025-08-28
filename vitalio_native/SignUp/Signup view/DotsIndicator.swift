//
//  DotsIndicator.swift
//  vitalio_native
//
//  Created by HID-18 on 25/08/25.
//

import SwiftUI

struct DotsIndicator: View {
    var total: Int
    var current: Int
    
    var body: some View {
        HStack(spacing: 8) { // spacing between dots
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index <= current ? Color.blue : Color.white) // fill color
                    .overlay(
                        Circle()
                            .stroke(Color.blue, lineWidth: 1.5) // border for all dots
                    )
                    .frame(width: 10, height: 10) // exact dot size
            }
        }
    }
}



//
//  AnimateWave.swift
//  vitalio_native
//
//  Created by HID-18 on 02/05/25.
//

import SwiftUI

struct AnimatedWave: Shape {
    var phase: CGFloat
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let amplitude: CGFloat = 6
        let frequency: CGFloat = .pi / rect.width
        
        path.move(to: .zero)
        for x in stride(from: 0, through: rect.width, by: 1) {
            let y = amplitude * sin(frequency * x + phase)
            path.addLine(to: CGPoint(x: x, y: y + rect.midY))
        }
        
        return path
    }
    
}





import SwiftUI

struct CustomText: View {
    let text: String
    let color: Color
    let size: CGFloat
    let weight: Font.Weight
    
    init(
        _ text: String,
        color: Color = .black, // Default color
        size: CGFloat = 16, // Default size
        weight: Font.Weight = .regular // Default weight
    ) {
        self.text = text
        self.color = color
        self.size = size
        self.weight = weight
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: size, weight: weight))
            .foregroundColor(color)
    }
}

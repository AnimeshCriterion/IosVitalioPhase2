import SwiftUI


func joinNowButton(
    title: String,
    backgroundColor: Color = Color.red.opacity(0.7),
    textColor: Color = .white,
    cornerRadius: CGFloat = 10,
    action: @escaping () -> Void
) -> some View {
    Button(action: action) {
        Text(title)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(textColor)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor).opacity(0.7)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
    .buttonStyle(PlainButtonStyle())
}


#Preview {
    joinNowButton(title: "Subscribe", backgroundColor: .blue) {
                 print("Subscribe tapped")
             }
}

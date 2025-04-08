
import SwiftUI

struct CustomAlertView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.circle")
                .font(.largeTitle)
                .foregroundColor(.yellow)
            
            Text("An Error Occurred!")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.black)
        .cornerRadius(16)
        .frame(maxWidth: 300)
    }}


#Preview {
    CustomAlertView(message: "String")
}

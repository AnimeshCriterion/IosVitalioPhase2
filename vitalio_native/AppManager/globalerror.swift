import Foundation
import SwiftUI

@MainActor
class PopupManager: ObservableObject {
    @Published var isPresented: Bool = false
    @Published var popupContent: AnyView = AnyView(EmptyView())

    static let shared = PopupManager()

    func show(message: String) {
        let content = ZStack(alignment: .topTrailing) {
            VStack(spacing: 16) {
                // Animated error icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                    .scaleEffect(1.1)
                    .shadow(radius: 4)
                    .padding(.top, 12)
                    .transition(.scale)

                Text(message)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .font(.system(size: 16, weight: .medium))

                Button(action: {
                    self.hide()
                }) {
                    Text("Dismiss")
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
            .frame(maxWidth: 300)

            // Small close icon
            Button(action: {
                self.hide()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
        .padding()
        .onTapGesture {} // Prevent tap-through

        popupContent = AnyView(content)
        isPresented = true
    }

    func hide() {
        isPresented = false
        popupContent = AnyView(EmptyView())
    }
}



 func showGlobalError(message: String){
     Task {
         @MainActor in  PopupManager.shared.show(message: message)
     }
}

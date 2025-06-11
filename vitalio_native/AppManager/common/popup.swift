//
//  popup.swift
//  vitalio_native
//
//  Created by HID-18 on 09/04/25.
//

import SwiftUI

struct popup: View {
    @State private var showSuccess = false
    var text: String

       var body: some View {
           ZStack {
                      // Main UI
               
                      VStack {
                          Button("Save/Submit") {
                              withAnimation {
                                  showSuccess = true
                                  
                              }
                          }
                      }

                      // Success popup with animation
               SuccessPopupView(show: $showSuccess, message: text)
                          .zIndex(1)
                  }
              
       }
}

#Preview {
    popup( text: "Medicine intake Sucessful!")
}






struct SuccessPopupView: View {
    @Binding var show: Bool
    var message: String
    @State private var animateLogo = false

    var body: some View {
        if show {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(Color.green.opacity(0.5), lineWidth: 10)
                        .frame(width: 80, height: 80)
                        .scaleEffect(animateLogo ? 1.1 : 0.8)
                        .opacity(animateLogo ? 1 : 0.5)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animateLogo)

                    Image(systemName: "checkmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.green)
                        .scaleEffect(animateLogo ? 1.0 : 0.5)
                        .rotationEffect(.degrees(animateLogo ? 0 : -180))
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animateLogo)
                }

                LocalizedText(key:message)
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
            .transition(.scale.combined(with: .opacity))
            .onAppear {
                
                animateLogo = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                       
                    }
                    show = false
                    animateLogo = false
                }
            }
        }
    }
}
struct SuccessPopupViewError: View {
    @Binding var show: Bool
    var message: String
    @State private var animateLogo = false

    var body: some View {
        if show {
            VStack(spacing: 20){
                ZStack {
                    Circle()
                        .stroke(Color.red.opacity(0.5), lineWidth: 10)
                        .frame(width: 80, height: 80)
                        .scaleEffect(animateLogo ? 1.1 : 0.8)
                        .opacity(animateLogo ? 1 : 0.5)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animateLogo)

                    Image(systemName: "xmark")

                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.red)
                        .scaleEffect(animateLogo ? 1.0 : 0.5)
                        .rotationEffect(.degrees(animateLogo ? 0 : -180))
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animateLogo)
                }

                LocalizedText(key:message)
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
            .transition(.scale.combined(with: .opacity))
            .onAppear {
                
                animateLogo = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                       
                    }
                    show = false
                    animateLogo = false
                }
            }
        }
    }
}

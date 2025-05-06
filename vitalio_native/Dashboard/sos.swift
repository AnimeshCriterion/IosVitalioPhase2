//
//  sos.swift
//  vitalio_native
//
//  Created by HID-18 on 06/05/25.
//

import SwiftUI

struct SosBottomSheet: View {
    @Binding var showSheet: Bool
 
    var body: some View {
        VStack(spacing: 20) {
            Text("Emergency SOS")
                .font(.title2)
                .fontWeight(.bold)
 
            
            Link(destination: URL(string: "tel://8577850281")!) {
                HStack{
                    
                    Image(systemName: "checkmark.circle.fill").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Text("Helpline No. 8577850281")
                }
                .font(.body)
                .foregroundColor(.black)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}
 
//#Preview {
//    SosBottomSheet(showSheet: <#Binding<Bool>#>)
//}

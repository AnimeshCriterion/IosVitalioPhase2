//
//  Symptoms history.swift
//  vitalio_native
//
//  Created by HID-18 on 06/05/25.
//

import SwiftUI

struct SymptomsHistory: View {
    @EnvironmentObject var viewmodel : SymptomsViewModal
    
    
    var body: some View {
        VStack{
        
            ScrollView {
                   LazyVStack(alignment: .leading) {
                       ForEach(viewmodel.groupedSymptoms.keys.sorted(), id: \.self) { date in
                           Text(viewmodel.customdate(from: date))
                               .font(.subheadline)
                               .foregroundColor(.textGrey)
                               .padding(.leading, 16)
                               .padding(.top, 12)

                           ForEach(viewmodel.groupedSymptoms[date] ?? [], id: \.id) { symptom in
                               HStack(alignment: .top, spacing: 8) {

                                   VStack {
                                       Circle()
                                           .fill(Color.gray)
                                           .frame(width: 10, height: 10)
                                       Rectangle()
                                           .fill(Color.gray.opacity(0.5))
                                           .frame(width: 2, height: 60)
                                   }
                                   .padding(.leading, 16)
                                   VStack(alignment: .leading, spacing: 4) {
                                       Text(symptom.details)
                                           .font(.headline)
                                           .foregroundColor(.black)

                                       if let dateStr = symptom.detailsDate {
                                           Text(dateStr)
                                               .font(.caption)
                                               .foregroundColor(.secondary)
                                   }
                                   }
                                   .padding()
                                   .frame(maxWidth: .infinity, alignment: .leading) // Full width with left alignment
                                   .background(Color.white)
                                   .cornerRadius(12)

                                   
                               }
                               .padding( 8)
                           }
                       }
                   }
                   .padding(.bottom, 16)
               }
               .background(Color(.systemGroupedBackground))
        }
            .onAppear{
                Task{
                    await viewmodel.SymptomsHistory()
                }
            }
    }
}

#Preview {
    SymptomsHistory().environmentObject(SymptomsViewModal())
}


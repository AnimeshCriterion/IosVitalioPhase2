//
//  Calander.swift
//  vitalio_native
//
//  Created by HID-18 on 04/04/25.
//

import SwiftUI

struct DateLabelView: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "calendar")
                .foregroundColor(.gray)
            
            Text(dateFormatter.string(from: selectedDate))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .onTapGesture {
            showDatePicker.toggle()
        }
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                Button("Done") {
                    showDatePicker = false
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .presentationDetents([.medium]) // Makes the sheet smaller
        }
    }
}

struct DateLabelView_Previews: PreviewProvider {
    static var previews: some View {
        DateLabelView()
            .previewLayout(.sizeThatFits)
    }
}


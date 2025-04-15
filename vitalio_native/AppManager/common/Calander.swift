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
    var onDateSelected: (String) -> Void

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Required format
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
                    let formatted = dateFormatter.string(from: selectedDate)
                    onDateSelected(formatted)
                    showDatePicker = false
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .presentationDetents([.medium])
        }
    }
}


struct DateLabelView_Previews: PreviewProvider {
    static var previews: some View {
        DateLabelView { formattedDate in
            print("Selected date in yyyy-MM-dd format: \(formattedDate)")
            // You can assign this to a @State variable in the parent view if needed
        }
            .previewLayout(.sizeThatFits)
    }
}


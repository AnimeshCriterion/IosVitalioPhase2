//
//  CustomDropDown.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 3/25/25.
//

import SwiftUI



struct DropdownMenu<T: Identifiable & CustomStringConvertible>: View {
    var title: String? = nil
    var titleColor: Color = .black
    let options: [T]
    @Binding var selectedOption: T?
    var onSelect: ((T) -> Void)? = nil // Add callback
    
    
    @EnvironmentObject var themeManager: ThemeManager
    var isDarkMode : Bool {
        themeManager.colorScheme == .dark
    }

    var body: some View {
        VStack(alignment: .leading) {
            if let title = title {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(titleColor)
            }

            Spacer().frame(height: 10)

            Menu {
                ForEach(options) { option in
                    Button(action: {
                        selectedOption = option
                        onSelect?(option) // Call the callback
                    }) {
                        Text(option.description)
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption?.description ?? (title != nil ? "Select \(title!)" : "Select Option"))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundColor(isDarkMode ? Color.white : .gray)
                }
                .padding()
                .frame(height: 50)
                .background(isDarkMode ? Color.customBackgroundDark2 : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            }
        }
    }
}



//struct DropdownMenu: View {
//    let title: String
//    let options: [String]
//    @Binding var selectedOption: String
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .font(.system(size: 14))
//                .foregroundColor(.black)
//
//            Spacer().frame(height: 10)
//
//            Menu {
//                ForEach(options, id: \.self) { option in
//                    Button(action: {
//                        selectedOption = option
//                    }) {
//                        Text(option)
//                    }
//                }
//            } label: {
//                HStack {
//                    Text(selectedOption.isEmpty ? "Select \(title)" : selectedOption) // Show selected text
//                        .font(.system(size: 14))
//                        .foregroundColor(.black)
//
//                    Spacer()
//
//                    Image(systemName: "chevron.down") // Dropdown icon
//                        .foregroundColor(.gray)
//                }
//                .padding()
//                .frame(height: 50)
//                .background(Color.white)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//                )
//            }
//        }
//    }
//}


//#Preview {
//    DropdownMenu()
//}

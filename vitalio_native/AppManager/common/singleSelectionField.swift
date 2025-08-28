//
//  singleSelectionField.swift
//  vitalio_native
//
//  Created by Test on 14/08/25.
//
import SwiftUI

struct CustomPickers<T: Identifiable & CustomStringConvertible>: View {
    @Binding var selection: T?
    var options: [T]
    var onSelect: ((T) -> Void)?
    
    @State private var searchText = ""
    @State private var isExpanded = false
    @FocusState private var isSearchFieldFocused: Bool
    
    private var filteredOptions: [T] {
        searchText.isEmpty ? options : options.filter { $0.description.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main button
            Button(action: toggleDropdown) {
                HStack {
                    Text(selection?.description ?? "Select")
                        .foregroundColor(selection == nil ? .gray : .primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundColor(Color(.systemGray2))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            
            // Dropdown content (part of the layout flow)
            if isExpanded {
                VStack(spacing: 0) {
                    // Search field
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(.plain)
                            .tint(.blue)
                            .autocorrectionDisabled()
                            .focused($isSearchFieldFocused)
                            .onAppear { isSearchFieldFocused = true }
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    // Options list
                    ScrollView {
                        VStack(spacing: 0) {
                            if filteredOptions.isEmpty {
                                Text("No results found")
                                    .foregroundColor(.secondary)
                                    .padding()
                            } else {
                                ForEach(filteredOptions) { option in
                                    Button {
                                        withAnimation {
                                            selection = option
                                            onSelect?(option)
                                            isExpanded = false
                                        }
                                    } label: {
                                        HStack {
                                            Text(option.description)
                                                .foregroundColor(selection?.id == option.id ? .blue : .primary)
                                            Spacer()
                                            if selection?.id == option.id {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .contentShape(Rectangle())
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    if option.id != filteredOptions.last?.id {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: min(CGFloat(filteredOptions.count) * 44, 300))
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
        .animation(.default, value: searchText)
    }
    
    private func toggleDropdown() {
        withAnimation {
            isExpanded.toggle()
            isSearchFieldFocused = isExpanded
        }
    }
}

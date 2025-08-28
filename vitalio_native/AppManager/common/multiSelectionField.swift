//
//  multiSelectionField.swift
//  vitalio_native
//
//  Created by Test on 12/08/25.
//
import SwiftUI

struct MultiSelectPicker<Item: Identifiable & Hashable>: View {
    @Binding var selections: [Item]
    var options: [Item]
    var labelKeyPath: KeyPath<Item, String>
    var onSearch: ((String) -> Void)?
    
    @State private var searchText = ""
    @State private var isPresentingSheet = false
    
    // Colors for consistent theming
    private let accentColor = Color.blue
    private let lightGray = Color(.systemGray5)
    private let mediumGray = Color(.systemGray3)
    private let darkGray = Color(.systemGray)
    
    var filteredOptions: [Item] {
        if searchText.isEmpty {
            return options
        } else {
            return options.filter { $0[keyPath: labelKeyPath].localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        Button(action: { isPresentingSheet = true }) {
            HStack {
                Text(selections.isEmpty ? "Select..." :
                     selections.map { $0[keyPath: labelKeyPath] }.joined(separator: ", "))
                    .foregroundColor(selections.isEmpty ? darkGray : .primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(mediumGray)
                    .font(.caption.weight(.bold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(mediumGray, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isPresentingSheet) {
            NavigationView {
                VStack(spacing: 0) {
                    // Improved Search Bar
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(darkGray)
                                .imageScale(.small)
                            
                            TextField("Search...", text: $searchText)
                                .textFieldStyle(.plain)
                                .tint(accentColor)
                                .onChange(of: searchText) { _, newValue in
                                    onSearch?(newValue)
                                }
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    onSearch?("")
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(darkGray)
                                }
                                .transition(.opacity)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(lightGray)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                    .compositingGroup()
                    .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
                    
                    Divider()
                        .padding(.top, 4)
                    
                    // Enhanced List with better styling
                    List {
                        if !selections.isEmpty {
                            Section {
                                ForEach(selections) { option in
                                    selectionRow(for: option, isSelected: true)
                                }
                                .onDelete { indices in
                                    selections.remove(atOffsets: indices)
                                }
                            } header: {
                                Text("Selected")
                                    .font(.subheadline)
                                    .foregroundColor(accentColor)
                                    .textCase(.none)
                            }
                        }
                        
                        Section {
                            ForEach(filteredOptions) { option in
                                selectionRow(for: option, isSelected: selections.contains(option))
                            }
                        } header: {
                            Text("All Items")
                                .font(.subheadline)
                                .foregroundColor(darkGray)
                                .textCase(.none)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .environment(\.defaultMinListRowHeight, 44)
                }
                .navigationTitle("Select Items")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            isPresentingSheet = false
                        }
                        .fontWeight(.medium)
                    }
                }
            }
            .accentColor(accentColor)
        }
    }
    
    @ViewBuilder
    private func selectionRow(for option: Item, isSelected: Bool) -> some View {
        Button(action: { toggleSelection(option) }) {
            HStack {
                Text(option[keyPath: labelKeyPath])
                    .foregroundColor(.primary)
                    .font(.callout)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(accentColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .contentShape(Rectangle())
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .listRowBackground(Color(.systemBackground))
    }
    
    private func toggleSelection(_ option: Item) {
        withAnimation(.easeInOut(duration: 0.15)) {
            if selections.contains(option) {
                selections.removeAll { $0 == option }
            } else {
                selections.append(option)
            }
        }
    }
}

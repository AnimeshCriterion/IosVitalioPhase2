//
//  personalInfoView.swift
//  vitalio_native
//
//  Created by Baqar on 08/08/25.
//

import SwiftUI



struct PersonalInfoView: View {
    @StateObject var viewModel = PersonalPersonInfoViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
       
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Chronic Disease
                        VStack(alignment: .leading) {
                            FormFieldLabel("Chronic Disease to Manage")
                            MultiSelectPicker(
                                selections: $viewModel.selectedChronicDiseases,
                                options: viewModel.chronicDiseases,
                                labelKeyPath: \.problemName
                            ) { query in
                                viewModel.searchDebounced(query: query)
                            }
                        }


                    // Address Section
                        VStack(alignment: .leading, spacing: 16) {
                            FormFieldLabel("Street Address")
                            CustomTextFields(text: $viewModel.streetAddress)
                            
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading) {
                                    FormFieldLabel("Zip Code")
                                    CustomTextFields(text: $viewModel.zipCode, keyboardType: .numberPad)
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack(alignment: .leading) {
                                    FormFieldLabel("City")
                                    CustomPickers(selection: $viewModel.selectedCity, options: viewModel.citys) { selected in
                                        print("Selected city:", selected.id)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading) {
                                    FormFieldLabel("State")
                                    CustomPickers(selection: $viewModel.selectedState, options: viewModel.states) { selected in
                                        Task { await viewModel.CityData(selected.id) }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack(alignment: .leading) {
                                    FormFieldLabel("Country")
                                    CustomPickers(selection: $viewModel.selectedCountry, options: viewModel.countries) { selected in
                                        Task { await viewModel.StateData(selected.id) }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    
                    // Health Info
                        VStack(alignment: .leading, spacing: 16) {
                            FormFieldLabel("Weight (kg)")
                            CustomTextFields(text: $viewModel.weight, keyboardType: .numberPad)
                            
                            FormFieldLabel("Height (cm)")
                            CustomTextFields(text: $viewModel.height, keyboardType: .numberPad)
                            
                            FormFieldLabel("Blood Group")
                            CustomPickers(selection: $viewModel.selectedBloodGroup, options: viewModel.bloodGroups)
                        }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: {
                            // Action for going back
                            // If inside NavigationStack:
                             dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black) // arrow in black
                                .font(.system(size: 18, weight: .medium))
                        }
                        Text("Personal Info")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update & Save") {
                        // Save action
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                }
            }
            .navigationBarBackButtonHidden(true) // hides default back button

            .background(Color(.systemGray6))
        
    }
}

// MARK: - Custom Components
struct FormFieldLabel: View {
    var title: String
    init(_ title: String) { self.title = title }
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.gray)
    }
}

struct CustomTextFields: View {
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var placeholder: String = ""
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)  // Reduced vertical padding
            .frame(height: 48)  // Fixed compact height
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
    }
}



#Preview {
    PersonalInfoView()
}

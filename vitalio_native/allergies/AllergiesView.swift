//
//  AllergiesView.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/17/25.
//

import SwiftUI

struct AllergiesView: View {
    @EnvironmentObject var allergiesVM: AllergiesViewModal
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager
//    @State private var showPopup = false
    var isDarkMode : Bool {
        themeManager.colorScheme == .dark
    }
    var body: some View {

        ZStack {
            VStack(alignment: .leading,spacing: 16) {
                // Header
                HStack {
                    Button(action: {
                        route.back()
                    }) {
                        Image(systemName: "chevron.left").foregroundColor(isDarkMode ? Color.white :.black)}
                    Spacer().frame(width: 20)
                    Text("Allergies")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        allergiesVM.showPopup = true
                        Task{
                            await allergiesVM.substanceType()
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Allergies")
                                .font(.footnote)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isDarkMode ? Color.customBackgroundDark2 :Color.white)
                        .cornerRadius(30)
                        
                        .sheet(isPresented: Binding(get: {
                            allergiesVM.showPopup
                        }, set: { newVal in
                            allergiesVM.showPopup = newVal
                        })) {
                            AddAllergiesPopupView(showPopup: Binding(get: {
                                allergiesVM.showPopup
                            }, set: { newVal in
                                allergiesVM.showPopup = newVal
                            }))
                            .presentationDetents([.height(500)])
                            .environmentObject(allergiesVM)
                        }
                    }
                }
                //            .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(allergiesVM.allergiesList) { allergyRecord in
                            Text(allergyRecord.parameterName)
                                .font(.subheadline)
                                .foregroundStyle(isDarkMode ? Color.white : .secondary)
                            
                            ForEach(allergyRecord.decodedHistory ?? []) { detail in
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(detail.substance)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        
                                        Text(detail.remark)
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(detail.severityLevel)
                                        .font(.subheadline)
                                        .foregroundStyle(isDarkMode ? Color.orange : Color.primaryBlue)
                                }
                                .padding()
                                .background(isDarkMode ? Color.customBackgroundDark2 : Color.white)
                                .cornerRadius(14)
                                
                            }
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
            .background(isDarkMode ? Color.customBackgroundDark : Color.customBackground2)
            
            .onAppear(){
                Task{
                    await allergiesVM.allergiesData()
                }
            }
            if allergiesVM.isLoading {
                    LoaderView(text: "Fetching Allergies...")
                }
            SuccessPopupView(show: $allergiesVM.showAlert, message: "Allergies Added Successfully")
                .zIndex(1)
        }.ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    AllergiesView()
}



struct AddAllergiesPopupView: View {
    @EnvironmentObject var allergiesVM: AllergiesViewModal
    @Binding var showPopup: Bool
    
    
    @EnvironmentObject var themeManager: ThemeManager
    var isDarkMode : Bool {
        themeManager.colorScheme == .dark
    }

    let names = ["Mild", "Moderate", "Severe"]
    let substanceList = ["Drug Allergies","Food Allergies","Skin allergies", "Dust allergies", "Insect allergies"]
    @State private var selectedSubstance: String = ""
    var body: some View {
        VStack {
            Text("Add Allergy")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(isDarkMode ? Color.white : Color.black)
                .padding(.bottom,22)

        
            DropdownMenu(
                title: "Substance Type",
                titleColor: .secondary,
                options: allergiesVM.substanceTypeList,
                selectedOption: $allergiesVM.selectedSubstanceType,
                onSelect: { substance in
                    allergiesVM.selectedSubstanceTypeID = substance.historyParameterAssignId
                    print("Selected Substance ID: \(substance.historyParameterAssignId)")
                }
            )
            .padding(.bottom,10)
            
            
            

            CustomTextField1(
                       text: $allergiesVM.substance,
                       title: "Substance",
                       placeholder: "Select",
                       onChange: { newValue in
                           print("Changed to: \(newValue)")
                       },
                       titleFont: .footnote,
                       titleColor: isDarkMode ? Color.white : .gray,
                       textFieldFont: .headline,
                       textColor: .red,
                       backgroundColor: isDarkMode ? Color.customBackgroundDark2 : Color.white,
                       cornerRadius: 8
                   )
                    .padding(.bottom,22)
            
            CustomTextField1(
                       text: $allergiesVM.reaction,
                       title: "Reaction/ Allergy",
                       placeholder: "Enter",
                       onChange: { newValue in
                           print("Changed to: \(newValue)")
                       },
                       titleFont: .footnote,
                       titleColor: isDarkMode ? Color.white : .gray,
                       textFieldFont: .headline,
                       textColor: .red,
                       backgroundColor: isDarkMode ? Color.customBackgroundDark2 : Color.white,
                       cornerRadius: 8
                   )
                    .padding(.bottom,22)
            

            Text("How severe was the reaction?")
                .font(.caption)
                .foregroundColor(isDarkMode ? Color.white :  .gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                ForEach(names, id: \.self) { name in
                    Text(name)
                        .font(.footnote)
                        .frame(width: 88, height: 42)
                        .background(allergiesVM.selectedName == name ? Color.blue.opacity(0.1) : isDarkMode ? Color.customBackgroundDark2 : Color.white)
                        .foregroundStyle(allergiesVM.selectedName == name ? Color.primaryBlue : Color.gray)
                        .cornerRadius(10)
                        
                        .onTapGesture {
                            allergiesVM.selectedName = name
                            print("selected option \( allergiesVM.selectedName)")
                                         }
                        .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(allergiesVM.selectedName == name ? Color.primaryBlue : isDarkMode ? Color.customBackgroundDark2 : Color.white, lineWidth: 1)
                                    )
                        
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            
            

            Button("Add Allergy") {
                
                if allergiesVM.validateFields() {
                      Task {
                          await allergiesVM.addAlergiesData()
                      }
                    
                    
                    
                      showPopup = false
                  } else {
                      allergiesVM.showValidationAlert = true
                  }
                
                
            }
            .font(.subheadline)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top,22)
            .alert(isPresented: $allergiesVM.showValidationAlert) {
                Alert(
                    title: Text("Validation Error"),
                    message: Text(allergiesVM.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isDarkMode ? Color.customBackgroundDark : Color.customBackground2)
    }
}

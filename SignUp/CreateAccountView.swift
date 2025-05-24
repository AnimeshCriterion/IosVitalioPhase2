//
//  CreateAccountView.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 3/20/25.
//

import SwiftUI

struct CreateAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var route: Routing
    @EnvironmentObject var viewModal: SignUpViewModal

    var body: some View {
        ScrollView {
            VStack {
               
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("0%")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.primaryBlue)

                        Rectangle()
                            .fill(Color.primaryBlue)
                            .frame(maxWidth: .infinity, maxHeight: 5)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Getting Started")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                        Text("Great start! You’re just beginning—let’s keep going")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(Color.customBackground2)
                .cornerRadius(10)

                TabView(selection: $viewModal.currentPage) {
                    firstPage().tag(0)
                    secondPages().tag(1)
                    dobPage().tag(2)
                    bloodGroupPage().tag(3)
                    locationPage().tag(4)
                    weightPage().tag(5)
                    heightSelectionPage().tag(6)
                    chronicDiseasePage().tag(7)
                    chronicConditionPage().tag(8)
                    healthHistoryPage().tag(9)
                    vitalReminderPage().tag(10)
                    fluidIntakeDetailsPage().tag(11)
                }
                .frame(height: 600)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .simultaneousGesture(
                    DragGesture().onChanged { value in
                        if abs(value.translation.width) > abs(value.translation.height) {
                        }
                    }
                )

                Button(action: {
                    withAnimation {
                        viewModal.currentPage += 1
                        print("hello \(viewModal.firstName)")
                    }
                }) {
                    Text("Next")
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding()
                        .foregroundColor(.white)
                        .background(viewModal.firstName.isEmpty || viewModal.lastNmae.isEmpty ? Color.gray : Color.primaryBlue)
                        .cornerRadius(14)
                }
            }
            
        }.padding(.horizontal, 20)
    }

    func firstPage() -> some View {
        VStack {
            Image("welcome")
                .padding()
                .frame(height: 250)

            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome to Vitalio.")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.primaryBlue)
                    .fontWeight(.bold)

                Text("Let us now about you so we can manage to help you in better ways.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 30)

                VStack(alignment: .leading) {
                    Text("First Name")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    Spacer().frame(height: 10)

                    TextField("Type your first name", text: $viewModal.firstName)
                        .padding(.leading)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }.padding(.bottom, 20)

                VStack(alignment: .leading) {
                    Text("Last Name")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    Spacer().frame(height: 10)

                    TextField("Type your last name", text: $viewModal.lastNmae)
                        .padding(.leading)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 20)
            Spacer().frame(height: 30)
            
        }
    }
    
    
    
    /// Create Gender Page

    func secondPages() -> some View {
        VStack {
            Image("Gender")
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("Gender")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.primaryBlue)
                    .fontWeight(.bold)

                Text("Hi \(viewModal.firstName), let us know if you are male or female.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 30)

                HStack(spacing: 16) {
                    ForEach(viewModal.genders) { data in
                        VStack {
                            Image(data.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)

                            Text(data.name)
                                .font(.system(size: 14))
                                .foregroundColor(viewModal.selectedGender == data.value ? .white : .black)
                        }
                        .frame(width: 100, height: 100)
                        .background(viewModal.selectedGender == data.value ? Color.primaryBlue : Color.customBackground2)
                        .cornerRadius(10)
                        .overlay(
                            viewModal.selectedGender == data.value ?
                            Circle()
                                .fill(Color.green)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(Color.white)
                                )
                                .offset(x: 45, y: -45)
                            : nil
                        )
                        .onTapGesture {
                            viewModal.selectedGender = data.value
                        }
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 60)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    /// DOB view page
    
    func dobPage() -> some View {
        VStack {

            Image("Calendar")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("Your date of birth?")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.primaryBlue)
                    .fontWeight(.bold)

                Text("Your date of birth ensures personalized health insights.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 25)

                DatePicker(
                    "",
                    selection: $viewModal.selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipped()
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 30)
        }
        .padding(.horizontal, 20)
    }

    
    /// Blood View Page
    
    
    func bloodGroupPage() -> some View {
        VStack {
            Spacer().frame(height: 40)

            VStack {
                Image("Blood")
                    .padding()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome to Vitalio.")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.primaryBlue)
                        .fontWeight(.bold)

                    Text("Your blood group helps ensure accurate and personalized care.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 30)

                    LazyVGrid(columns: viewModal.bloodGridColumns, spacing: 16) {
                        ForEach(viewModal.bloodGroups) { item in
                            let isSelected = viewModal.selectedBloodGroup == item.name

                            VStack {
                                Text(item.name)
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundStyle(isSelected ? .white : .black)
                            }
                            .padding(5)
                            .frame(width: 70, height: 70)
                            .background(isSelected ? Color.primaryBlue : Color.customBackground2)
                            .cornerRadius(10)
                            .overlay(
                                Group {
                                    if isSelected {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 20, height: 20)
                                            .overlay(
                                                Image(systemName: "checkmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 10, height: 10)
                                                    .foregroundColor(.white)
                                            )
                                            .offset(x: 30, y: -30)
                                    }
                                }
                            )
                            .onTapGesture {
                                viewModal.selectedBloodGroup = item.name
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 30)
                Spacer()
            }
            //.padding(.horizontal, 20)
        }
    }

    
    ///  Address page view

    func locationPage() -> some View {
        ScrollView {
            VStack {
                Image("Location")
                    .padding()
                    .frame(height: 250)

                // Address Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Where do you live?")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.primaryBlue)
                        .fontWeight(.bold)

                    Text("Your date of birth ensures personalized health insights.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 25)

                    VStack {
                        
                        // State + Country
                        HStack(spacing: 10) {
                           

                            DropdownMenu(
                                title: "Country",
                                options: viewModal.countries,
                                selectedOption: $viewModal.selectedCountry,
                                onSelect: { country in
                                    viewModal.selectedCountryID = country.id
                                    print("Selected country ID: \(country.id)")
                                    Task{
                                        await viewModal.StateData(viewModal.selectedCountryID!)
                                    }
                                }
                            )
                            
                            DropdownMenu(
                                title: "State",
                                options: viewModal.states,
                                selectedOption: $viewModal.selectedState,
                                onSelect: { state in
                                    viewModal.selectedStateID = state.id
                                    print("Selected state ID: \(state.id)")
                                    Task{
                                        await viewModal.CityData(viewModal.selectedStateID!)
                                    }
                                }
                            )
                            
                            
                        }
                        .padding(.bottom, 20)
                        
                        // Zip Code + City
                        HStack(spacing: 10) {
                            
                            DropdownMenu(
                                title: "City",
                                options: viewModal.citys,
                                selectedOption: $viewModal.selectedCity,
                                onSelect: { city in
                                    viewModal.selectedCityID = city.id
                                    print("Selected state ID: \(city.id)")
                                    
                                }
                            )
                            .padding(.bottom, 20)
                            
                            
                            VStack(alignment: .leading) {
                                Text("Zip Code")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)

                                Spacer().frame(height: 10)

                                TextField("Enter Zip Code", text: $viewModal.zipCode)
                                    .keyboardType(.numberPad)
                                    .onChange(of: viewModal.zipCode) {
                                           viewModal.zipCode = viewModal.zipCode.filter { $0.isNumber }
                                       }
                                    .padding()
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .frame(height: 50)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            .padding(.bottom, 20)

                            
                        }

                       
                        
                        // Street Address
                        VStack(alignment: .leading) {
                            Text("Street Address")
                                .font(.system(size: 14))
                                .foregroundColor(.black)

                            Spacer().frame(height: 10)

                            TextField("Street Address", text: $viewModal.streetAddress)
                                .padding(.leading)
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                                .padding(.vertical, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 30)
              
            }
         
        }
    }

    /// weight page view
    
    func weightPage() -> some View {
        VStack{
            
            Spacer().frame(height: 60)
            Image("Weight")
                .padding()
                .frame(height: 250)
            
            VStack(alignment: .leading, spacing: 8){
                Text("Your date of birth?")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.primaryBlue)
                    .fontWeight(.bold)
                
                Text("Your date of birth ensures personalized health insights.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .padding(.bottom,25)
                
                
                HStack {
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Weight")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                            Spacer()
                                .frame(height: 10)
                            
                            
                            TextField("Enter Weight", text: $viewModal.weight)
                                .padding(.leading)
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                                .padding(.vertical, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }.padding(.bottom,20)
                    }
                    
                    VStack(alignment: .leading) {
                        Spacer().frame(height: 10)
                        
                        Menu {
                            ForEach(viewModal.unitOptions, id: \.self) { option in
                                Button(action: {
                                    viewModal.selectedUnit = option
                                }) {
                                    Text(option)
                                        .font(.title)
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModal.selectedUnit)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)

                                Image(systemName: "chevron.down")
                                    .foregroundColor(.black)
                                    .frame(width: 10, height: 5)
                            }
                            .padding()
                            //.frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }

                }
                
                
                
            }.padding(.horizontal,20)
            Spacer().frame(height: 50)
            
            
            
            
        }
        //.padding(.horizontal,20)
        
    }
    
    
    /// height page view
    
    func heightSelectionPage() -> some View {
        VStack {
            ScrollView {
                VStack {
                    Image("Height")
                        .padding()
                        .frame(height: 250)
                    Spacer().frame(height: 22)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your height?")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.primaryBlue)
                            .fontWeight(.bold)
                        
                        Text("Your height will help us provide personalized health insights.")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 50)
                        
                        ZStack {
                            VStack(alignment: .leading, spacing: 5) {
                                
                                Text("Height")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.gray)
                                
                               
                                Button(action: {
                                    viewModal.showPopup.toggle()
                                }) {
                                    HStack {
                                        Text(viewModal.selectedHeightText)
                                            .foregroundColor(.gray)
                                            .padding(.leading, 10)
                                        Spacer()
                                    }
                                    .frame(height: 45)
                                    .frame(maxWidth: .infinity)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    
                    
                    
                    
                    Spacer().frame(height: 80)
                  
                }
                //.padding(.horizontal, 20)
                
            }
            // Popup for height selection
            if viewModal.showPopup {
                Color.black.opacity(0.0)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewModal.showPopup.toggle()
                    }
                
                VStack {
                    Text("Select Your Height")
                        .font(.headline)
                        .padding(.top)
                    
                    HStack {
                        // Feet Picker
                        VStack {
                            Text("Feet")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            Picker("Feet", selection: $viewModal.selectedFeet) {
                                ForEach(viewModal.feetRange, id: \.self) { ft in
                                    Text("\(ft)").tag(ft)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 70, height: 150)
                            .clipped()
                        }
                        
                        Text("•")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                        // Inches Picker
                        VStack {
                            Text("Inch")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            Picker("Inch", selection: $viewModal.selectedInches) {
                                ForEach(viewModal.inchesRange, id: \.self) { inch in
                                    Text(String(format: "%02d", inch)).tag(inch)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 70, height: 150)
                            .clipped()
                        }
                        
                        // Unit Picker
                        VStack {
                            Text("Unit")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            Picker("Unit", selection: $viewModal.selectedHeightUnit) {
                                ForEach(viewModal.units, id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 70, height: 150)
                            .clipped()
                        }
                    }
                    .padding()
                    
                    Button("Done") {
                            let feet = Double(viewModal.selectedFeet)
                            let inches = Double(viewModal.selectedInches)
                            let unit = viewModal.selectedHeightUnit
                            
                            let heightInFeet = feet + (inches / 12.0)
                            
                            viewModal.selectedHeightText = String(format: "%.1f %@", heightInFeet, unit)
                            viewModal.showPopup.toggle()
                        print("Height: \(viewModal.selectedHeightText)")
                    }
                    .frame(maxWidth: 200)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Spacer().frame(height: 15)
                }
                
                .frame(width: 300)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
               
                
            
        }
    }
        
    
    
    ///Chronic disease page

    func chronicDiseasePage() -> some View {
        VStack {
            Image("chronicDisease")
                .padding()
                .frame(height: 250)

            VStack(alignment: .leading, spacing: 8) {
                Text("Select the chronic disease you want to manage")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.primaryBlue)
                    .fontWeight(.bold)

                Text("Sharing any chronic conditions helps us provide more tailored health advice and care.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 25)

                VStack(alignment: .leading) {
                    Text("Chronic Disease")
                        .font(.system(size: 14))
                        .foregroundColor(.black)

                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("Search", text: $viewModal.searchText)
                            .foregroundColor(.primary)
                            .onChange(of: viewModal.searchText) { newValue in
                                viewModal.showCancelButton = true
                                Task {
                                    await viewModal.chronicDisease(newValue)
                                }
                            }

                        Button(action: {
                            withAnimation {
                                viewModal.searchText = ""
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .opacity(viewModal.searchText.isEmpty ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    
                    if !viewModal.filteredResults.isEmpty {
                        List(viewModal.filteredResults, id: \.id) { result in
                            Button(action: {
                                if !viewModal.selectedItems.contains(where: { $0.id == result.id }) {
                                    viewModal.selectedItems.append(result)
                                }
                                viewModal.searchText = ""
                                for item in viewModal.selectedItems {
                                    print("🩺 \(item.problemName)")
                                    print("🩺 \(item.id)")
                                }
                                                                       
                            }) {
                                Text(result.problemName)
                            }
                        }
                        .transition(.opacity)
                        .frame(height: 200)
                        .listStyle(PlainListStyle())
                        .padding(0)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                    }

                    if !viewModal.selectedItems.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModal.selectedItems, id: \.id) { item in
                                    Text(item.problemName)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.blue.opacity(0.2))
                                        .foregroundColor(.blue)
                                        .font(.system(size: 14))
                                        .cornerRadius(20)
                                        .overlay(
                                            Circle()
                                                .fill(Color.red.opacity(0.2))
                                                .frame(width: 20, height: 20)
                                                .overlay(
                                                    Image(systemName: "xmark")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 10, height: 10)
                                                        .foregroundColor(Color.red)
                                                )
                                                .offset(x: 38, y: -10)
                                        )
                                        .onTapGesture {
                                            viewModal.selectedItems.removeAll { $0.id == item.id }
                                        }
                                }
                            }
                        }
                        .transition(.slide)
                        .padding(.all)
                    }
                }
                .navigationBarHidden(viewModal.showCancelButton)
                .resignKeyboardOnDragGesture()
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 50)
          
        }
        //.padding(.horizontal, 20)
    }
    
    
    /// chronic condition page

    func chronicConditionPage() -> some View {
        VStack {
                   Image("chronicCondition")
                       .padding()
                       .frame(maxWidth: .infinity, maxHeight: 250)
                   
                   VStack(alignment: .leading, spacing: 8) {
                       // Title & Subtitle
                       Text("Inform us if you have any other chronic conditions.")
                           .font(.system(size: 32))
                           .foregroundStyle(Color.primaryBlue)
                           .fontWeight(.semibold)
                       
                       Text("Sharing any chronic conditions helps us provide more tailored health advice and care.")
                           .font(.system(size: 16))
                           .foregroundStyle(.secondary)
                           .padding(.bottom, 25)
                       
                       VStack(alignment: .leading) {
                           Text("Chronic Disease")
                               .font(.system(size: 14))
                               .foregroundColor(.black)

                           // Search Bar
                           HStack {
                               Image(systemName: "magnifyingglass")

                               TextField("Search", text: $viewModal.searchChronicConditionText)
                                   .foregroundColor(.primary)
                                   .onChange(of: viewModal.searchChronicConditionText) { newValue in
                                       viewModal.showCancelButtonChronicCondition = true
                                       Task {
                                           await viewModal.chronicDisease(newValue)
                                       }
                                   }

                               Button(action: {
                                   withAnimation {
                                       viewModal.searchChronicConditionText = ""
                                   }
                               }) {
                                   Image(systemName: "xmark.circle.fill")
                                       .opacity(viewModal.searchChronicConditionText.isEmpty ? 0 : 1)
                               }
                           }
                           .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                           .foregroundColor(.secondary)
                           .background(Color(.secondarySystemBackground))
                           .cornerRadius(10.0)

                           // Filtered List
                           if !viewModal.filteredResultsChronicCondition.isEmpty {
                               List(viewModal.filteredResultsChronicCondition, id: \.id) { result in
                                   Button(action: {
                                       if !viewModal.selectedChronicConditionItems.contains(where: { $0.id == result.id }) {
                                           viewModal.selectedChronicConditionItems.append(result)
                                       }
                                       viewModal.searchChronicConditionText = ""
                                       for item in viewModal.selectedChronicConditionItems {
                                           print("🩺 \(item.problemName)")
                                           print("🩺 \(item.id)")
                                       }
                                   }) {
                                       Text(result.problemName)
                                   }
                               }
                               .transition(.opacity)
                               .frame(height: 200)
                               .listStyle(PlainListStyle())
                               .padding(0)
                               .scrollContentBackground(.hidden)
                               .background(Color.white)
                           }

                           // Selected Items
                           if !viewModal.selectedChronicConditionItems.isEmpty {
                               ScrollView(.horizontal, showsIndicators: false) {
                                   HStack {
                                       ForEach(viewModal.selectedChronicConditionItems, id: \.id) { item in
                                           Text(item.problemName)
                                               .padding(.horizontal, 16)
                                               .padding(.vertical, 8)
                                               .background(Color.blue.opacity(0.2))
                                               .foregroundColor(.blue)
                                               .font(.system(size: 13))
                                               .cornerRadius(20)
                                               .overlay(
                                                   Circle()
                                                       .fill(Color.red.opacity(0.2))
                                                       .frame(width: 20, height: 20)
                                                       .overlay(
                                                           Image(systemName: "xmark")
                                                               .resizable()
                                                               .scaledToFit()
                                                               .frame(width: 10, height: 10)
                                                               .foregroundColor(Color.red)
                                                       )
                                                       .offset(x: 38, y: -10)
                                               )
                                               .onTapGesture {
                                                   viewModal.selectedChronicConditionItems.removeAll { $0.id == item.id }
                                               }
                                       }
                                   }
                               }
                               .transition(.slide)
                               .padding(.all)
                           }
                       }
                       .navigationBarHidden(viewModal.showCancelButtonChronicCondition)
                       .resignKeyboardOnDragGesture()
                   }
                   .padding(.horizontal, 20)
                   
                   Spacer().frame(height: 50)
               }
               //.padding(.horizontal, 20)
           
    }
    
    
    
    /// HeathHistory page

    
    func healthHistoryPage() -> some View {
        ZStack {
            ScrollView {
                VStack{
                    Image("Family-Health")
                        .padding()
                        .frame(height: 250)
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("Your Family's Health History")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.primaryBlue)
                            .fontWeight(.bold)
                        
                        Text("Are there any hereditary conditions in your family?")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                            .padding(.bottom,25)
                        
                        
                        
                        VStack(alignment: .leading){
                            Text("Chronic Disease")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                            
                            HStack {
                                Image(systemName: "magnifyingglass")
                                
                                TextField("Search", text: $viewModal.searchHealthHistoryText, onEditingChanged: { isEditing in
                                    withAnimation {
//                                        viewModal.showHealthHistoryPopup = true
                                        viewModal.showHealthHistoryCancelButton = true
                                    }
                                })
                                .foregroundColor(.primary)
                                
                                
                                
                                
                                Button(action: {
                                    withAnimation {
                                        self.viewModal.searchHealthHistoryText = ""
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        //.opacity($searchHealthHistoryText.isEmpty ? 0 : 1)
                                }
                            }
                            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                            .foregroundColor(.secondary)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10.0)
                            
                            if !viewModal.filteredHealthHistoryResults.isEmpty {
                                List(viewModal.filteredHealthHistoryResults, id: \.self) { result in
                                    Button(action: {
                                        if !viewModal.selectedHealthHistoryItems.contains(result) {
                                            viewModal.selectedHealthHistoryItems.append(result)
                                            
                                            
                                            viewModal.tempSelectedHealthHistoryItems = Set(viewModal.selectedHealthHistoryItems)
                                            viewModal.showHealthHistoryPopup = true
                                        }
                                        viewModal.searchHealthHistoryText = ""
                                    }) {
                                        Text(result)
                                    }
                                }
                                .transition(.opacity)
                                .frame(height: 200)
                                .listStyle(PlainListStyle())
                                .padding(0)
                                .scrollContentBackground(.hidden)
                                .background(Color.white)
                            }
                            
                            
                            if !viewModal.selectedHealthHistoryItems.isEmpty {
                                VStack(alignment: .leading) {
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack{
                                            ForEach(viewModal.selectedHealthHistoryItems, id: \.self) { item in
                                                
                                                VStack {
                                                    Text("dddddd")
                                                    Text(item)
                                                        
                                                }.padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(Color.blue.opacity(0.2))
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 13))
                                                    .cornerRadius(20)
                                                    .overlay(
                                                        Circle()
                                                            .fill(Color.red.opacity(0.2))
                                                            .frame(width: 20, height: 20)
                                                            .overlay(
                                                                Image(systemName: "xmark")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 10, height: 10)
                                                                    .foregroundColor(Color.red)
                                                            )
                                                            .offset(x: 38, y: -10)
                                                        
                                                    )
                                                    .onTapGesture {
                                                        viewModal.selectedHealthHistoryItems.removeAll { $0 == item }
                                                    }
                                                
                                            }
                                        }
                                        
                                    }
                                }
                                .transition(.slide)
                                .padding(.all)
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                        }
                        .navigationBarHidden(viewModal.showHealthHistoryPopup)
                        .resignKeyboardOnDragGesture()
                        
                        
                        
                        
                        
                    }.padding(.horizontal,20)
                   
                    
                    
                    
                }
                //.padding(.horizontal,20)
            }
            if viewModal.showHealthHistoryPopup {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewModal.showHealthHistoryPopup = false
                    }

                VStack {
                    VStack(alignment: .leading,spacing: 20){
                        Text("Select Relation")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .padding(.leading)
                            .padding(.top,20)
                        Text("Who in your family has been diagnosed with this disease?")
                            .font(.system(size: 13))
                            .padding(.leading)
                        
                        List(["Mother", "Father", "Brother", "Sister", "Grand Parent"], id: \.self) { item in
                            HStack {
                                Text(item)
                                Spacer()
                                if viewModal.tempSelectedHealthHistoryItems.contains(item) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if viewModal.tempSelectedHealthHistoryItems.contains(item) {
                                    viewModal.tempSelectedHealthHistoryItems.remove(item)
                                } else {
                                    viewModal.tempSelectedHealthHistoryItems.insert(item)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        
                        Spacer()
                        
                        
                        
                    }
                    
                    Button("Done") {
//                        selectedItems = Array(tempSelectedItems)
                        print("Selected Items: \(viewModal.tempSelectedHealthHistoryItems)")
                        
                        
                        viewModal.showHealthHistoryPopup = false
                    }
                    
                    .frame(maxWidth: 200)
                    .frame(height: 40, alignment: Alignment.center)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Spacer()
                }
                .frame(width: 300, height: 400)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .shadow(radius: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                
                )
            }
        }
    }
    
    
    /// VitalReminder Page
    
    func vitalReminderPage() -> some View {
        ZStack {
            VStack{
                Spacer().frame(height: 60)
                Image("Vital-Reminder")
                    .padding()
                    .frame(width: .infinity,height: 250)
                
                VStack(alignment: .leading, spacing: 8){
                    Text("Set Vital Reminder")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.primaryBlue)
                        .fontWeight(.bold)
                    
                    Text("Your primary details are uploaded. Please select the interval for your vital reminders.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .padding(.bottom,25)
                    
                    
                    ZStack {
                        VStack {
                            ScrollView {
                                ForEach(viewModal.vitalsData) { data in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(data.name)
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            
                                            Text(data.subName)
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .frame(height: 60)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .onTapGesture {
                                        viewModal.showPopupReminder = true
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                }.padding(.horizontal,20)
                Spacer().frame(height: 50)
                
        
            }.padding(.horizontal,20)
            
            
            if viewModal.showPopupReminder {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewModal.showPopupReminder = false
                    }

                VStack {
                   
                    ScrollView {
                        ForEach(viewModal.vitalsData) { data in
                            HStack {
                                Text(data.subName)
                                    .frame(width: .infinity,alignment: .leading)
                                
                                Spacer()
                                Text("dd")
                            }
                            .padding(.horizontal,20)
                            .padding(.vertical,8)
                            .onTapGesture {
                                viewModal.selectedSubName = data.subName
                                viewModal.showPopup = false
                            }
                                
                                
                                
                            Divider()
                                .padding(.horizontal,20)
                                
                            
                        }
                    }
                    .padding(.top,30)
                    
                    Button("Done") {
//                        selectedItems = Array(tempSelectedItems)
                        
                        viewModal.showPopupReminder = false
                    }
                    
                    .frame(maxWidth: 200)
                    .frame(height: 40, alignment: Alignment.center)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Spacer()
                }
                .frame(width: 300, height: 400)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .shadow(radius: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                
                )
            }
        }
    }
    
    
    /// fluide intake details Page
    
    
    func fluidIntakeDetailsPage() -> some View {            VStack{
                Spacer().frame(height: 60)
                Image("Fluid-Intake")
                    .padding()
                    .frame(width: .infinity,height: 250)
                
                VStack(alignment: .leading, spacing: 8){
                    Text("Fluid Intake Details")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.primaryBlue)
                        .fontWeight(.bold)
                    
                    Text("We've got the time to remind you for your vitals. Let us know about your fluid intake.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .padding(.bottom,25)
                    
                    
                    
                    HStack {
                        CustomTextField1(
                            text: $viewModal.name,
                            title: "Fluid Intake",
                            placeholder: "Enter your daily fluid intake",
                            onChange: { newValue in
                                print("Changed to: \(newValue)")
                            },
                            titleFont: .footnote,
                            titleColor:  .gray,
                            textFieldFont: .headline,
                            textColor: .red,
                            backgroundColor: Color.white,
                            cornerRadius: 8,
                            showBorder: true,
                            borderColor: .gray.opacity(0.3)
                            
                        )
                        
                        VStack(alignment: .leading) {
                            Spacer().frame(height: 15)
                            
                            Menu {
                                ForEach(viewModal.fludeIntakeUnitOptions, id: \.self) { option in
                                    Button(action: {
                                        viewModal.selectedfluidIntakeUnit = option
                                    }) {
                                        Text(option)
                                            .font(.title)
                                    }
                                }
                            } label: {
                                HStack(alignment: .center) {
                                    Text(viewModal.selectedfluidIntakeUnit)
                                        .font(.system(size: 18))
                                        .foregroundColor(.secondary)
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.secondary)
                                        .frame(width: 16, height: 16)
                                }
                                .padding()
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }.padding(.horizontal,20)
                Spacer().frame(height: 50)
                
                
            }.padding(.horizontal,20)
        }
    
    
}

#Preview {
    CreateAccountView().environmentObject(SignUpViewModal())
}







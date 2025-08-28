//
//  CreateAccountView.swift
//  vitalio_native
//
// Enhance and fixed by Baqar Naqvi

import SwiftUI

struct CreateAccountView: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var route: Routing
//    @EnvironmentObject var viewModal: SignUpViewModal
    @StateObject private var viewModal = SignUpViewModal()
    @EnvironmentObject var loginVM: LoginViewModal
    @State private var selectedField: EditableField? = nil
    

    var body: some View {
        ZStack{
            
            VStack{
                HStack{
                    CustomNavBarView(title: "Create Account" , isDarkMode: false){
                        print("ok")
                        if(viewModal.currentPage < 1){
                            route.back()
                        }else{
                            viewModal.currentPage -= 1
                            viewModal.currentProgress -= 1
                            print("hello \(viewModal.firstName) current page: \(viewModal.currentPage) ")
                        }
                    }
                    if ![10, 11, 14].contains(viewModal.currentPage){
                        Button(action: {
                            if viewModal.currentPage >= 3{
                                if(viewModal.currentPage == 4){
                                    viewModal.fullAddress = ""
                                }
                                viewModal.currentPage += 1
                                print("baqar current page: \(viewModal.currentPage) ")
                                if viewModal.currentPage != 8 && viewModal.currentPage != 11 && viewModal.currentPage != 12 {
                                    viewModal.currentProgress += 1
                                }
                                
                                
                            }

                        }) {
                            Text("Skip")
                                .font(.system(size: 18))
                                .foregroundColor(.primaryBlue)
                                .opacity(viewModal.currentPage < 3 ? 0.2 : 0.8 )
                                .fontWeight(.semibold)
                        }.padding(.horizontal, 10)
                    }
                }
                
                ScrollView {
                    if viewModal.currentPage == 11 {
                        Spacer().frame(height:20)
                        GIFView(gifName: "confetti")
                            .scaledToFit()
                            .frame(height: 250)
                    }
                    if (viewModal.currentPage != 14){
                        VStack(alignment:viewModal.currentPage == 11 ? .center : .leading, spacing: 8) {
                            
                            HStack {
                                Text("\(Int((Double(viewModal.currentProgress) / 11.0) * 100))%")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.primaryBlue)
                                
                                
                                ProgressView(value: Double(viewModal.currentProgress) / 11.0)
                                    .tint(.blue)
                                    .frame(height: 10)
                                    .animation(.easeInOut(duration: 1), value: viewModal.currentPage)
                                
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModal.progressStages[viewModal.currentPage])
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .transition(.opacity)
                                    .id(viewModal.currentPage) // triggers animation
                                    .animation(.easeInOut(duration: 1), value: viewModal.currentPage)
                                
                                Text(viewModal.progressMessages[viewModal.currentPage])
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                                    .transition(.opacity)
                                    .id("msg\(viewModal.currentPage)") // unique ID to trigger transition
                                    .animation(.easeInOut(duration: 1), value: viewModal.currentPage)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Color.customBackground2)
                        .cornerRadius(10)
                    }
                    Group {
                        switch viewModal.currentPage {
                        case 0: firstPage()
                        case 1: secondPages()
                        case 2: dobPage()
                        case 3: bloodGroupPage()
                        case 4: locationPage()
                        case 5: weightPage()
                        case 6: heightSelectionPage()
                        case 7: chronicDiseasePage()
                        case 8: otherDiseasePage()
                        case 9: healthHistoryPage()
                        case 10: ProfileSummaryPage()
                        case 11: thankYouPage()
                        case 12: vitalReminderPage()
                        case 13: fluidIntakeDetailsPage()
                        case 14: completionSuccessView()
                        default: EmptyView()
                        }
                    }
                    .frame(height: 600)
                    .frame(maxHeight: .infinity)


                    if(viewModal.currentPage != 11 && viewModal.currentPage != 14){
                        Button(action: {
                            withAnimation {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                                if(viewModal.firstName.isEmpty){
//                                    showGlobalError(message: "First Name Should Not be empty")
//                                    return
//                                }
                                if viewModal.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    viewModal.showFirstNameError = true
                                    return
                                } else {
                                    viewModal.showFirstNameError = false
                                }

                                
                                if(viewModal.currentPage == 1 && viewModal.selectedGender == nil){
                                    showGlobalError(message: "Please select gender")
                                    return
                                }
                                if(viewModal.formattedDate.isEmpty){
                                    showGlobalError(message: "Please select DOB")
                                    return
                                }
                                
                                if(viewModal.currentPage < 14){
                                    if(viewModal.lastPage == -1 ){
                                        if viewModal.currentPage == 4 {
                                            var addressComponents: [String] = []
                                            
                                            if !viewModal.streetAddress.isEmpty {
                                                addressComponents.append(viewModal.streetAddress)
                                            }
                                            
                                            if let city = viewModal.selectedCity?.name, !city.isEmpty {
                                                addressComponents.append(city)
                                            }
                                            
                                            if let state = viewModal.selectedState?.stateName, !state.isEmpty {
                                                addressComponents.append(state)
                                            }
                                            
                                            if let country = viewModal.selectedCountry?.countryName, !country.isEmpty {
                                                addressComponents.append(country)
                                            }
                                            
                                            var fullAddress = addressComponents.joined(separator: ", ")
                                            
                                            // Append zip code if it exists
                                            if !viewModal.zipCode.isEmpty {
                                                fullAddress += "-\(viewModal.zipCode)"
                                            }
                                            
                                            viewModal.fullAddress = fullAddress
                                            
                                            print(viewModal.fullAddress)
                                        }
                                        viewModal.currentPage += 1
                                        print("baqar current page: \(viewModal.currentPage) ")
                                        if viewModal.currentPage != 8 && viewModal.currentPage != 11 && viewModal.currentPage != 12 {
                                            print("tillu")
                                            viewModal.currentProgress += 1
                                        }
                                        print("hello \(viewModal.firstName) current page: \(viewModal.currentPage) ")
                                    }
                                    else {
                                        if viewModal.currentPage == 4 {
                                            var addressComponents: [String] = []
                                            
                                            if !viewModal.streetAddress.isEmpty {
                                                addressComponents.append(viewModal.streetAddress)
                                            }
                                            
                                            if let city = viewModal.selectedCity?.name, !city.isEmpty {
                                                addressComponents.append(city)
                                            }
                                            
                                            if let state = viewModal.selectedState?.stateName, !state.isEmpty {
                                                addressComponents.append(state)
                                            }
                                            
                                            if let country = viewModal.selectedCountry?.countryName, !country.isEmpty {
                                                addressComponents.append(country)
                                            }
                                            
                                            var fullAddress = addressComponents.joined(separator: ", ")
                                            
                                            // Append zip code if it exists
                                            if !viewModal.zipCode.isEmpty {
                                                fullAddress += "-\(viewModal.zipCode)"
                                            }
                                            
                                            viewModal.fullAddress = fullAddress
                                            
                                            print(viewModal.fullAddress)
                                        }

                                        viewModal.currentPage = viewModal.lastPage
                                        viewModal.lastPage = -1
                                    }
                                    
                                    
                                }else{
                                    Task {
                                        let success = await viewModal.submitPatientDetails(number: loginVM.uhidNumber)
                                        print("insideView \(success)")
                                        if success {
                                            print("inside if \(success)")
                                            route.navigate(to: .dashboard)
                                        } else {
                                            print("inside else \(success)")
                                        }
                                    }
                                    
                                }
                            }
                        }) {
                            Text("Next")
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .padding()
                                .foregroundColor(.white)
                                .background({
                                    if viewModal.firstName.isEmpty {
                                        Color.gray
                                    } else if viewModal.selectedGender == nil && viewModal.currentPage == 1{
                                        Color.gray
                                    } else {
                                        Color.primaryBlue
                                    }
                                }())

                                .background(viewModal.firstName.isEmpty ? Color.gray : Color.primaryBlue)
                                .cornerRadius(14)
                        }
                    }
                    
                    
                    
                }
                .padding(.horizontal, 8)
            }
//            SuccessPopupViewError(show: $viewModal.showError, message: viewModal.errorIs)
//                .zIndex(1)
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
                        
                        List(FamilyMember.allCases) { member in
                            let isSelected = viewModal.tempSelectedHealthHistoryItems.contains(member.rawValue)
                            
                            HStack {
                                Text(member.rawValue)
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                                else {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.secondary)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if isSelected {
                                    viewModal.tempSelectedHealthHistoryItems.remove(member.rawValue)
                                } else {
                                    viewModal.tempSelectedHealthHistoryItems.insert(member.rawValue)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())

                        
                        Spacer()
                    }
                    
                    Button("Done") {
//                        selectedItems = Array(tempSelectedItems)
                        print("Selected Items: \(viewModal.tempSelectedHealthHistoryItems)")
                        viewModal.assignSelectedProblemsToRelations()
                            viewModal.showHealthHistoryPopup = false
                        viewModal.printResultMapFamilyProblem()
                        
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
//            if viewModal.showLoader {
//                    Color.black.opacity(0.3)
//                        .edgesIgnoringSafeArea(.all)
//                    
//                    ProgressView("Please wait...")
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(radius: 10)
//                }
        }
        .onAppear(){
            viewModal.route = route
            Task{
              await  viewModal.hitFrequencyApi()
            }
         
        }
//        .onTapGesture {
//            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        }
        .navigationBarHidden(true)
    }

    func firstPage(isEdit: Bool = false) -> some View {
        LazyVStack(spacing: 0)  {
            if !isEdit {
                GIFView(gifName: "namegif")
                    .scaledToFit()
                    .frame(height: 250)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome to Vitalio.")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.primaryBlue)
                        .fontWeight(.bold)

                    Text("Let us know about you so we can manage to help you in better ways.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("First Name")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                
                ZStack(alignment: .topTrailing) {
                    TextField("Type your first name", text: $viewModal.firstName)
                        .padding(.leading)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModal.showFirstNameError ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .onChange(of: viewModal.firstName) { newValue in
                            let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                            if filtered != newValue {
                                viewModal.firstName = filtered
                            }
                            // Optional: dismiss error when valid input
                            if !filtered.isEmpty {
                                viewModal.showFirstNameError = false
                            }
                        }

                    if viewModal.showFirstNameError {
                        ErrorTooltipView()
                            .offset(x: 10, y: 30)
                    }
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 20)


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
                    .onChange(of: viewModal.lastNmae) { newValue in
                        let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                        if filtered != newValue {
                            viewModal.lastNmae = filtered
                        }
                    }
            }
            .padding(.horizontal, 20)

            if !isEdit {
                Spacer().frame(height: 30)
            }
        }.onTapGesture {
            // Dismiss keyboard when tapping outside
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }


    struct ErrorTooltipView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text("Please enter your name")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Enter your full legal name as it appears on official documents.")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 2)
            }
            .padding(.top, 8) // 👈 extra space above first text
            .padding(12)
            .background(
                TooltipShape()
                    .fill(Color(red: 64/255, green: 80/255, blue: 113/255))
            )
            .frame(width: 220)
            .shadow(radius: 4)
        }
    }

    struct TooltipShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let arrowSize: CGFloat = 10
            let cornerRadius: CGFloat = 12
            
            let arrowCenterX = rect.midX - 70 // shifted left for narrower tooltip

            // Arrow shifted left
            path.move(to: CGPoint(x: arrowCenterX - 10, y: arrowSize))
            path.addLine(to: CGPoint(x: arrowCenterX, y: 0))
            path.addLine(to: CGPoint(x: arrowCenterX + 10, y: arrowSize))
            path.closeSubpath()

            // Rounded rectangle below arrow
            path.addRoundedRect(
                in: CGRect(x: 0, y: arrowSize, width: rect.width, height: rect.height - arrowSize),
                cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
            )
            
            return path
        }
    }




    
    

    struct GenderOptionView: View {
        var data: Gender
        var isSelected: Bool
        var onTap: () -> Void

        var body: some View {
            VStack {
                Image(data.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text(data.name)
                    .font(.system(size: 14))
                    .foregroundColor(isSelected ? .white : .black)
            }
            .frame(width: 100, height: 100)
            .background(isSelected ? Color.primaryBlue : Color.customBackground2)
            .cornerRadius(10)
            .overlay(
                isSelected ?
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
                onTap()
            }
        }
    }

    func secondPages(isEdit: Bool = false) -> some View {
        VStack {
            if !isEdit {
                GIFView(gifName: "gendergif").frame(height: 250)
                    .padding()
            }

            VStack(alignment: .leading, spacing: 8) {
                if !isEdit {
                    Text("Gender")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.primaryBlue)
                        .fontWeight(.bold)

                    Text("Hi \(viewModal.firstName), let us know if you are male or female.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 30)
                }

                // 👇 Replace LazyVGrid with horizontal scroll
                
                    HStack(spacing: 16) {
                        ForEach(viewModal.genders) { data in
                            GenderOptionView(
                                data: data,
                                isSelected: viewModal.selectedGender == data.value
                            ) {
                                viewModal.selectedGender = data.value
                                viewModal.selectedGenderId = data.gederId
                            }
                        }
                    }
                    .padding(.vertical, 4)
             
            }
           

            if !isEdit {
                Spacer().frame(height: 60)
            }
        }
        .padding(.horizontal, 10)
    }


    
    
    
    
    /// DOB view page
    
    func dobPage(isEdit: Bool = false) -> some View {
        VStack {
            if !isEdit {
                GIFView(gifName: "gif2")
                    .scaledToFit()
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
                }
            }

            DatePicker(
                "",
                selection: $viewModal.selectedDate,
                in: ...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .frame(maxWidth: .infinity, maxHeight: 200)
            .clipped()
            .onChange(of: viewModal.selectedDate) { newDate in
                let today = Date()
                if newDate > today {
                    viewModal.selectedDate = today
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    print("Selected date: \(formatter.string(from: newDate))")
                    viewModal.formattedDate = formatter.string(from: newDate)
                }
            }


            Spacer().frame(height: 30)
        }
        .padding(.horizontal, 20)
    }


    
    /// Blood View Page
    
    
    func bloodGroupPage(isEdit: Bool = false) -> some View {
        ScrollView {
            VStack(alignment: .center) {
                if !isEdit {
                    GIFView(gifName: "bloodgif")
                        .scaledToFit()
                        .frame(height: 220)
                        .padding(.top, 10)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("And what is your Blood Group?")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.primaryBlue)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Your blood group helps ensure accurate and personalized care.")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 30)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 20)
                }

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
                            viewModal.selectedBloodGroupId = item.unit
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 30)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }



    
    ///  Address page view

    func locationPage(isEdit: Bool = false) -> some View {
        ZStack {
            VStack(spacing: 0) {
                
                if !isEdit {
                    GIFView(gifName: "addressgif")
                        .scaledToFit()
                        .frame(height: 250)
                       
                        .background(Color.white)
                }
                
                ScrollView {
                    VStack {
                        if !isEdit {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Where do you live?")
                                    .font(.system(size: 32))
                                    .foregroundStyle(Color.primaryBlue)
                                    .fontWeight(.bold)

                                Text("Your address helps us provide location-based services and personalized care.")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 25)
                            }
                            .padding(.horizontal, 20)
                        }

                        VStack {
                            if !isEdit {
                                HStack(spacing: 10) {
                                    DropdownMenu(
                                        title: "Country",
                                        options: viewModal.countries,
                                        selectedOption: $viewModal.selectedCountry,
                                        onSelect: { country in
                                            viewModal.selectedCountryID = country.id
                                            print("selectedCountryID \(country.id)")
                                            Task {
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
                                            Task {
                                                await viewModal.CityData(viewModal.selectedStateID!)
                                            }
                                        }
                                    )
                                }
                                .padding(.bottom, 20)

                                HStack(spacing: 10) {
                                    DropdownMenu(
                                        title: "City",
                                        options: viewModal.citys,
                                        selectedOption: $viewModal.selectedCity,
                                        onSelect: { city in
                                            viewModal.selectedCityID = city.id
                                            
                                        }
                                    )
                                    .padding(.bottom, 20)

                                    VStack(alignment: .leading) {
                                        Text("Zip Code")
                                            .font(.system(size: 14))
                                            .foregroundColor(.black)

                                        Spacer().frame(height: 10)

                                        TextField("Enter Zip Code", text: Binding(
                                            get: { viewModal.zipCode },
                                            set: { viewModal.zipCode = $0.filter { $0.isNumber } }
                                        ))
                                        .keyboardType(.numberPad)
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
                            }

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
                        .padding(.horizontal, 20)
                        .disabled(viewModal.isLoading)

                        Spacer().frame(height: 30)
                    }
                }
            }

            if viewModal.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                    .background(Color(.systemBackground).opacity(0.8))
                    .cornerRadius(10)
            }
        }
    }



    /// weight page view
    
    func weightPage(isEdit: Bool = false) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                if !isEdit {
                    GIFView(gifName: "weightgif")
                       // remove if your GIFView is not an Image
                        .scaledToFit()
                        .frame(height: 250)
                        .padding(.top, 10)
                        .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("What is your current weight?")
                            .font(.system(size: 32))
                            .foregroundStyle(Color.primaryBlue)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)

                        Text("Your weight helps us provide tailored health and fitness recommendations.")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 25)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 20)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text("Weight")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                            Spacer().frame(height: 10)

                            TextField("Enter Weight", text: $viewModal.weight)
                                .keyboardType(.decimalPad)
                                .padding(.leading)
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding(.bottom, 20)

                        VStack(alignment: .leading) {
                            Spacer().frame(height: 10)

                            Menu {
                                ForEach(viewModal.unitOptions, id: \.self) { option in
                                    Button(action: {
                                        viewModal.selectedUnit = option
                                    }) {
                                        Text(option)
                                            .font(.system(size: 16))
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
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 50)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }


    
    
    /// height page view
    
    func heightSelectionPage(isEdit: Bool = false) -> some View {
        VStack {
            ScrollView {
                VStack {
                    if !isEdit {
                        GIFView(gifName: "heightgif").scaledToFit()
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("What is your height?")
                                .font(.system(size: 32))
                                .foregroundStyle(Color.primaryBlue)
                                .fontWeight(.bold)

                            Text("Your height will help us provide personalized health insights.")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 50)
                        }
                        .padding(.horizontal, 20)
                    }

                    VStack(alignment: .leading, spacing: 8) {
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
            }

            // Height Popup
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
                        print("heightInFeet: \(heightInFeet)")
                        viewModal.selectedHeightText = String(format: "%.1f %@", heightInFeet, unit)
                        print("selectedHeightText: \(viewModal.selectedHeightText)")
                        viewModal.showPopup.toggle()

                        if let cm1 = viewModal.convertToCentimeters(from: viewModal.selectedHeightText) {
                            viewModal.selectedHeightText = "\(cm1)"
                        }
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
        VStack(spacing: 0) {
            // GIF always visible
            GIFView(gifName: "diseasegif")
                .scaledToFit()
                .frame(height: 250)
                .background(Color.white)
            
            ScrollView {
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
                        searchBarView()
                        filteredListView()
                        selectedTagsView()
                    }
                    .navigationBarHidden(viewModal.showCancelButton)
                    .resignKeyboardOnDragGesture()
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 50)
            }
        }
    }


    // Subviews

    @ViewBuilder
    func searchBarView() -> some View {
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
            .padding(.all, 8)
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
    }

    @ViewBuilder
      func filteredListView() -> some View {
          if !viewModal.filteredResults.isEmpty {
              List(viewModal.filteredResults, id: \.id) { result in
                  Button(action: {
                      print("Selected: \(result.id)")
                      if viewModal.currentPage == 7 {
                          print("select the chronic \(viewModal.currentPage)")
                          if !viewModal.selectedItems.contains(where: { $0.id == result.id }) {
                              viewModal.selectedItems.append(result)
                              let currentDateTime = viewModal.getCurrentDateTimeString()
                              let detail = PatientDetail(
                                  detailID: String(describing: result.id),
                                                 detailsDate: currentDateTime,
                                  details: result.problemName,
                                                 isFromPatient: "1"
                                             )
                              viewModal.addDetail(detail)
                          }
                      }
                      else if viewModal.currentPage == 8 {
                          print("other disease")
                          if !viewModal.OtherselectedDiseaseItems.contains(where: { $0.id == result.id }) {
                              viewModal.OtherselectedDiseaseItems.append(result)
                              let currentDateTime = viewModal.getCurrentDateTimeString()
                              let detail = PatientDetail(
                                  detailID: String(describing: result.id),
                                                 detailsDate: currentDateTime,
                                  details: result.problemName,
                                                 isFromPatient: "1"
                                             )
                              viewModal.addOtherDiseaseDetail(detail)
                          }
                      }
                      else {
                          if !viewModal.familyProblems.contains(where: { $0.id == result.id }) {
                                                              viewModal.familyProblems.append(result)
                                                              print("viewModal.familyProblems \(viewModal.familyProblems)")
                                                              viewModal.showHealthHistoryPopup = true
                                                          }else {
                                                              print( "already exist")
                                                          }
                          print("gggg \(viewModal.familyProblems)")
                      }
                      
                      viewModal.searchText = ""
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
      }

    @ViewBuilder
    func selectedTagsView() -> some View {
        if !(viewModal.currentPage == 8 ? viewModal.OtherselectedDiseaseItems.isEmpty : viewModal.selectedItems.isEmpty) {
            // This wrapper ensures it takes all available width
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        ForEach(viewModal.currentPage == 8
                                ? viewModal.OtherselectedDiseaseItems
                                : viewModal.selectedItems, id: \.id) { item in
                            ZStack(alignment: .topTrailing) {
                                Text(item.problemName)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .font(.system(size: 14))
                                    .cornerRadius(20)

                                Button(action: {
                                    
                                    if viewModal.currentPage == 8 {
                                        viewModal.OtherselectedDiseaseItems.removeAll { $0.id == item.id }
                                        viewModal.removeOtherDiseaseDetail(byID: "\(item.id)")
                                    }
                                    else {
                                        viewModal.selectedItems.removeAll { $0.id == item.id }
                                        viewModal.removeDetail(byID: "\(item.id)")
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(.red)
                                        .padding(6)
                                        .background(Color.red.opacity(0.2))
                                        .clipShape(Circle())
                                }
                                .offset(x: 8, y: -8)
                            }
                            .fixedSize()
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity) // ✅ Ensures horizontal ScrollView can scroll
            }
            .padding(.vertical)
            .transition(.slide)
        }
    }

    func otherDiseasePage() -> some View {
        VStack(spacing: 0) {
            // GIF always visible
            GIFView(gifName: "other_disease")
                .scaledToFit()
                .frame(height: 250)
                .background(Color.white)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Inform us if you have any other chronic conditions.")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.primaryBlue)
                        .fontWeight(.bold)

                    Text("If you have any other ongoing health conditions, telling us will help improve your care.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 25)

                    VStack(alignment: .leading) {
                        searchBarView()
                        filteredListView()
                        selectedTagsView()
                    }
                    .navigationBarHidden(viewModal.showCancelButton)
                    .resignKeyboardOnDragGesture()
                }
                .padding(.horizontal, 20)

                Spacer().frame(height: 50)
            }
        }
    }

    
    
    /// chronic condition page

    func chronicConditionPage() -> some View {
        VStack {
                   Image("chronicCondition")
                       .padding()
                   
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
       
            
                VStack(spacing: 0){
                    GIFView(gifName: "familygif").scaledToFit()
                        .frame(height: 250)
                        .background(Color.white)
                    ScrollView{
                        VStack(alignment: .leading, spacing: 8){
                            Text("Your Family's Health History")
                                .font(.system(size: 32))
                                .foregroundStyle(Color.primaryBlue)
                                .fontWeight(.bold)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                            
                            Text("Are there any hereditary conditions in your family?")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 25)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                            
                            
                            VStack(alignment: .leading) {
                                
                                searchBarView()
                                filteredListView()
                                ScrollView{
                                    // Show diseases grouped by family member
                                    VStack(alignment: .leading, spacing: 16) {
                                        ForEach(FamilyMember.allCases, id: \.self) { member in
                                            if let problems = viewModal.problemsByFamily[member], !problems.isEmpty {
                                                ZStack(alignment: .topTrailing) {
                                                    VStack(alignment: .leading, spacing: 6) {
                                                        Text(member.rawValue)
                                                            .font(.headline)
                                                            .foregroundColor(.secondary)
                                                        
                                                        ForEach(problems, id: \.id) { problem in
                                                            Text("• \(problem.problemName)")
                                                                .font(.subheadline)
                                                                .foregroundColor(Color.primaryBlue)
                                                                .padding(.leading, 10)
                                                        }
                                                    }
                                                    .padding()
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .background(Color(.secondarySystemBackground))
                                                    .cornerRadius(12)
                                                    .padding(.horizontal).padding(.top)
                                                    
                                                    // Remove icon at top-right
                                                    Button(action: {
                                                        viewModal.problemsByFamily[member] = nil
                                                        print("checking problem \(viewModal.familyProblems)")
                                                        print("Remove tapped")
                                                    }) {
                                                        Image(systemName: "xmark")
                                                            .foregroundColor(.red) // Red icon
                                                            .font(.system(size: 8, weight: .bold)) // Make it bold and closer to your screenshot
                                                            .padding(8) // Space inside the background
                                                            .background(
                                                                Circle()
                                                                    .fill(Color.red.opacity(0.1)) // Light red background
                                                            )
                                                    }.padding(4)


                                                }


                                            }
                                            
                                        }
                                        Spacer()
                                        
                                            .frame(height: 100)
                                        
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                }   .frame(height: 250)
                            }
                            .navigationBarHidden(viewModal.showCancelButton)
                            .resignKeyboardOnDragGesture()
                            //                        VStack(alignment: .leading){
                            //                            Text("Chronic Disease")
                            //                                .font(.system(size: 14))
                            //                                .foregroundColor(.black)
                            //
                            //                            HStack {
                            //                                Image(systemName: "magnifyingglass")
                            //
                            //                                TextField("Search", text: $viewModal.searchHealthHistoryText, onEditingChanged: { isEditing in
                            //                                    withAnimation {
                            ////                                        viewModal.showHealthHistoryPopup = true
                            //                                        viewModal.showHealthHistoryCancelButton = true
                            //                                    }
                            //                                })
                            //                                .foregroundColor(.primary)
                            //                                Button(action: {
                            //                                    withAnimation {
                            //                                        self.viewModal.searchHealthHistoryText = ""
                            //                                    }
                            //                                }) {
                            //                                    Image(systemName: "xmark.circle.fill")
                            //                                        //.opacity($searchHealthHistoryText.isEmpty ? 0 : 1)
                            //                                }
                            //                            }
                            //                            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                            //                            .foregroundColor(.secondary)
                            //                            .background(Color(.secondarySystemBackground))
                            //                            .cornerRadius(10.0)
                            //
                            //                            if !viewModal.filteredHealthHistoryResults.isEmpty {
                            //                                List(viewModal.filteredHealthHistoryResults, id: \.self) { result in
                            //                                    Button(action: {
                            //                                        viewModal.selectDiseases([result])
                            //                                        viewModal.showHealthHistoryPopup = true
                            //                                        viewModal.searchHealthHistoryText = ""
                            //                                    }) {
                            //                                        Text(result)
                            //                                    }
                            //
                            //                                }
                            //                                .transition(.opacity)
                            //                                .frame(height: 200)
                            //                                .listStyle(PlainListStyle())
                            //                                .padding(0)
                            //                                .scrollContentBackground(.hidden)
                            //                                .background(Color.white)
                            //                            }
                            //                            VStack(alignment: .leading, spacing: 10) {
                            //                                ForEach(viewModal.resultMap.keys.sorted(), id: \.self) { key in
                            //                                    if key != "clientId" && key != "isExternal" {
                            //                                        VStack(alignment: .leading, spacing: 4) {
                            //                                            Text(key)
                            //                                                .font(.headline)
                            //                                                .foregroundColor(.primary)
                            //
                            //                                            if let diseases = viewModal.resultMap[key] as? [String] {
                            //                                                ForEach(diseases, id: \.self) { disease in
                            //                                                    Text("- \(disease)")
                            //                                                        .font(.subheadline)
                            //                                                        .foregroundColor(.secondary)
                            //                                                }
                            //                                            }
                            //                                        }
                            //                                        .padding(.vertical, 4)
                            //                                    }
                            //                                }
                            //                            }
                            //
                            ////                            if !viewModal.selectedHealthHistoryItems.isEmpty {
                            ////                                VStack(alignment: .leading) {
                            ////
                            ////                                    ScrollView(.horizontal, showsIndicators: false) {
                            ////                                        HStack{
                            ////                                            ForEach(viewModal.selectedHealthHistoryItems, id: \.self) { item in
                            ////
                            ////                                                VStack {
                            ////                                                    Text("dddddd")
                            ////                                                    Text(item)
                            ////
                            ////                                                }.padding(.horizontal, 16)
                            ////                                                    .padding(.vertical, 8)
                            ////                                                    .background(Color.blue.opacity(0.2))
                            ////                                                    .foregroundColor(.blue)
                            ////                                                    .font(.system(size: 13))
                            ////                                                    .cornerRadius(20)
                            ////                                                    .overlay(
                            ////                                                        Circle()
                            ////                                                            .fill(Color.red.opacity(0.2))
                            ////                                                            .frame(width: 20, height: 20)
                            ////                                                            .overlay(
                            ////                                                                Image(systemName: "xmark")
                            ////                                                                    .resizable()
                            ////                                                                    .scaledToFit()
                            ////                                                                    .frame(width: 10, height: 10)
                            ////                                                                    .foregroundColor(Color.red)
                            ////                                                            )
                            ////                                                            .offset(x: 38, y: -10)
                            ////
                            ////                                                    )
                            ////                                                    .onTapGesture {
                            ////                                                        viewModal.selectedHealthHistoryItems.removeAll { $0 == item }
                            ////                                                    }
                            ////                                            }
                            ////                                        }
                            ////
                            ////                                    }
                            ////                                }
                            ////                                .transition(.slide)
                            ////                                .padding(.all)
                            ////                            }
                            //                        }
                            //                        .navigationBarHidden(viewModal.showHealthHistoryPopup)
                            //                        .resignKeyboardOnDragGesture()
                        }.padding(.horizontal,20)
                    }
                    
                    
                    
                }
                //.padding(.horizontal,20)
            
            


//            if viewModal.showHealthHistoryPopup {
//                Color.black.opacity(0.4)
//                    .edgesIgnoringSafeArea(.all)
//                    .onTapGesture {
//                        viewModal.showHealthHistoryPopup = false
//                    }
//
//                VStack {
//                    VStack(alignment: .leading,spacing: 20){
//                        Text("Select Relation")
//                            .font(.system(size: 16))
//                            .fontWeight(.semibold)
//                            .padding(.leading)
//                            .padding(.top,20)
//                        Text("Who in your family has been diagnosed with this disease?")
//                            .font(.system(size: 13))
//                            .padding(.leading)
//                        
//                        List(FamilyMember.allCases) { member in
//                            let isSelected = viewModal.tempSelectedHealthHistoryItems.contains(member.rawValue)
//                            
//                            HStack {
//                                Text(member.rawValue)
//                                Spacer()
//                                if isSelected {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                            .contentShape(Rectangle())
//                            .onTapGesture {
//                                if isSelected {
//                                    viewModal.tempSelectedHealthHistoryItems.remove(member.rawValue)
//                                } else {
//                                    viewModal.tempSelectedHealthHistoryItems.insert(member.rawValue)
//                                }
//                            }
//                        }
//                        .listStyle(PlainListStyle())
//
//                        
//                        Spacer()
//                    }
//                    
//                    Button("Done") {
////                        selectedItems = Array(tempSelectedItems)
//                        print("Selected Items: \(viewModal.tempSelectedHealthHistoryItems)")
//                        viewModal.assignSelectedProblemsToRelations()
//                            viewModal.showHealthHistoryPopup = false
//                        viewModal.printResultMapFamilyProblem()
//                        
//                    }
//                    
//                    .frame(maxWidth: 200)
//                    .frame(height: 40, alignment: Alignment.center)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    Spacer()
//                }
//                .frame(width: 300, height: 400)
//                .background(Color.white)
//                .cornerRadius(20)
//                .shadow(radius: 10)
//                .shadow(radius: 10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray, lineWidth: 1)
//                
//                )
//            }
   
    }
    
    func thankYouPage() -> some View {
        VStack {
            Spacer().frame(height : 20)
            Group() {
                Text("What's Next?")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.primaryBlue)
                    .fontWeight(.bold)

                Text("To help you maintain optimal health, we need a few more details")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 25)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)

            Button(action: {
                        print("Set preferences tapped")
                if(viewModal.currentPage == 11){
                    viewModal.currentPage += 1
                }
                    }) {
                        Text("Set preferences for a better experience")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.primaryBlue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }


    
    /// Vital Reminder Page
    
    func vitalReminderPage() -> some View {
        ZStack {
            VStack {
                GIFView(gifName: "setreminder")
                    .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Set Vital Reminder")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.primaryBlue)
                        .fontWeight(.bold)
                    
                    Text("Your primary details are uploaded. Please select the interval for your vital reminders.")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 25)
                    
                    ZStack {
                        vitalsListView
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 50)
            }
            .padding(.horizontal, 20)
            
            if viewModal.showPopupReminder {
                popupReminderView
            }
        }
    }

    private var vitalsListView: some View {
        ScrollView {
            ForEach(Array(viewModal.vitalsList.enumerated()), id: \.offset) { index, data in
                HStack {
                    VStack(alignment: .leading) {
                        Text(data["name"] as? String ?? "")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        Text(data["frequencyType"] as? String ?? "")
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
                    viewModal.selectedVitalIndex = index
                    viewModal.showPopupReminder = true
                }
            }
        }
    }


    private var popupReminderView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    viewModal.showPopupReminder = false
                }
            
            VStack {
                ScrollView {
                    ForEach(Array(viewModal.frequencyList.enumerated()), id: \.offset) { index, data in
                        let name = data["frequencyName"] as? String ?? ""
                        
                        HStack {
                            Text(name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image(systemName: viewModal.selectedSubName == name ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(viewModal.selectedSubName == name ? .green : .gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            viewModal.selectedSubName = name
                            
                            if let selectedIndex = viewModal.selectedVitalIndex {
                                viewModal.vitalsList[selectedIndex]["frequencyType"] = name
                                viewModal.vitalsList[selectedIndex]["isCheck"] = true
                            }
                            
                            viewModal.showPopupReminder = false
                            viewModal.selectedSubName = ""
                            print("viewModal.vitalsList : \(viewModal.vitalsList)")
                        }
                        
                        Divider()
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 30)
                
                Button("Done") {
                    viewModal.showPopupReminder = false
                }
                .frame(maxWidth: 200)
                .frame(height: 40, alignment: .center)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .frame(width: 300, height: 400)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }


    
    
    
    
    /// fluide intake details Page
    
    
    func fluidIntakeDetailsPage() -> some View {
        VStack{
     
        GIFView(gifName: "intakegif")
                    .padding()
                
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
                            text: $viewModal.fluidQuantity,
                            title: "Fluid Intake",
                            placeholder: "Enter your daily fluid intake",
                            onChange: { newValue in
                                print("Changed to: \(newValue)")
                                print(viewModal.fluidQuantity)
                                viewModal.fluidIntakeDetails["quantity"] = newValue
                                print(viewModal.fluidIntakeDetails)
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
                        Text("Litre")
                        
//                        VStack(alignment: .leading) {
//                            Spacer().frame(height: 15)
//                            
//                            Menu {
//                                ForEach(viewModal.fludeIntakeUnitOptions, id: \.self) { option in
//                                    Button(action: {
//                                        viewModal.selectedfluidIntakeUnit = option
//                                    }) {
//                                        Text(option)
//                                            .font(.title)
//                                    }
//                                }
//                            } label: {
//                                HStack(alignment: .center) {
//                                    Text(viewModal.selectedfluidIntakeUnit)
//                                        .font(.system(size: 18))
//                                        .foregroundColor(.secondary)
//                                    
//                                    Image(systemName: "chevron.down")
//                                        .foregroundColor(.secondary)
//                                        .frame(width: 16, height: 16)
//                                }
//                                .padding()
//                                .frame(height: 50)
//                                .background(Color.white)
//                                .cornerRadius(10)
//                            }
//                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }.padding(.horizontal,20)
                Spacer().frame(height: 50)
                
                
            }.padding(.horizontal,20)
        }
    
    ///profile summary
//    enum EditableField: String, Identifiable, CaseIterable {
//        case name = "Name"
//        case gender = "Gender"
//        case dateOfBirth = "Date of Birth"
//        case bloodGroup = "Blood Group"
//        case address = "Address"
//        case weight = "Weight"
//        case height = "Height"
//
//        var id: String { rawValue }
//    }
    func profileFieldView(
        title: String,
        value: String,
        emptyMessage: String = "No info is provided",
        isEditable: Bool = true,
        onEditTap: @escaping () -> Void
    ) -> some View {
        HStack(alignment: .top) {
            if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Image("checkMark")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
            }
            else{
                Image("checkMark")
            }


            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(emptyMessage)
                        .font(.caption)
                        .italic()
                        .foregroundColor(.red)

                } else {
                    Text(value)
                        .font(.body)
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if isEditable {
                Group {
                    if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Image("arrow_forward")
                            .resizable()
                            .frame(width: 20, height: 20)
                    } else {
                        Image("pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .onTapGesture {
                    print("🖊 Edit tapped for \(title)")
                    onEditTap()
                }
            }

        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }


    func editBottomSheetView(field: EditableField, onDismiss: @escaping () -> Void) -> some View {
        VStack(spacing: 20) {
            Text("Edit \(field.rawValue)")
                .font(.title2)
                .bold()

            switch field {
            case .name:
                firstPage(isEdit: true)
            case .gender:
                secondPages(isEdit: true)
            case .dateOfBirth:
                dobPage(isEdit: true)
            case .bloodGroup:
                bloodGroupPage(isEdit: true)
            case .address:
                locationPage(isEdit: true)
            case .weight:
                weightPage(isEdit: true)
            case .height:
                heightSelectionPage(isEdit: true)
            default:
                Text("Editing UI for \(field.rawValue)")
            }

            Button("Save") {
                onDismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)

            Spacer()
        }
        .padding()
        .presentationDetents([.height(300), .medium])
    }
    func ProfileSummaryPage() -> some View {
 
    
        ScrollView {
            profileFieldView(title: "Name", value: "\(viewModal.firstName) \(viewModal.lastNmae)",emptyMessage: "--No name provided.--") {
                viewModal.lastPage = 10
                viewModal.currentPage = 0
//                toggleField(.name)
            }
//            if viewModal.selectedProfileField == .name {
//                firstPage(isEdit: true)
//            }

            profileFieldView(title: "Gender", value: viewModal.selectedGender ?? "",emptyMessage: "--No gender provided.--") {
                viewModal.lastPage = 10
                viewModal.currentPage = 1
//                toggleField(.gender)
            }
//            if viewModal.selectedProfileField == .gender {
//                secondPages(isEdit: true)
//                    .frame(maxWidth: .infinity)
//            }

            profileFieldView(title: "Date of Birth", value: viewModal.formattedDate,emptyMessage: "--No DOB provided.--") {
                viewModal.lastPage = 10
                viewModal.currentPage = 2
//                toggleField(.dateOfBirth)
            }
//            if viewModal.selectedProfileField == .dateOfBirth {
//                dobPage(isEdit: true)
//            }

            profileFieldView(title: "Blood Group", value: viewModal.selectedBloodGroup ?? "",emptyMessage: "--No blood group provided.--") {
                viewModal.lastPage = 10
                viewModal.currentPage = 3
//                toggleField(.bloodGroup)
            }
//            if viewModal.selectedProfileField == .bloodGroup {
//                bloodGroupPage(isEdit: true)
//            }

            profileFieldView(title: "Address", value: viewModal.fullAddress,emptyMessage: "--No address provided.--") {
                viewModal.lastPage = 10
                viewModal.currentPage = 4
//                toggleField(.address)
            }
//            if viewModal.selectedProfileField == .address {
//                locationPage(isEdit: true)
//            }

            profileFieldView(title: "Weight", value: viewModal.weight,emptyMessage: "--No weight provided.--") {
                viewModal.lastPage = 10
                viewModal.currentPage = 5
//                toggleField(.weight)
            }
//            if viewModal.selectedProfileField == .weight {
//                weightPage(isEdit: true)
//            }

            profileFieldView(title: "Height", value: viewModal.selectedHeightText,emptyMessage: "--No height provided.--") {
                viewModal.lastPage = 10
                viewModal.currentPage = 6
//                toggleField(.height)
            }
            profileFieldView(title: "Chronic Condition", value: viewModal.chronicPreview,emptyMessage: "--No chronic condition provided.--") {
                viewModal.lastPage = 10
                viewModal.currentPage = 7
//                toggleField(.height)
            }
            profileFieldView(title: "Family's Health History", value: viewModal.familyProblemPreview,emptyMessage: "--No family health history provided.--") {
                viewModal.lastPage = 10
                viewModal.currentPage = 9
//                toggleField(.height)
            }
//            if viewModal.selectedProfileField == .height {
//                heightSelectionPage(isEdit: true)
//            }
        }
        .padding(.horizontal).onAppear(){
            viewModal.chronicPreview = viewModal.selectedItems.map { $0.problemName }
                                           .joined(separator: ", ")
            viewModal.generateAllProblemsText()
        }

        
    }
        
    
    func toggleField(_ field: EditableField) {
        viewModal.selectedProfileField =
            viewModal.selectedProfileField == field ? nil : field
    }

    func completionSuccessView() -> some View {
        VStack(spacing: 24) {
            // Main Card
            VStack(spacing: 16) {
                // Progress Bar with 100%
                HStack {
                    Text("\(Int((Double(viewModal.currentPage) / 14.0) * 100))%")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primaryBlue)
                    
                    ProgressView(value: Double(viewModal.currentPage) / 14.0)
                        .tint(.blue)
                        .frame(height: 10)
                        .animation(.easeInOut(duration: 1), value: viewModal.currentPage)
                }
                .padding(.horizontal)
                
                // Texts
                VStack(spacing: 4) {
                    Text("Thank you for your time and effort!")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("You’ve successfully completed the process!")
                        .font(.system(size: 16, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Text("Your submission is now complete, and we’re excited to have you on board.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal)
            
            // Conditionally show dots or done
            if (viewModal.showLoader) {
                LoadingDotsView()
                
                Text("Hold on, while we ready your dashboard for you.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
//                Button(action: {
//                            print("Set preferences tapped")
//                    viewModal.showLoader.toggle()
//                        }) {
//                            Text("Go to Dashboard")
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 48)
//                                .background(Color.primaryBlue)
//                                .cornerRadius(10)
//                        }
//                        .padding(.horizontal, 20)
            }
//            else if (viewModal.isSavingSuccessful){
//                Image(systemName: "checkmark.circle.fill")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .foregroundColor(.green)
//                
//                Text("Dashboard is ready!")
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.green)
//                Button(action: {
//                            print("Set preferences tapped")
//                    route.navigate(to: .dashboard)
//                        }) {
//                            Text("Go to Dashboard")
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 48)
//                                .background(Color.primaryBlue)
//                                .cornerRadius(10)
//                        }
//                        .padding(.horizontal, 20)
//            }
            if(!viewModal.showLoader && !viewModal.isSavingSuccessful && viewModal.showError){
                Text("Some error has been occurred").font(.caption)
                    .foregroundColor(.red)
                Button(action: {
                    Task {
                        await viewModal.submitPatientDetails(number: loginVM.uhidNumber)
//                        print("insideView \(success)")
//                        if success {
//                            print("inside if \(success)")
//                            route.navigate(to: .dashboard)
//                        } else {
//                            print("inside else \(success)")
//                        }
                    }
                        }) {
                            Text("Retry")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color.primaryBlue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.top, 50).onAppear(){
            Task {
                await viewModal.submitPatientDetails(number: loginVM.uhidNumber)
//                print("insideView \(success)")
//                if success {
//                    print("inside if \(success)")
//                    route.navigate(to: .dashboard)
//                } else {
//                    print("inside else \(success)")
//                }
            }
        }
    }
    struct LoadingDotsView: View {
        @State private var animate = false
        
        var body: some View {
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                        .opacity(animate ? 1.0 : 0.3)
                        .scaleEffect(animate ? 1.2 : 0.8)
                        .animation(
                            Animation
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: animate
                        )
                }
            }
            .onAppear {
                animate = true
            }
        }
    }





    
    
}

#Preview {
    CreateAccountView().environmentObject(SignUpViewModal())
}





import SwiftUI

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        self.gesture(
            DragGesture().onChanged { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                to: nil, from: nil, for: nil)
            }
        )
    }
}




// Getting Started
// Moving Forward
// Staying on Track
// One-Third Complete
// Almost There to Halfway
// Staying on Track
// Moving Ahead
// Final Stretch in Sight
// Just a Little Further to Go
// Final Push Ahead
// All Done!
//
//


struct KeyboardDismissView<Content: View>: View {
    let content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Color.clear
                    .contentShape(Rectangle()) // 🔑 allows tap detection
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }

                content() // ✅ interactive content goes above, not blocked
            }
        }
    }
}


import SwiftUI

struct EditProfile: View {
    
    @EnvironmentObject var editProfileVM: EditProfileViewModal
    
    @EnvironmentObject var viewModel: LoginViewModal

    @State private var saving = false
//    let bloodGroups = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
    
    @EnvironmentObject var themeManager: ThemeManager
       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }
   var userData =  UserDefaultsManager.shared.getEmployee()
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        ZStack{
            
            VStack(spacing: 0) {
                // ✅ Custom Back Button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(isDarkMode ? .white : .black)
                    }
                    
                    Text("Edit Profile")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isDarkMode ? .white : .black)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            do {
                                DispatchQueue.main.async {
                                    saving = true
                                }
                                try await editProfileVM.updateProfileData()
                                await viewModel.loadData(uhid: UserDefaultsManager.shared.getUHID() ?? "0")
                                DispatchQueue.main.async {
                                    saving = false
                                }
                            } catch {
                                print("Error occurred while updating:", error)
                            }
                        }
                    } label: {
                        if saving {
                            ProgressView()
                                .scaleEffect(0.7)
                        } else {
                            Text("Update & Save")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(editProfileVM.isFormValid ? Color.primaryBlue : Color.gray.opacity(0.5))
                        }
                    }
                    .disabled(!editProfileVM.isFormValid || saving)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(isDarkMode ? Color.black : Color.customBackground2)

                ScrollView {
                    //                HStack{
                    //                    Image("left").foregroundColor(.blue)
                    //                    CustomText("Edit Profile",color: Color.white, size: 18, weight: Font.Weight.bold)
                    //                    Spacer()
                    //                }
                    VStack(alignment: .leading, spacing: 15) {
                        //                    Text("First Name").foregroundColor( isDarkMode ? .white : .gray)
                        //                    CustomTextField(placeholder: "Enter your first name", text: $firstName, dark : isDarkMode)
                        CustomTextField1(
                            text: $editProfileVM.firstName,
                            title: " First Name",
                            placeholder: "Enter your first name",
                            onChange: { newValue in
                                print("Changed to: \(newValue)")
                            },
                            isDisabled: true
                        )
                        if let error = editProfileVM.firstNameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        CustomTextField1(
                            text: $editProfileVM.lastName,
                            title: " Last Name",
                            placeholder: "Enter your last name",
                            onChange: { newValue in
                                print("Changed to: \(newValue)")
                            }
                        )
                        //                    Text("Last Name").foregroundColor(isDarkMode ? .white : .gray)
                        //                    CustomTextField(placeholder: "Enter your last name", text: $lastName, dark : isDarkMode)
                        
                        //                    CustomTextField1(
                        //                        text: $editProfileVM.lastName,
                        //                        title: "Last Name",
                        //                        placeholder: "Enter your last name",
                        //                        onChange: { newValue in
                        //                            print("Changed to: \(newValue)")
                        //                        }
                        //                    )
                        
                        // DOB
                        //                    Text("\(editProfileVM.dob)")
                        Text("DOB")
                            .foregroundColor(isDarkMode ? .white : .gray)
                        
                        CustomDatePicker(
                            selectedDate: $editProfileVM.dob,
                            dark: isDarkMode,
                            onChange: { newDate in
                                print("Selected DOB: \(newDate)")
                                //                            editProfileVM.dob = newDate
                                //                            let formattedDOB = editProfileVM.formatDate(newDate)
                                //                            print(formattedDOB)
                            }
                        )
                        //                    .onAppear(){
                        //                        if !editProfileVM.formatDate(editProfileVM.dob).isEmpty {
                        //                                       Text("Selected DOB: \(editProfileVM.formatDate(editProfileVM.dob))")
                        //                                   } else {
                        //                                       Text("Select your date of birth")
                        //                                           .foregroundColor(.gray)
                        //                                   }
                        //                    }
                        
                        // Gender
                        Text("Gender").foregroundColor(isDarkMode ? .white : .gray)
                        // Radio buttons in horizontal row
                        HStack(spacing: 16) {
                            RadioButton(
                                title: "Male",
                                selected: $editProfileVM.gender,
                                dark: isDarkMode,
                                onSelect: {
                                    print("Selected gender: Male")
                                }
                            )
                            
                            RadioButton(
                                title: "Female",
                                selected: $editProfileVM.gender,
                                dark: isDarkMode,
                                onSelect: {
                                    print("Selected gender: Female")
                                }
                            )
                            
                            RadioButton(
                                title: "Other",
                                selected: $editProfileVM.gender,
                                dark: isDarkMode,
                                onSelect: {
                                    print("Selected gender: Other")
                                }
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer().frame(height: 0)
                        //                    CustomTextField1(
                        //                        text: $editProfileVM.weight,
                        //                        title: "Weight (kg)",
                        //                        placeholder: "Enter your weight in kilograms",
                        //                        onChange: { newValue in
                        //                            print("Changed to: \(newValue)")
                        //                        }
                        //                    )
                        
                        //                    DropdownMenu(
                        //                        title: "Blood Group",
                        //                        options: editProfileVM.bloodGroups,
                        //                        selectedOption: $editProfileVM.selectedBlood,
                        //                        onSelect: { group in
                        //                            editProfileVM.selectedBloodGroupID = group.id
                        //                            print("🩸 Selected Blood Group ID: \(group.id)")
                        //                        }
                        //                    )
                        //                    .onAppear {
                        //                        if let id = editProfileVM.selectedBloodGroupID {
                        //                            editProfileVM.selectedBlood = editProfileVM.bloodGroups.first { $0.id == id }
                        //                        }
                        //                    }
                        
                        //                    CustomTextField1(
                        //                        text: $editProfileVM.height,
                        //                        title: "Height (cm)",
                        //                        placeholder: "Enter your weight in kilograms",
                        //                        onChange: { newValue in
                        //                            print("Changed to: \(newValue)")
                        //                        }
                        //                    )
                        //
                        
                        
                        
                        
                        CustomTextField1(
                            text: $editProfileVM.emergencyContact,
                            title: "Mobile Number",
                            placeholder: "Enter contact number",
                            onChange: { newValue in
                                // Remove non-digit characters
                                let filtered = newValue.filter { $0.isNumber }
                                
                                // Limit to 10 digits
                                if filtered.count <= 10 {
                                    editProfileVM.emergencyContact = filtered
                                } else {
                                    editProfileVM.emergencyContact = String(filtered.prefix(10))
                                }
                                
                                print("Changed to: \(editProfileVM.emergencyContact)")
                            }
                        )

                        if let error = editProfileVM.emergencyContactError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        CustomTextField1(
                            text: $editProfileVM.email,
                            title: "Email",
                            placeholder: "Enter email",
                            onChange: { newValue in
                                editProfileVM.email = newValue
                                print("Changed to: \(newValue)")
                                
                                if editProfileVM.isEmailValid {
                                    print("✅ Valid Email!")
                                } else {
                                    print("❌ Invalid Email")
                                }
                            }
                        )
                        if !editProfileVM.isEmailValid && !editProfileVM.email.isEmpty {
                            Text("Please enter a valid email address.")
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        
                        Spacer()
                        
//                        Button(action: {
//                            Task {
//                                do {
//                                    DispatchQueue.main.async {
//                                        saving = true
//                                    }
//                                    try await editProfileVM.updateProfileData()
//                                    await viewModel.loadData(uhid: UserDefaultsManager.shared.getUHID() ?? "0")
//                                    DispatchQueue.main.async {
//                                        saving = false
//                                    }
//                                } catch {
//                                    print("Error occurred while updating:", error)
//                                }
//                                print("✅ Updated Patient Name: \(editProfileVM.firstName)")
//                                print("✅ Updated Patient Name: \(editProfileVM.gender)")
//                            }
//                        }) {
//                            if  !saving   {
//                                Text("Update Profile")
//                                    .frame(maxWidth: .infinity,maxHeight: 20)
//                                    .padding()
//                                    .foregroundColor(.white)
//                                    .background(Color.primaryBlue)
//                                .cornerRadius(14)}else{
//                                    ProgressView()
//                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                }
//                        }.onChange(of: editProfileVM.shouldDismissView) { shouldDismiss in
//                            if shouldDismiss {
//                                presentationMode.wrappedValue.dismiss()
//                            }
//                        }
                    }
                    .padding()
                }}

            .background( (isDarkMode ? Color.customBackgroundDark : Color.customBackground2).edgesIgnoringSafeArea(.all))
            .onAppear(){
                editProfileVM.loadUserData()
            }.onDisappear {
                editProfileVM.reset()
            }
            
            SuccessPopupView(show: $editProfileVM.updateProfile, message: "Profile updated")
                .zIndex(1)
            
        }
        .navigationBarHidden(true)
        }
}



struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var dark : Bool
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(dark ?(Color.gray.opacity(0.2)):Color.customBackground)
            .cornerRadius(8)
            .foregroundColor(dark ? .white : .black)
            .keyboardType(keyboardType)
    }
}
//
//struct CustomDatePicker: View {
//    @Binding var selectedDate: Date
//    var dark: Bool
//    var onChange: ((Date) -> Void)? = nil
//
//    var body: some View {
//        HStack {
//            DatePicker("", selection: $selectedDate, displayedComponents: .date)
//                .labelsHidden()
//                .datePickerStyle(CompactDatePickerStyle())
//                .onChange(of: selectedDate) { newDate in
//                    onChange?(newDate) // Trigger the callback
//                }
//
//            Image(systemName: "calendar")
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(dark ? Color.gray.opacity(0.2) : Color.white)
//        .cornerRadius(8)
//    }
//}

struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    var dark: Bool
    var onChange: ((Date) -> Void)? = nil

    @State private var showPicker = false
    @State private var hasSelectedDate = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    showPicker.toggle()
                }
            }) {
                HStack {
                    Text(formattedDate(selectedDate))
                        .foregroundColor(hasSelectedDate ? .black : .gray)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(dark ? Color.gray.opacity(0.2) : Color.white)
                .cornerRadius(8)
            }

            if showPicker {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: ...Date(), // 👈 Disable future dates
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .onChange(of: selectedDate) { newDate in
                    hasSelectedDate = true
                    onChange?(newDate)
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}




struct CustomPicker: View {
    @Binding var selection: String
    var options: [String]
    var placeholder: String
    
    @EnvironmentObject var themeManager: ThemeManager
       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selection = option
                }
            }
        } label: {
            HStack {
                Text(selection.isEmpty ? placeholder : selection)
                    .foregroundColor(selection.isEmpty ? .gray : .white)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(isDarkMode ? Color.customBackgroundDark2 : Color.white)
            .cornerRadius(8)
        }
    }
}

struct RadioButton: View {
    let title: String
    @Binding var selected: String
    var dark: Bool
    var onSelect: (() -> Void)? = nil

    var body: some View {
        HStack {
            Image(systemName: selected == title ? "largecircle.fill.circle" : "circle")
                .onTapGesture {
                    selected = title
                    onSelect?() // Call the callback when tapped
                }
                .foregroundColor(dark ? .white : .black)
            Text(title)
                .foregroundColor(.secondary)
        }
    }
}


struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
            .environmentObject(ThemeManager())
            .environmentObject(EditProfileViewModal())
    }
}

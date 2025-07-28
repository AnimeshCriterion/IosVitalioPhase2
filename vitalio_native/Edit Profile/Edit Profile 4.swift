
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
   var userData =  UserDefaultsManager.shared.getUserData()
    
    
    
    
    var body: some View {
        ZStack{
            
            
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
                        title: "Name",
                        placeholder: "Enter your first name",
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
                    
                    HStack {
                        Text("Gender:").foregroundColor(isDarkMode ? .white : .gray)
                        Spacer().frame(width: 30)
                        
                        RadioButton(
                            title: "Male",
                            selected: $editProfileVM.gender,
                            dark: isDarkMode,
                            onSelect: {
                                print("Selected gender: Male")
                            }
                        )
                        
                        Spacer().frame(width: 30)
                        
                        RadioButton(
                            title: "Female",
                            selected: $editProfileVM.gender,
                            dark: isDarkMode,
                            onSelect: {
                                print("Selected gender: Female")
                                // Add your logic here
                            }
                        )
                        
                        RadioButton(
                            title: "Other",
                            selected: $editProfileVM.gender,
                            dark: isDarkMode,
                            onSelect: {
                                print("Selected gender: Female")
                                // Add your logic here
                            }
                        )
                    }
                    
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
                    
                    HStack {
                        Text("+91")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                        
                        CustomTextField1(
                            text: $editProfileVM.emergencyContact,
                            title: "Emergency Contact Number",
                            placeholder: "Enter emergency contact number",
                            onChange: { newValue in
                                print("Changed to: \(newValue)")
                            }
                        )
                    }
                    Spacer()
                    
                    Button(action: {
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
                            print("✅ Updated Patient Name: \(editProfileVM.firstName)")
                            print("✅ Updated Patient Name: \(editProfileVM.gender)")
                        }
                        }) {
                        if  !saving   {
                            Text("Update Profile")
                                .frame(maxWidth: .infinity,maxHeight: 20)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.primaryBlue)
                            .cornerRadius(14)}else{
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .background( (isDarkMode ? Color.customBackgroundDark : Color.customBackground2).edgesIgnoringSafeArea(.all))
            .onAppear(){
                editProfileVM.loadUserData()
            }
            
            SuccessPopupView(show: $editProfileVM.updateProfile, message: "Profile updated")
                .zIndex(1)
            
        }
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

//                    Text(hasSelectedDate ? formattedDate(selectedDate) : "\(selectedDate)")
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
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
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
    }
}

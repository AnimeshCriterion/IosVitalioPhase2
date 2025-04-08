import SwiftUI

struct EditProfile: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dob: Date = Date()
    @State private var gender: String = "Male"
    @State private var weight: String = ""
    @State private var selectedBloodGroup: String = ""
    @State private var height: String = ""
    @State private var emergencyContact: String = ""

    let bloodGroups = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
    
    @EnvironmentObject var themeManager: ThemeManager
       var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }

    var body: some View {
        
            ScrollView {
                HStack{
                    Image("left").foregroundColor(.blue)
                    CustomText("Edit Profile",color: Color.white, size: 18, weight: Font.Weight.bold)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 15) {
                    Text("First Name").foregroundColor( isDarkMode ? .white : .gray)
                    CustomTextField(placeholder: "Enter your first name", text: $firstName, dark : isDarkMode)
                    Text("Last Name").foregroundColor(isDarkMode ? .white : .gray)
                    CustomTextField(placeholder: "Enter your last name", text: $lastName, dark : isDarkMode)
                    
                    // DOB
                    Text("DOB").foregroundColor(isDarkMode ? .white : .gray)
                    CustomDatePicker(selectedDate: $dob, dark: isDarkMode)
                    
                    // Gender
                    Text("Gender").foregroundColor(isDarkMode ? .white : .gray)
                    HStack {
                        RadioButton(title: "Male", selected: $gender, dark: isDarkMode)
                        RadioButton(title: "Female", selected: $gender, dark: isDarkMode)
                    }
                    
                    // Weight
                    Text("Weight (kg)").foregroundColor(isDarkMode ? .white : .gray)
                    CustomTextField(placeholder: "Enter your weight in kilograms", text: $weight, keyboardType: .decimalPad, dark : isDarkMode)
                    
                    // Blood Group
                    Text("Blood Group").foregroundColor(isDarkMode ? .white : .gray)
                    CustomPicker(selection: $selectedBloodGroup, options: bloodGroups, placeholder: "Select blood group")
                    
                    // Height
                    Text("Height (cm)").foregroundColor(isDarkMode ? .white : .gray)
                    CustomTextField(placeholder: "Enter your height in centimetres", text: $height, keyboardType: .decimalPad, dark : isDarkMode)
                    
                    // Emergency Contact
                    Text("Emergency Contact Number").foregroundColor(isDarkMode ? .white : .gray)
                    HStack {
                        Text("+91")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                        CustomTextField(placeholder: "Enter emergency contact number", text: $emergencyContact, keyboardType: .numberPad, dark : isDarkMode)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .background( (isDarkMode ? Color.customBackgroundDark : Color.customBackground2).edgesIgnoringSafeArea(.all))
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

struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    var dark : Bool
    
    var body: some View {
        HStack {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .labelsHidden()
                .datePickerStyle(CompactDatePickerStyle())
            Image(systemName: "calendar")
                .foregroundColor(.gray)
        }
        .padding()
        .background(dark ? (Color.gray.opacity(0.2)) : Color.white )
        .cornerRadius(8)
    }
}

struct CustomPicker: View {
    @Binding var selection: String
    var options: [String]
    var placeholder: String

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
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

struct RadioButton: View {
    let title: String
    @Binding var selected: String
    var dark : Bool
    
    var body: some View {
        HStack {
            Image(systemName: selected == title ? "largecircle.fill.circle" : "circle")
                .onTapGesture {
                    selected = title
                }.foregroundColor(dark ? .white :.black)
            Text(title).foregroundColor(.white)
        }
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
            .environmentObject(ThemeManager())
    }
}

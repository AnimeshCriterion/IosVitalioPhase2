//import SwiftUI
//
//struct ProfileField: View {
//    let title: String
//    let value: String
//    let isEditable: Bool
//    let onEditTap: () -> Void
//
//    var body: some View {
//        HStack {
//            Image(systemName: "checkmark.circle")
//                .foregroundColor(.blue)
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text(title)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text(value)
//                    .font(.body)
//                    .foregroundColor(.black)
//            }
//
//            Spacer()
//
//            if isEditable {
//                Image(systemName: "pencil")
//                    .foregroundColor(.gray)
//                    .onTapGesture {
//                        onEditTap()
//                    }
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
//    }
//}
//
//
//struct ProfileSummaryView: View {
//    @Binding var selectedField: EditableField?
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                VStack(spacing: 16) {
//                    ProfileField(title: "Name", value: "Abhinav Sharma", isEditable: true) {
//                        selectedField = .name
//                    }
//                    ProfileField(title: "Gender", value: "Male", isEditable: true) {
//                        selectedField = .gender
//                    }
//                    ProfileField(title: "Date of Birth", value: "17, September 1987 (37 Years)", isEditable: true) {
//                        selectedField = .dateOfBirth
//                    }
//                    ProfileField(title: "Blood Group", value: "AB+", isEditable: true) {
//                        selectedField = .bloodGroup
//                    }
//                    ProfileField(title: "Address", value: "655/79, Sarfarazganj, Lucknow,\nUttar Pradesh, India-226101", isEditable: true) {
//                        selectedField = .address
//                    }
//                    ProfileField(title: "Weight", value: "56.3 Kg", isEditable: true) {
//                        selectedField = .weight
//                    }
//                    ProfileField(title: "Height", value: "5.7 ft", isEditable: true) {
//                        selectedField = .height
//                    }
//                    ProfileField(title: "Chronic Conditions", value: "", isEditable: false) { }
//                }
//                .padding()
//            }
//
//            
//        }
//        .sheet(item: $selectedField) { field in
//            EditBottomSheetView(field: field) {
//                selectedField = nil
//            }
//        }
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}
//
//
//struct EditBottomSheetView: View {
//    let field: EditableField
//    let onDismiss: () -> Void
//    @State private var inputText: String = ""
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Edit \(field.rawValue)")
//                .font(.title2)
//                .bold()
//
//            switch field {
//            case .name:
//                TextField("Enter name", text: $inputText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//            default:
//                Text("Editing UI for \(field.rawValue)")
//            }
//
//            Button("Save") {
//                onDismiss()
//            }
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(12)
//
//            Spacer()
//        }
//        .padding()
//        .presentationDetents([.height(300), .medium])
//    }
//}
//
//
//
//
//enum EditableField: String, Identifiable, CaseIterable {
//    case name = "Name"
//    case gender = "Gender"
//    case dateOfBirth = "Date of Birth"
//    case bloodGroup = "Blood Group"
//    case address = "Address"
//    case weight = "Weight"
//    case height = "Height"
//
//    var id: String { rawValue }
//}


//struct ProfileSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSummaryView()
//    }
//}

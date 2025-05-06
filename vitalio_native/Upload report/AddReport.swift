import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct AddLabReportView: View {
    @EnvironmentObject var route: Routing
    @EnvironmentObject var dark: ThemeManager
    @EnvironmentObject var viewModel: UploadReportViewModel

    @State private var testType = ""
    @State private var date = Date()
    @State private var testName = ""
    @State private var findings = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var documentURL: URL?
    @State private var showingDocumentPicker = false

    var isDarkMode: Bool {
        dark.colorScheme == .dark
    }

    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    CustomNavBarView(title: "Add Lab Report", isDarkMode: isDarkMode) {
                        route.back()
                    }

                    // Test Type
                    Text("Test Type")
                        .font(.headline)
                        .foregroundColor(isDarkMode ? .white : .black)
                    HStack {
                        Picker("Select", selection: $testType) {
                            Text("Select").tag("")
                            Text("Radiology").tag("Radiology")
                            Text("Imaging").tag("Imaging")
                            Text("Lab").tag("Lab")
                        }
                        .pickerStyle(.menu)
                        Spacer() // pushes the picker content to the leading edge
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)



                    // Date Picker
                    Text("Date")
                        .font(.headline)
                        .foregroundColor(isDarkMode ? .white : .black)
                    HStack {

                        DatePicker("", selection: $date, displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                            .background(Color.clear) // prevent white box
//                            .tint(.clear) // remove system tint
                        Spacer()
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)



                    // Test Name
                    Text("Test Name")
                        .font(.headline)
                        .foregroundColor(isDarkMode ? .white : .black)
                    TextField("Enter", text: $testName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    // Camera and Gallery Buttons
                    HStack(spacing: 16) {
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            VStack {
                                Image(systemName: "camera")
                                    .font(.title)
                                Text("Camera")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(12)
                        }
                      Spacer()
                        Button(action: {
                            showingDocumentPicker.toggle()
                        }) {
                            VStack {
                                Image(systemName: "photo")
                                    .font(.title)
                                Text("Gallery")
                                    .font(.caption)
                                    .foregroundColor(.teal)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .fileImporter(
                            isPresented: $showingDocumentPicker,
                            allowedContentTypes: [.pdf, .image],
                            allowsMultipleSelection: false
                        ) { result in
                            do {
                                documentURL = try result.get().first
                                print("Selected from gallery: \(String(describing: documentURL))")
                            } catch {
                                print("Failed to pick document: \(error)")
                            }
                        }
                    }

                    // Show Selected File
                    if let doc = documentURL {
                        HStack {
                            Text(doc.lastPathComponent)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                            Button(action: {
                                documentURL = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }

                    // Upload Button
                    Button(action: {
                        print("Upload tapped")
                        if let fileURL = documentURL {
                            print("Uploading file from: \(fileURL.path)")
                            Task {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                let formattedDate = formatter.string(from: date) // `date` is the Date object from your DatePicker

                                viewModel.uploadFile(src: fileURL.path)
                                viewModel.saveFormDataWithQuery(
                                    src: fileURL.path,
                                    subCategory: testType,
                                    remark: testName,
                                    category: testType,
                                    dateTime: formattedDate
                                )
                                route.navigate(to: .dynamicResponseView)
                            }
                        } else {
                            print("documentURL is nil")
                        }
                    }) {
                        if  viewModel.uploadingFile ==  true{
                            ProgressView()
                        }else{
                            Text(    "Upload & Save")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                    Spacer()

                }
                .padding()
                .onChange(of: selectedImage) { newItem in
                    Task {
                        await loadImageFromPicker()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    func loadImageFromPicker() async {
        guard let item = selectedImage else {
            print("No item selected")
            return
        }

        do {
            print("Trying to load image...")
            if let data = try await item.loadTransferable(type: Data.self) {
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString + ".jpg")
                try data.write(to: tempURL)
                self.documentURL = tempURL
                print("Saved image to: \(tempURL)")
            } else {
                print("Failed to load data from image picker.")
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
    
    
    
    
 

  

}

#Preview {
    AddLabReportView()
}

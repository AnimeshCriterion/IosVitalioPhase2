////
////  ImagePicker.swift
////  vitalio_native
////
////  Created by Mohd Faheem on 4/30/25.
////
//
//import SwiftUI
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Binding var imageFilename: String? // ✅ Add this
//    var sourceType: UIImagePickerController.SourceType
//    @Environment(\.presentationMode) private var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = sourceType
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.selectedImage = image
//            }
////
////            if let url = info[.imageURL] as? URL {
////                parent.imageFilename = url.path  // ✅ Fix here
////                print("Selected image file path: \(url.path)")
////            }
//            
//            if let image = info[.originalImage] as? UIImage {
//                parent.selectedImage = image
//
//                // Save to temporary directory to generate a file path
//                if let data = image.jpegData(compressionQuality: 1.0) {
//                    let filename = UUID().uuidString + ".jpg"
//                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
//                    do {
//                        try data.write(to: tempURL)
//                        parent.imageFilename = tempURL.path
//                        print("📸 Image saved to temp: \(tempURL.path)")
//                    } catch {
//                        print("❌ Failed to save image: \(error)")
//                    }
//                }
//            }
//
//
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//}


import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var imageFilename: String?
    var sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            // Get image
            guard let image = info[.originalImage] as? UIImage else {
                print("❌ No image selected")
                parent.presentationMode.wrappedValue.dismiss()
                return
            }

            parent.selectedImage = image

            // If from photo library and URL is available
            if let url = info[.imageURL] as? URL {
                parent.imageFilename = url.path
                print("✅ Image URL from library: \(url.path)")
            } else {
                // For camera: Save to temp folder
                if let data = image.jpegData(compressionQuality: 0.9) {
                    let filename = UUID().uuidString + ".jpg"
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                    do {
                        try data.write(to: tempURL)
                        parent.imageFilename = tempURL.path
                        print("✅ Image saved to temp path: \(tempURL.path)")
                    } catch {
                        print("❌ Failed to save image to temp path: \(error)")
                        parent.imageFilename = nil
                    }
                } else {
                    print("❌ Failed to convert image to JPEG")
                    parent.imageFilename = nil
                }
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

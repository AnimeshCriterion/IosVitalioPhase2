//
//  Feedback.swift
//  vitalio_native
//
//  Created by HID-18 on 29/03/25.
//

import SwiftUI

struct Feedback: View {

    
    @EnvironmentObject var route: Routing
    @EnvironmentObject var theme: ThemeManager
    
    var dark
        : Bool {
            theme.colorScheme == .dark
        }
    

    
    
    var body: some View {
        VStack(alignment: .leading){
            CustomNavBarView(title: "Feedback" , isDarkMode: dark) {
                route.back()
            }
            FeedbackFormView(dark: dark)
            Spacer()
            .navigationBarHidden(true)
        }  .background(dark ? Color.customBackgroundDark : Color.customBackground)
    }
    
}
#Preview {
    Feedback()
        .environmentObject(ThemeManager())
}



struct FeedbackFormView: View {
    var dark : Bool
    @State private var email: String = ""
    @State private var selectedRating: Int? = nil
    @State private var selectedModule: String = "Select Module"
    @State private var feedback: String = ""

    let ratings = ["😠", "☹️", "😐", "😊", "😎"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Email Input
            Text("Your Email Id*")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(dark ? .white :.black)

            TextField("Enter Email", text: $email)
                .padding()
                .foregroundColor(dark ? .white :.black)
                .background(dark ? Color.customBackgroundDark2 : . white)
                .cornerRadius(8)
            
            // Rating Section
            Text("Your Rating*")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(dark ? .white :.black)

            HStack(spacing: 12) {
                ForEach(0..<ratings.count, id: \.self) { index in
                    Text(ratings[index])
                        .font(.system(size: 28))
                        .frame(width: 50, height: 50)
                        .background(selectedRating == index ? Color.primaryBlue :(dark ? Color.customBackgroundDark2 : Color.white))
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedRating = index
                        }
                }
            }

            // Module Selection (Dropdown)
            Text("What Can We Improve")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(dark ? .white :.black)

            Menu {
                Button("App Performance") { selectedModule = "App Performance" }
                Button("User Interface") { selectedModule = "User Interface" }
                Button("Features") { selectedModule = "Features" }
            } label: {
                HStack {
                    Text(selectedModule)
                        .foregroundColor(selectedModule == "Select Module" ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(dark ? .white :.black)
                }
                .padding()
                .background(dark ? Color.customBackgroundDark2 : Color.white)
                .cornerRadius(8)
            }

            Text("Your Feedback*")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(dark ? .white :.black)

            MultilineTextEditor(
                  text: $feedback,
                  textColor: dark == true ? .white : .black,
                  backgroundColor:  dark == true ? UIColor(Color.customBackgroundDark2) : .white
              )
              .frame(height: 100)
              .cornerRadius(8)
              .overlay(
                  RoundedRectangle(cornerRadius: 8)
                      .stroke(Color.gray.opacity(0.3), lineWidth: 1)
              )
            CustomButton(title: "Submit") {
                           print("Button Tapped")
                       }
        }
        .background(dark ? Color.customBackgroundDark : Color.customBackground)
        .padding()
        .cornerRadius(10)
    }
    
}

//struct FeedbackFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedbackFormView(dark: <#T##Bool#>)
//    }
//}




struct MultilineTextEditor: UIViewRepresentable {
    @Binding var text: String
    var textColor: UIColor = .black
    var backgroundColor: UIColor = .white

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isScrollEnabled = true
        textView.backgroundColor = backgroundColor
        textView.textColor = textColor
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.textColor = textColor
        uiView.backgroundColor = backgroundColor
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextEditor

        init(_ parent: MultilineTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}


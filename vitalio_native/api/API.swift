//
//  API.swift
//  vitalio_native
//
//  Created by HID-18 on 25/03/25.
//

import SwiftUI
import Foundation

// MARK: - Model
struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

// MARK: - ViewModel
class APIViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
    
    func fetchPosts() {
        isLoading = true
        Task {
            do {
                let url = "https://jsonplaceholder.typicode.com/posts"
                let fetchedPosts: [Post] = try await APIService.shared.fetchData(fromURL: url)
                
                DispatchQueue.main.async {
                    self.posts = fetchedPosts
                    self.isLoading = false
                }
            } catch let error as NetworkError {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "An unknown error occurred"
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    func post(){
        Task {
            do {
                let newPost = NewPost(title: "SwiftUI MVVM", body: "This is a test post.", userId: 1)
                let response: Post = try await APIService.shared.postData(toURL: "https://jsonplaceholder.typicode.com/posts", body: newPost)
                print("Created Post:", response)
            } catch {
                self.showError = true
                print("Error:", error.localizedDescription)
            }
        }
    }
}


/// DUMMY DATA MODAL

struct NewPost: Codable {
    let title: String
    let body: String
    let userId: Int
}


struct APIView: View {
    @StateObject private var viewModel = APIViewModel()

    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...").padding()
                }
                Button("post"){
                    viewModel.post()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Fetch Posts") {
                    viewModel.fetchPosts()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                List(viewModel.posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title).font(.headline)
                        Text(post.body).font(.subheadline)
                    }
                }
            }


            if viewModel.showError {
                CustomAlertView(
                    message: viewModel.errorMessage ?? "An unknown error occurred"
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.showError)
    }
}






// MARK: - Preview
#Preview {
    APIView()
}

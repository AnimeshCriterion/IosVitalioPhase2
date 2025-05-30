//
//  API.swift
//  vitalio_native
//
//  Created by HID-18 on 25/03/25.
//

import SwiftUI
import Foundation


class APIViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
    
    

    
    
    func fetchPosts() {
        isLoading = true
        Task {
            do {
                let params = ["mobileNo": "", "uhid": "UHID01235"]
                let url = "https://jsonplaceholder.typicode.com/posts"
                let fetchedPosts: [Post] = try await APIService.shared.fetchData(fromURL: url, parameters: params)
                
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


struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}




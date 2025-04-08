//
//  DummyView.swift
//  vitalio_native
//
//  Created by HID-18 on 25/03/25.
//

import SwiftUI


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
                    print("Fetch Posts")
                    viewModel.fetchPosts()
//                    Task{
//                        await viewModel.loadData()
//                    }
        
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



#Preview {
    APIView()
}

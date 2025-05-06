//
//  CustomeLoader.swift
//  vitalio_native
//
//  Created by Mohd Faheem on 4/25/25.
//

import Foundation

import SwiftUI
import Combine

class LoaderManager: ObservableObject {
    @Published var isLoading: Bool = false

    func start() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }

    func stop() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}



struct CustomLoader: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }
}


struct LoaderView: View {
    let text: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            ProgressView(text)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
                .foregroundColor(.white)
        }
    }
}

//
//  ShowImage.swift
//  vitalio_native
//
//  Created by HID-18 on 14/05/25.
//

import SwiftUI
import SwiftUI

struct RemoteImage: View {
    @StateObject private var loader: ImageLoader
    var placeholder: Image
    var failure: Image

    init(url: String?, placeholder: Image = Image(systemName: "person.crop.circle"), failure: Image = Image(systemName: "person.crop.circle.badge.exclamationmark")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
        self.failure = failure
    }

    var body: some View {
        content
            .resizable()
            .scaledToFill()
    }

    private var content: Image {
        switch loader.state {
        case .loading:
            return placeholder
        case .failure:
            return failure
        case .success(let uiImage):
            return Image(uiImage: uiImage)
        }
    }
}
import Combine
import SwiftUI

class ImageLoader: ObservableObject {
    enum LoadState {
        case loading, success(UIImage), failure
    }

    @Published var state = LoadState.loading

    init(url: String?) {
        guard let urlString = url?.replacingOccurrences(of: "\\", with: "/"),
              let imageURL = URL(string: urlString) else {
            self.state = .failure
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.state = .success(image)
                } else {
                    self.state = .failure
                }
            }
        }.resume()
    }
}

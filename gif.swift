//
//  gif.swift
//  vitalio_native
//
//  Created by HID-18 on 11/06/25.
//

import SwiftUI
import UIKit
import WebKit

struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let gifData = try? Data(contentsOf: URL(fileURLWithPath: path))
            webView.load(gifData ?? Data(), mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: path))
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Nothing to update
    }
}

//
//#Preview {
//    GIFView(gifName: "calandergif")
//}

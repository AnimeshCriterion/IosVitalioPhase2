//
//  Modal.swift
//  vitalio_native
//
//  Created by HID-18 on 25/03/25.
//

import SwiftUI


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


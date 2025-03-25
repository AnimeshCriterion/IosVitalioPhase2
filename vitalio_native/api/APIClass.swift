//
//  APIClass.swift
//  vitalio_native
//
//  Created by HID-18 on 25/03/25.
//

import SwiftUI

class APIService {
    static let shared = APIService()
    private init() {}
    func fetchData<T: Codable>(fromURL: String) async throws -> T {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 10

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.badStatus(httpResponse.statusCode)
            }

            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.failedToDecodeResponse
            }

            return decodedResponse

        } catch is URLError {
            throw NetworkError.timeout
        } catch {
            throw NetworkError.unknownError(error.localizedDescription)
        }
    }

    /// Generic function to send data using POST request
    func postData<T: Codable, U: Codable>(toURL: String, body: T) async throws -> U {
        do {
            guard let url = URL(string: toURL) else { throw NetworkError.badUrl }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.badStatus(httpResponse.statusCode)
            }

            guard let decodedResponse = try? JSONDecoder().decode(U.self, from: data) else {
                throw NetworkError.failedToDecodeResponse
            }
            print(decodedResponse)

            return decodedResponse

        } catch is URLError {
            throw NetworkError.timeout
        } catch {
            throw NetworkError.unknownError(error.localizedDescription)
        }
    }
}

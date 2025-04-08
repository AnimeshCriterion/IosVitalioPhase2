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
    
    func fetchRawData(fromURL: String, parameters: [String: String]) async throws -> [String: Any] {
        // Convert parameters to query string
        var urlComponents = URLComponents(string: fromURL)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents?.url else { throw NetworkError.badUrl }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code:", httpResponse.statusCode)
            print("Response Headers:", httpResponse.self)
        }

        let responseString = String(data: data, encoding: .utf8) ?? "Invalid Response"
        print("Response Body:", responseString)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse
        }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NetworkError.failedToDecodeResponse
        }

        return json
    }
    
    func fetchData<T: Codable>(fromURL: String, parameters: [String: Any]) async throws -> T {
        guard var urlComponents = URLComponents(string: fromURL)
                
        else {
            throw NetworkError.badUrl
        }

        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
        
        guard let url = urlComponents.url else { throw NetworkError.badUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse
        }

        return try JSONDecoder().decode(T.self, from: data)
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

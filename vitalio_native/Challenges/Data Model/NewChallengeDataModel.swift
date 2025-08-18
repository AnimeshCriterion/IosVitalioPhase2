//
//  JoinedDataModel.swift
//  vitalio_native
//
//  Created by HID-18 on 09/08/25.
//

import Foundation


struct ChallengeResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [Challenge]
}

struct Challenge: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let rewardPoints: Int
    let clientId: Int
    let startsIn: String
    let peopleJoined: [Person]?

    enum CodingKeys: String, CodingKey {
        case id, title, description, rewardPoints, clientId, startsIn, peopleJoined
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        rewardPoints = try container.decode(Int.self, forKey: .rewardPoints)
        clientId = try container.decode(Int.self, forKey: .clientId)
        startsIn = try container.decode(String.self, forKey: .startsIn)

        if let peopleArray = try? container.decode([Person].self, forKey: .peopleJoined) {
            // API gave us a real array
            peopleJoined = peopleArray
        } else if let peopleString = try? container.decode(String.self, forKey: .peopleJoined),
                  let data = peopleString.data(using: .utf8),
                  let people = try? JSONDecoder().decode([Person].self, from: data) {
            // API gave us a string containing JSON
            peopleJoined = people
        } else {
            peopleJoined = []
        }

    }
}

struct Person: Codable, Identifiable, CustomStringConvertible {
    var id: String { empId }
    let empId: String
    let employeeName: String
    let imageURL: String
    
    var description: String { employeeName }
}

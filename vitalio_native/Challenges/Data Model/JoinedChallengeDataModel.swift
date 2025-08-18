//
//  DataModel.swift
//  watchAooForTestingPurpose
//
//  Created by HID-18 on 24/07/25.
//



import Foundation



struct ChallengeModelResponse: Codable {
    let status: Int
    let message: String
    let responseValue: [ChallengeModel]
}

struct ChallengeModel: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let rewardPoints: Int
    let clientId: Int
    let joinedDate: String
    let startsIn: String
    let peopleJoined: [EmployeeModel]

    // Custom decoding because `peopleJoined` is a JSON String
    private enum CodingKeys: String, CodingKey {
        case id, title, description, rewardPoints, clientId, joinedDate, startsIn, peopleJoined
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        rewardPoints = try container.decode(Int.self, forKey: .rewardPoints)
        clientId = try container.decode(Int.self, forKey: .clientId)
        joinedDate = try container.decode(String.self, forKey: .joinedDate)
        startsIn = try container.decode(String.self, forKey: .startsIn)

        let peopleString = try container.decode(String.self, forKey: .peopleJoined)
        let peopleData = Data(peopleString.utf8)
        peopleJoined = try JSONDecoder().decode([EmployeeModel].self, from: peopleData)
    }
}

struct EmployeeModel: Codable, Identifiable {
    var id: String { empId }
    let empId: String
    let employeeName: String
    let imageURL: String
}

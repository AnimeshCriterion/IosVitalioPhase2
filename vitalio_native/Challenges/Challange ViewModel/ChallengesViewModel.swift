//
//  ChallengesViewModel.swift
//  watchAooForTestingPurpose
//
//  Created by HID-18 on 24/07/25.
//Ba

import Foundation
import SwiftUI



class ChallengesviewModel :  ObservableObject {
    @Published var challenges: [Challenge] = []
    @Published var JoinedChallenge: Bool = true
    @Published var selectedChallenge: Challenge? = nil // <-- store clicked challenge
 
    
    @Published var title : String = ""
    @Published var description : String = ""
    @Published var startsIn : String = ""
    @Published var color : Color = .blue

    func getChallenges() async {
        let url = "http://182.156.200.177:5082/api/CorporateChallenges/GetCorporateChallengesByClientId"
        let parameters = ["clientId": "194"]

        do {
            let data = try await APIService.shared.fetchRawData(fromURL: url, parameters: parameters)
    

            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let decoded = try JSONDecoder().decode(ChallengeResponse.self, from: jsonData)

            DispatchQueue.main.async {
                self.challenges = decoded.responseValue
                print("okokokok \(self.challenges)  okokokok")
            }
            DispatchQueue.main.async {
                self.challenges = decoded.responseValue

                for challenge in self.challenges {
                    print("🏁 Challenge ID: \(challenge.id)")
                    print("📌 Title: \(challenge.title)")
                    print("📝 Description: \(challenge.description)")
                    print("🎁 Reward Points: \(challenge.rewardPoints)")
                    print("🏢 Client ID: \(challenge.clientId)")
                    print("⏳ Starts In: \(challenge.startsIn)")

                    if let people = challenge.peopleJoined {
                        print("👥 People Joined: \(people.count)")
                        for person in people {
                            print("  👤 \(person.employeeName) (ID: \(person.empId)), Image URL: \(person.imageURL)")
                        }
                    } else {
                        print("👥 People Joined: None")
                    }

                    print("-------------------------")
                }
            }

            // Try extracting expected values (example)
            if let challenges = data["challenges"] {
                print("Fetched challenges: \(challenges)")
            } else {
                print("Data fetched but 'challenges' key not found:", data)
            }
        } catch NetworkError.badUrl {
            print("❌ Invalid URL. Please check the URL string.")
        } catch NetworkError.badResponse {
            print("❌ Bad HTTP response from server. Possibly 4xx or 5xx.")
        } catch NetworkError.failedToDecodeResponse {
            print("❌ Failed to decode JSON. Response might not be a valid dictionary.")
        } catch {
            print("❌ Unknown error occurred:", error.localizedDescription)
        }
    }
    
    @Published var joinedChallenges: [ChallengeModel] = []


       func getJoinedChallenges() async {
       
           let urlString = "http://182.156.200.177:5082/api/CorporateChallenges/GetJoinedChallengesByEmployeeId"
           let parameters = ["clientId": "194", "pid": "80"]

           do {
               let rawData = try await APIService.shared.fetchRawData(fromURL: urlString, parameters: parameters)

               let jsonData = try JSONSerialization.data(withJSONObject: rawData, options: [])
               let decoded = try JSONDecoder().decode(ChallengeModelResponse.self, from: jsonData)

               self.joinedChallenges = decoded.responseValue

               print("✅ Challenges fetched:")
               for challenge in joinedChallenges {
                   print("🔹 \(challenge.title), starts in: \(challenge.startsIn)  ")
               }
           } catch {
               print("❌ Failed to load challenges:", error.localizedDescription)
           }
       }
    
    
    
    func join(challengeId: String) async{
        let userData =  UserDefaultsManager.shared.getEmployee()
        let pid = "\(userData?.id ?? 0)"
        
        
        
        
        let url = "http://182.156.200.177:5082/api/Challengeparticipants/InsertChallengeparticipants"
        let parameters = ["challengeId": challengeId ,"pid": pid,"clientId":"194","userId":"60"]
        print(parameters)
        do {
            let data = try await APIService.shared.postRawData(toURL: url, body: parameters)
            print(data)
        }catch{
  
        }
       await getJoinedChallenges()
       await getChallenges()
        
    }
    
    
    
    

    
    

    func leaveChallenge(challengeId: Int?) async{
        
            let userData =  UserDefaultsManager.shared.getEmployee()
        let pid = "\(userData?.id ?? 0)"
        
        guard let url = URL(string: "http://182.156.200.177:5082/api/Challengeparticipants/LeaveChallengeparticipants?pid=\(pid)&challengeId=\(challengeId ?? 0)") else {
            print("❌ Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ API Error:", error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                return
            }
            
            print("📡 Status Code:", httpResponse.statusCode)
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("✅ Response:", responseString)
            } else {
                print("⚠️ No response data")
            }
        }.resume()
        await getJoinedChallenges()
        await getChallenges()
    }



}

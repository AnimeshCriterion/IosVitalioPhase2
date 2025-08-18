import SwiftUI

struct SleepTrackerCardView: View {
    // MARK: - JSON Structs

    struct SleepGraphEntry: Codable {
        let start: Int
        let end: Int
        let type: String
    }

    struct QuickMetric: Codable {
        let title: String
        let display_text: String
        let value: Int
        let type: String
    }

    struct SleepDetails: Codable {
        let quick_metrics: [QuickMetric]
        let sleep_graph: SleepGraph
    }

    struct SleepGraph: Codable {
        let title: String
        let data: [SleepGraphEntry]
    }

    struct SleepObject: Codable {
        let title: String
        let details: SleepDetails
    }

    struct MetricItem: Codable {
        let type: String
        let object: SleepObject
    }

    struct RootData: Codable {
        let metric_data: [MetricItem]
    }

    struct Root: Codable {
        let data: RootData
    }

    // MARK: - JSON String
    let json = """
    {
      "data": {
        "metric_data": [
          {
            "type": "sleep",
            "object": {
              "title": "Sleep Tracker",
              "details": {
                "quick_metrics": [
                  {
                    "title": "Total Sleep",
                    "display_text": "06h 45m",
                    "value": 24300,
                    "type": "total_sleep"
                  }
                ],
                "sleep_graph": {
                  "title": "Sleep Stages",
                  "data": [
                    { "start": 0, "end": 1800, "type": "awake" },
                    { "start": 1800, "end": 7200, "type": "light_sleep" },
                    { "start": 7200, "end": 12600, "type": "deep_sleep" },
                    { "start": 12600, "end": 18000, "type": "light_sleep" },
                    { "start": 18000, "end": 23400, "type": "awake" }
                  ]
                }
              }
            }
          }
        ]
      }
    }
    """

    // MARK: - Decoded Data
    var sleepDetails: SleepDetails? {
        guard let data = json.data(using: .utf8) else { return nil }
        let decoded = try? JSONDecoder().decode(Root.self, from: data)
        return decoded?.data.metric_data.first?.object.details
    }

    var totalSleepText: String {
        sleepDetails?.quick_metrics.first(where: { $0.type == "total_sleep" })?.display_text ?? "--h --m"
    }

    // MARK: - View
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image("sleepNight")
                        .foregroundColor(.indigo)
                    Text("Sleep Tracker")
                        .font(.system(size: 18))
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image( "sleepMoon")
                        .font(.system(size: 24))
                        .foregroundColor(.indigo)
                    Text(totalSleepText.prefix(2))
                        .font(.system(size: 24)) +
                    Text("h ")
                        .font(.title2) +
                    Text(totalSleepText.suffix(2))
                        .font(.system(size: 24))
                }
                
                HStack(spacing: 4) {
                    Image( "sleepArrow")
                        .foregroundColor(.gray)
                    Text("21 min more than yesterday")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                
                
            }
//            .padding()
//            .background(Color(.systemIndigo).opacity(0.1))
//            .cornerRadius(24)
            .padding()
            if let graphData = sleepDetails?.sleep_graph.data {
                SleepGraphView(data: graphData)
                    .frame(height: 100)
            }
        }    .background(Color(.systemIndigo).opacity(0.1))
            .cornerRadius(24)
            .padding()
    }
}

// MARK: - Mini Graph View
struct SleepGraphView: View {
    let data: [SleepTrackerCardView.SleepGraphEntry]

    func sleepStageToLevel(_ type: String) -> Int {
        switch type {
        case "awake": return 0
        case "light_sleep": return 1
        case "deep_sleep": return 2
        default: return 1
        }
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let totalDuration = CGFloat((data.last?.end ?? 0) - (data.first?.start ?? 0))

            Path { path in
                for i in 0..<data.count {
                    let entry = data[i]
                    let x = CGFloat(entry.start - data.first!.start) / totalDuration * width
                    let y = height - CGFloat(sleepStageToLevel(entry.type)) * (height / 3)
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.indigo, lineWidth: 2)
        }
    }
}

// MARK: - Preview
#Preview {
    SleepTrackerCardView()
}

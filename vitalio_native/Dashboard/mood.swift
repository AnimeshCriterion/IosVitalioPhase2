import SwiftUI

struct Mood: Identifiable, Equatable {
    let id: String
    let title: String
    let emoji: String
    let color: Color
    let labelColor: Color
}

let moods: [Mood] = [
    Mood(id: "angry", title: "Stressed", emoji: "angry", color: Color(red: 255/255, green: 94/255, blue: 58/255), labelColor: .orange),
    Mood(id: "upset", title: "anxious", emoji: "Upset", color: .blue, labelColor: .pink),
    Mood(id: "worried", title: "Low", emoji: "worried", color: .waterBlue, labelColor: .pink),
    Mood(id: "glad", title: "Happy", emoji: "glad", color: .primaryBlue.opacity(0.5), labelColor: .blue),
    Mood(id: "happy", title: "Good", emoji: "happy", color: .yellow, labelColor: .black),
    Mood(id: "spectacular", title: "Spectacular", emoji: "Spectacular", color: .red , labelColor: .black),
 ]

struct MoodSelectorCard: View {
    @State private var selectedMood: Mood? = nil
    @State private var selectedTime: Date? = nil

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(
                    gradient: Gradient(colors: backgroundColors()),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))

            VStack(alignment: .leading, spacing: 20) {
                // Title + Mood Selection
                if let mood = selectedMood {
                    HStack(spacing: 12) {
                        GIFView2(gifName: mood.emoji)
                            .frame(width: 120, height: 100)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Feeling \(mood.title)!")
                                .font(.title2)
                                .foregroundStyle(Color.textGrey)
                                .bold()

                            if let time = selectedTime {
                                Text(formattedTime(time))
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.6))
                            }
                        }

                        Spacer()
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("How’s your mood?")
                            .font(.title2)
                            .foregroundStyle(Color.textGrey)
                            .bold()
                        .padding(.top, 10)
                        Spacer()
                    }
                }

                Divider()

                if selectedMood != nil {
                    Text("Are you feeling a change in your mood?")
                        .font(.body)
                        .foregroundStyle(Color.textGrey)
                
                }

                // Mood List
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(moods) { mood in
                            VStack(spacing: 6) {
                                GIFView(gifName: mood.emoji)
                                    .frame(width: 50, height: 36)
//                                    .background(
//                                        Circle()
//                                            .fill(selectedMood == mood ? mood.color.opacity(0.4) : Color.clear)
//                                    )
                                Text(mood.title)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.textGrey)
                            }
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedMood = mood
                                    selectedTime = Date()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "Today \(formatter.string(from: date))"
    }

    private func backgroundColors() -> [Color] {
        if let mood = selectedMood {
            return [mood.color.opacity(0.7), mood.color.opacity(0.15)]
        } else {
            return [Color(red: 0.94, green: 0.96, blue: 1.0), Color(red: 0.88, green: 0.93, blue: 1.0)]
        }
    }
}

#Preview {
    
    ScrollView{
        MoodSelectorCard()
        Spacer()
    }
}

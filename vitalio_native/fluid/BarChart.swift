import SwiftUI

struct BarChart: View {
    let recommended: Double = 2000

    // Dynamic intake values (in ml)
    var water: Double
    var juice: Double
    var milk: Double
    var tea: Double

    var intake: Double {
        water + juice + milk + tea
    }

    var remaining: Double {
        max(recommended - intake, 0)
    }

    var body: some View {
    
        VStack(alignment: .leading, spacing: 8) {
            // Top Row
            HStack {
                Text("Recommended Fluid:")
                    .font(.subheadline)
                    .foregroundColor(.textGrey)
                Text("\(Int(recommended)) ml")
                    .font(.subheadline)
                Spacer()
                Text("Intake:")
                    .font(.subheadline)   
                    .foregroundColor(.textGrey)
                Text("\(Int(intake)) ml")
                    .font(.subheadline)
            }

            // Progress Bar with only start and end rounded
            GeometryReader { geometry in
                let totalWidth = geometry.size.width

                HStack(spacing: 0) {
                    // Water (Rounded left)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: totalWidth * CGFloat(water / recommended), height: 10)
                        .cornerRadius(5, corners: [.topLeft, .bottomLeft])

                    // Juice (no corner)
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: totalWidth * CGFloat(juice / recommended), height: 10)

                    // Milk (no corner)
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: totalWidth * CGFloat(milk / recommended), height: 10)

                    // Tea (no corner)
                    Rectangle()
                        .fill(Color.brown.opacity(0.6))
                        .frame(width: totalWidth * CGFloat(tea / recommended), height: 10)

                    // Remaining (Rounded right)
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: totalWidth * CGFloat(remaining / recommended), height: 10)
                        .cornerRadius(5, corners: [.topRight, .bottomRight])
                }
            }
            .frame(height: 10)

            // Legend Row
            HStack {
                HStack(spacing: 4) {
                    Circle().fill(Color.blue).frame(width: 8, height: 8)
                    Text("Water").font(.caption)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color.orange).frame(width: 8, height: 8)
                    Text("Juice").font(.caption)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color.yellow).frame(width: 8, height: 8)
                    Text("Milk").font(.caption)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color.brown.opacity(0.6)).frame(width: 8, height: 8)
                    Text("Tea").font(.caption)
                }
                Spacer()
                Text("Remaining: \(Int(remaining)) ml")
                    .font(.caption)
                    .foregroundColor(.textGrey)
            }
        }
        .padding()
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(water: 500, juice: 300, milk: 200, tea: 300)
    }
}

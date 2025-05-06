import SwiftUI

struct BarChart: View {


    // Dynamic intake values (in ml)
    var water: Double
    var juice: Double
    var milk: Double
    var tea: Double
    var coffee: Double
    var recommended: Double

    var intake: Double {
        water + juice + milk + tea + coffee
    }

    var remaining: Double {
        max(recommended - intake, 0)
    }
    
    var maxValue: Double {
        max(recommended , intake)
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
            VStack {
                GeometryReader { geometry in
                    let totalWidth = geometry.size.width

                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: totalWidth * CGFloat(water / maxValue), height: 10)
                            .cornerRadius(5, corners: [.topLeft, .bottomLeft])

                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: totalWidth * CGFloat(juice / maxValue), height: 10)

                        Rectangle()
                            .fill(Color.yellow)
                            .frame(width: totalWidth * CGFloat(milk / maxValue), height: 10)

                        Rectangle()
                            .fill(Color.green.opacity(0.6))
                            .frame(width: totalWidth * CGFloat(tea / maxValue), height: 10)

                        Rectangle()
                            .fill(Color.brown.opacity(0.6))
                            .frame(width: totalWidth * CGFloat(coffee / maxValue), height: 10)

                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: totalWidth * CGFloat(remaining / maxValue), height: 10)
                            .cornerRadius(5, corners: [.topRight, .bottomRight])
                    }
                }
                .frame(height: 10) // Fix height so GeometryReader doesn't expand vertically
            }
            .frame(maxWidth: .infinity) // Ensures it takes full

         

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
                    Circle().fill(Color.green.opacity(0.6)).frame(width: 8, height: 8)
                    Text("Green Tea").font(.caption)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color.brown.opacity(0.6)).frame(width: 8, height: 8)
                    Text("Coffee").font(.caption)
                }
                Spacer()
                if(intake <= recommended){
                    Text("Remaining: \(Int(remaining)) ml")
                        .font(.caption)
                        .foregroundColor(.textGrey)
                }else{
                    Text("Exceeded: \(Int(intake - recommended)) ml")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            
            }
        }
        .padding()
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(water: 500, juice: 300, milk: 200, tea: 300 , coffee:  0 , recommended: 1000)
    }
}

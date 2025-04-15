import SwiftUI

struct DropSliderSheet: View {
    @Binding var isPresented: Bool
    @State private var selectedAmount: Double = 135.0

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding()
                }
            }

            Text("How much did you drink?")
                .font(.headline)
                .padding(.bottom, 8)

            // White rounded box showing the value
            HStack(spacing: 0) {
                Text("\(Int(selectedAmount))")
                    .font(.system(size: 40, weight: .bold))
                    .frame(width: 100, height: 70)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 4)

                Text("ml")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
            }

            // Drop slider
            DropThumbSlider(value: $selectedAmount, range: 0...1000)
                .padding(.horizontal)

            // Ticks
            HStack {
                ForEach([0, 250, 500, 750, 1000], id: \.self) { mark in
                    Text("\(mark) ml")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

            // Add Button
            Button(action: {
                // Handle Add action
                isPresented = false
            }) {
                Text("Add : \(Int(selectedAmount)) ml")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.top, 8)

        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(24)
        .padding(.horizontal)
    }
}

struct DropThumbSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            let offset = progress * width

            ZStack(alignment: .leading) {
                // Track background
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)

                // Filled portion
                Capsule()
                    .fill(Color.blue)
                    .frame(width: offset, height: 6)

                // Thumb (drop icon)
                Image(systemName: "drop.fill")
                    .resizable()
                    .frame(width: 24, height: 30)
                    .foregroundColor(.blue)
                    .offset(x: offset - 12, y: -12)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let newValue = gesture.location.x / width
                                value = min(max(Double(newValue), 0.0), 1.0) * (range.upperBound - range.lowerBound) + range.lowerBound
                            }
                    )
            }
            .frame(height: 40)
        }
        .frame(height: 40)
    }
}

struct DropSliderSheet_Previews: PreviewProvider {
    static var previews: some View {
        DropSliderSheet(isPresented: .constant(true))
    }
}

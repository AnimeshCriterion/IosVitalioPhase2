import SwiftUI

struct FluidImageSlider: View {
    let imageName: String
    let imageOuter: String
    let fluidColor: Color
    let topColor: Color
    @Binding var value: Int   // Current amount filled
    let totalQuantity: Int    // E.g., 150ml, 500ml
    let height: CGFloat

    var body: some View {
        let clampedValue = min(value, totalQuantity)
        let fluidHeight = height * CGFloat(clampedValue) / CGFloat(totalQuantity)
        let percentage = Int((Double(clampedValue) / Double(totalQuantity)) * 100)

        ZStack {
            // Fluid Masked Image
            Image(imageName)
                .renderingMode(.template)
                .resizable()
               
                .aspectRatio(contentMode: .fit)
                .mask(
                    VStack(spacing: 0) {
                        Color.black.frame(height: fluidHeight)
                        Color.white
                    }
                )
                .overlay(
                    VStack(spacing: 0) {
                        topColor.frame(height: height - fluidHeight)
                        fluidColor.frame(height: fluidHeight)
                    }
                    .mask(
                        Image(imageName)
                            .resizable()
                        
                            .aspectRatio(contentMode: .fit)
                    )
                )

            // Outer image (outline)
            Image(imageOuter)
                .renderingMode(.template)
                .resizable()
            
                .aspectRatio(contentMode: .fit)
                .opacity(0.2)

            // Centered percentage text
            Text("\(percentage)%")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.gray)
        }
        .frame(height: height)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    let newLevel = height - gesture.location.y
                    let ratio = min(max(newLevel / height, 0), 1)
                    value = Int(ratio * CGFloat(totalQuantity))
                }
        )
    }
}

struct FluidImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .padding()
    }

    struct PreviewWrapper: View {
        @State private var fluidLevel: Int = 75 // Start with 75 out of 150 ml
        var body: some View {
            VStack {
                FluidImageSlider(
                    imageName: "water",
                    imageOuter: "wateroutline",
                    fluidColor: .white,
                    topColor: .white.opacity(0.5),
                    value: $fluidLevel,
                    totalQuantity: 150,
                    height: 200
                )

                Text("Filled: \(fluidLevel) ml")
                    .font(.headline)
            }
        }
    }
}


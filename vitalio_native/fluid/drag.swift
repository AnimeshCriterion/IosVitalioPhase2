import SwiftUI

struct FluidImageSlider: View {
    let imageName: String
    let imageOuter: String
    let fluidColor: Color
    let topColor: Color
    @Binding var value: Int   // Current amount filled
    let totalQuantity: Int    // E.g., 150ml, 500ml
    let height: CGFloat
    @EnvironmentObject var themeManager: ThemeManager
    
       var isDark: Bool {
           themeManager.colorScheme == .dark
       }
    
    
    
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
            VStack {
                Text("\(percentage)%")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(imageName == "milk" ? .gray :  .white )
                Text("\(clampedValue) ml of \(totalQuantity) ml")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(imageName == "milk" ? .gray :   .white )
                
            }
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
struct OutputLiquidContainer_Previews: PreviewProvider {
    static var previews: some View {
        PreviewOutputLiquidContainerWrapper()
            .previewLayout(.sizeThatFits)
            .padding()
    }

    struct PreviewOutputLiquidContainerWrapper: View {
        @State private var fluidLevel: Int = 75 // Start with 75 out of 150 ml
        var body: some View {
            HStack(alignment: .bottom, spacing: 8) {
                VerticalScaleLabels(selectedValue: CGFloat(fluidLevel))
                

                OutputLiquidContainer(
                    imageName: "outputscale",
                    imageOuter: "outputscale",
                    fluidColor: .yellow,
                    topColor: .white,
                    value: $fluidLevel,
                    totalQuantity: 1000,
                    height: 200
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)


                Text("Filled: \(fluidLevel) ml")
                    .font(.headline)
            }
        }
    }


struct OutputLiquidContainer: View {
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
            GeometryReader { geo in
                let containerHeight = geo.size.height
                let dynamicHeight = containerHeight * CGFloat(clampedValue) / CGFloat(totalQuantity)

                VStack {
                    ZStack {
                        // Fluid inside masked image
                        Image(imageName)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .mask(
                                VStack(spacing: 0) {
                                    Color.white
                                }
                            )
                            .overlay(
                                VStack(spacing: 0) {
                                    topColor.frame(height: containerHeight - dynamicHeight)
                                    fluidColor.frame(height: dynamicHeight)
                                }
                                .mask(
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                )
                            )

                        // Outline
                        Image(imageOuter)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.8)

                        // Line indicator
                        Rectangle()
                            .fill(Color.orange)
                            .frame(height: 2)
                            .offset(y: containerHeight / 2 - dynamicHeight)
                            .overlay(
                                Text("\(clampedValue) ml")
                                    .font(.caption)
                                    .padding(6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.orange)
                                    )
                                    .foregroundColor(.white)
                                    .offset( x : 100, y: containerHeight / 2 - dynamicHeight)
                            )

                        // Centered % text
                        Text("\(percentage)%")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }
                
            }
        }
        .frame(width: 200, height: height)
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

struct VerticalScaleLabels: View {
    let selectedValue: CGFloat

    var body: some View {
        VStack(spacing: 4) {
            ForEach(Array(stride(from: 1000, through: 0, by: -100)), id: \.self) { value in
                Text("\(value) ml")
                    .font(.caption)
                    .foregroundColor(selectedValue >= CGFloat(value) ? .blue : .gray)
            }
        }
    }
}

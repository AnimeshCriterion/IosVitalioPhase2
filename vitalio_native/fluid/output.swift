


import SwiftUI

struct Fluid: View {
    

    @EnvironmentObject var themeManager: ThemeManager

    
       var isDark: Bool {
           themeManager.colorScheme == .dark
       }

    
    @State private var isIntakeSelected = false


    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "chevron.left")
                Text("Fluid Data Input")
                    .font(.headline)
                Spacer()
                Button(action: {}) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("History")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.primaryBlue))
                }
            }
            .padding(.horizontal)



            ZStack {
                // Gray background
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 44)

                HStack(spacing: 0) {
                    // Sliding blue selector
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                            .frame(width: geometry.size.width / 2, height: 40)
                            .offset(x: isIntakeSelected ? 0 : geometry.size.width / 2)
                            .animation(.easeInOut(duration: 0.25), value: isIntakeSelected)
                    }
                }
                .frame(height: 44)
                .padding(.horizontal, 2)

                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation {
                            isIntakeSelected = true
                        }
                    }) {
                        Text("Fluid Intake")
                            .foregroundColor(isIntakeSelected ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                    }

                    Button(action: {
                        withAnimation {
                            isIntakeSelected = false
                        }
                    }) {
                        Text("Fluid Output")
                            .foregroundColor(!isIntakeSelected ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                    }
                }
            }
            .cornerRadius(14)
            .padding(.horizontal)
            
            if (isIntakeSelected==true){
                IntakeView()
            }else{
                Output()
            }
            
    

          
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .background(isDark ? Color.customBackground2: Color.customBackgroundDark)
    }



}

struct FluidOutputView_Previews: PreviewProvider {
    static var previews: some View {
        Fluid()        .environmentObject(ThemeManager())
    }
}


struct Output : View{
    
    let colors: [Color] = [
        Color.yellow.opacity(0.2),
        Color.yellow,
        Color.orange,
        Color.orange.opacity(0.8),
        Color.brown,
        Color.red
    ]

    let labels: [String] = [
        "Light Yellow",
        "Yellow",
        "Dark Yellow",
        "Amber",
        "Brown",
        "Red"
    ]


    @State private var selectedIndex: Int? = nil
    @State private var selectedValue: CGFloat = 550.0
    private let maxValue: CGFloat = 1000
    
    var body : some View{
        
        // Count and Volume
        HStack {
            VStack {
                Text("Urination count")
                    .foregroundColor(.gray)
                Text("8 times")
                    .font(.headline)
            }
            Divider()
                .frame(height: 40)
            VStack {
                Text("Urination volume")
                    .foregroundColor(.gray)
                Text("1450 ml")
                    .font(.headline)
            }
        }
        .padding(.horizontal)

        // Container + Scale
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.yellow.opacity(0.2))
                        .frame(
                            width: geo.size.width * 0.4,
                            height: fillHeight(from: selectedValue, height: geo.size.height * 0.6)
                        )
                        .animation(.easeInOut, value: selectedValue)
                    // Background Container Shape
                    RoundedRectangle(cornerRadius: 60)
                        .stroke(Color.gray, lineWidth: 20)
                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.6)

             

                    // Dotted orange line
                    Rectangle()
                        .fill(Color.orange)
                        .frame(height: 2)
                        .overlay(
                            Text(String(format: "%.1f", selectedValue / 100))
                                .padding(6)
                                .background(RoundedRectangle(cornerRadius: 6).fill(Color.orange))
                                .foregroundColor(.white)
                                .offset(x: 60)
                        )
                        .offset(y: -positionY(from: selectedValue, height: geo.size.height * 0.6))
                }
                .frame(height: geo.size.height * 0.6)

                // Drag to update
                Text("\(Int(selectedValue)) ml")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(Color.blue)
                    .padding(.top)

                Text("Last urination • 1h 34m ago")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let dragY = geo.size.height * 0.6 - value.location.y
                        let ratio = dragY / (geo.size.height * 0.6)
                        let newValue = min(max(ratio * maxValue, 0), maxValue)
                        selectedValue = newValue
                    }
            )
        }
        .frame(height: 300)



        VStack(spacing: 8) {
            // Color Rectangles
            HStack(spacing: 0) {
                ForEach(0..<6) { index in
                    VStack {
                        Rectangle()
                            .fill(colors[index])
                            .frame(height: 10)
                            .overlay(
                                Rectangle()
                                    .stroke(selectedIndex == index ? Color.black : Color.clear, lineWidth: 1)
                        )
                        Text(labels[index])
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }.onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
                }
            }
        }
        Spacer()
        Button(action: {
            
        }) {
            Text("Update")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryBlue)
                .cornerRadius(16)
                .padding(.horizontal)
        }
    }
    
    func fillHeight(from value: CGFloat, height: CGFloat) -> CGFloat {
        let ratio = value / maxValue
        return height * ratio
    }

    func positionY(from value: CGFloat, height: CGFloat) -> CGFloat {
        let ratio = value / maxValue
        return height * ratio
    }
}


struct IntakeView: View {
    @State private var selectedGlassSize: Int = 150
    @State private var selectedDrink: String = "Water"

    let drinks: [(name: String, icon: String)] = [
        ("Water", "drop.fill"),
        ("Juice", "carton.fill"),
        ("Milk", "milk.fill"),
        ("Tea", "cup.and.saucer.fill"),
        ("Coffee", "mug.fill"),
        ("Beverage", "bottle.fill")
    ]

    let glassSizes = [150, 250, 300, 400]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Recommended Fluid: 2,000 ml")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Intake: 1,700 ml")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("Remaining: 300 ml")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                // Cup with fill
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        .frame(width: 120, height: 220)

                    Rectangle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(height: 198) // 90% fill
                        .clipShape(RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight]))

                    VStack {
                        Text("90%")
                            .font(.title)
                            .bold()
                        Text("135 ml of 150 ml")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 60)
                }

                // Last intake time
                Text("Last intake • 1h 34m ago")
                    .font(.caption)
                    .foregroundColor(.gray)

                // Drink Types
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 12) {
                    ForEach(drinks, id: \.name) { drink in
                        Button(action: {
                            selectedDrink = drink.name
                        }) {
                            VStack {
                                Image(systemName: drink.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                    .foregroundColor(selectedDrink == drink.name ? .white : .gray)
                                Text(drink.name)
                                    .font(.caption)
                                    .foregroundColor(selectedDrink == drink.name ? .white : .gray)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedDrink == drink.name ? Color.blue : Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)

                // Enter fluid manually
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                    Text("Enter Fluid Manually")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)

                // Glass Size
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select Your Glass Size")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(spacing: 10) {
                        ForEach(glassSizes, id: \.self) { size in
                            Button(action: {
                                selectedGlassSize = size
                            }) {
                                Text("\(size) ml")
                                    .font(.footnote)
                                    .foregroundColor(selectedGlassSize == size ? .white : .black)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedGlassSize == size ? Color.blue : Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Intake")
    }
}

struct IntakeView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeView()
    }
}

// Helper for corner radius on specific corners
extension View {
    func cornerRadius2(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner2: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

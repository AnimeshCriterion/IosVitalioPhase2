//
//  Output.swift
//  vitalio_native
//
//  Created by HID-18 on 11/04/25.
//

import SwiftUI
struct Output : View{
    @EnvironmentObject var viewModel: FluidaViewModal
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
    @State private var fluidLevel: Int = 75
    @EnvironmentObject var themeManager: ThemeManager
       var isDark: Bool {
           themeManager.colorScheme == .dark
       }
    
    
    var body : some View{
        
        HStack {
            VStack {
                Text("Urination count")
                    .foregroundColor(.gray)
                Text("8 times")
                    .font(.subheadline)
            }
            Divider()
                .frame(height: 40)
            VStack {
                Text("Urination volume")
                    .foregroundColor(.gray)
                Text("1450 ml")
                    .font(.subheadline)
            }
        }
        .padding(.horizontal)
        
        Spacer()
        // Container + Scale
//        GeometryReader { geo in
            VStack {
                HStack(alignment: .center) {
                    Spacer()
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
                    .padding(.trailing, 50)
                    Spacer()
                }   .frame(maxWidth: .infinity, alignment: .center)
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.yellow.opacity(0.2))
//                        .frame(
//                            width: geo.size.width * 0.4,
//                            height: fillHeight(from: selectedValue, height: geo.size.height * 0.6)
//                        )
//                        .animation(.easeInOut, value: selectedValue)
//                    // Background Container Shape
//                    RoundedRectangle(cornerRadius: 60)
//                        .stroke(Color.gray, lineWidth: 20)
//                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.6)

             
//
//                    // Dotted orange line
//                    Rectangle()
//                        .fill(Color.orange)
//                        .frame(height: 2)
//                        .overlay(
//                            Text(String(format: "%.1f", selectedValue / 100))
//                                .padding(6)
//                                .background(RoundedRectangle(cornerRadius: 6).fill(Color.orange))
//                                .foregroundColor(.white)
//                                .offset(x: 60)
//                        )
//                        .offset(y: -positionY(from: selectedValue, height: geo.size.height * 0.6))
//                }
//                .frame(height: geo.size.height * 0.6)

                // Drag to update
                
                
                Text("\(Int(fluidLevel)) ml")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(Color.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Rectangle()
                        
                            .fill(isDark ? Color.customBackgroundDark2 : Color.white)
                            .frame(width: 150)
                           
                    )
                    .padding(.top)
                    .padding(.horizontal)


                Text("Last urination • 1h 34m ago")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
//            .gesture(
//                DragGesture(minimumDistance: 0)
//                    .onChanged { value in
//                        let dragY = geo.size.height * 0.6 - value.location.y
//                        let ratio = dragY / (geo.size.height * 0.6)
//                        let newValue = min(max(ratio * maxValue, 0), maxValue)
//                        selectedValue = newValue
//                    }
//            )




        VStack(spacing: 8) {
            HStack( alignment: .top ,spacing: 0) {
                ForEach(0..<6) { index in
                    VStack {
                        Rectangle()
                            .fill(colors[index])
                            .frame(height: 10)
                            
                        Text(labels[index])
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                    .overlay(
                        Rectangle()
                            .stroke(selectedIndex == index ? Color.black : Color.clear, lineWidth: 1)
                )
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
                }
            }
        }.padding(.horizontal,20)
        Spacer()
        Button(action: {
            Task{
                await  viewModel.saveOutput(fluidLevel: String(fluidLevel))
            }
        }) {
            
            if( viewModel.isOutputLoading == true ){
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }else{
                Text("Update")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryBlue)
                    .cornerRadius(16)
                    .padding(.horizontal)
            }
            
       
        }
        .onAppear(){
            Task{
                print("datadata")
                await  viewModel.getFoodList(hours : "24")
                print("datadata")
            }
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

#Preview {
    Output()
}


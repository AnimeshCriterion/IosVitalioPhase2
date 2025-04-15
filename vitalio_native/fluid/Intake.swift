import SwiftUI

struct IntakeView: View {
    @EnvironmentObject var viewModel: FluidaViewModal
    @State private var showBottomSheet = false
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                BarChart(water: 500, juice: 300, milk: 200, tea: 300)

//                FluidImageSlider(
//                    imageName: viewModel.containerImage,
//                    imageOuter: viewModel.imageOuter,
//                    fluidColor: .white,
//                    topColor: .white.opacity(0.9),
//                    value: $viewModel.fluidLevel,
//                    totalQuantity: viewModel.selectedGlassSize,
//                    height: 200
//                )

                Text("Last intake • 1h 34m ago")
                    .font(.caption)
                    .foregroundColor(.gray)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 12) {
                    ForEach(viewModel.drinks, id: \.name) { drink in
                        Button(action: {
                            viewModel.selectedDrink = drink.name
        
                            viewModel.containerImage = drink.containerImage
                            viewModel.imageOuter = drink.outerImage
                        }) {
                            VStack {
                                Image(drink.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                    .foregroundColor(viewModel.selectedDrink == drink.name ? .white : .gray)
                                Text(drink.name)
                                    .font(.caption)
                                    .foregroundColor(viewModel.selectedDrink == drink.name ? .white : .gray)
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(viewModel.selectedDrink == drink.name ? Color.blue : Color.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                    Text("Enter Fluid Manually")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Select Your Glass Size")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(spacing: 10) {
                        Button(action: {
                                 showBottomSheet = true
                        }) {
                            Image(systemName: "pencil.line")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.vertical, 4)
                                .frame(maxWidth: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        ForEach(viewModel.glassSizes, id: \.self) { size in
                            Button(action: {
                                viewModel.selectedGlassSize = size
                            }) {
                                Text("\(size) ml")
                                    .font(.footnote)
                                    .foregroundColor(viewModel.selectedGlassSize == size ? .white : .textGrey)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.selectedGlassSize == size ? Color.blue : Color.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.customBackground)
            .padding(.vertical)

            CustomButton(title: "Submit") {
                print("Button Tapped")
            }
        }
        .sheet(isPresented: $showBottomSheet) {
            DropSliderSheet(isPresented: $showBottomSheet)
                   .presentationDetents([.height(360)])
                   .presentationDragIndicator(.visible)
           }
        .navigationTitle("Intake")
    }
}

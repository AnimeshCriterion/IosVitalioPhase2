import SwiftUI

struct IntakeView: View {
    @EnvironmentObject var viewModel: FluidaViewModal
    @State private var showBottomSheet = false
    @EnvironmentObject var themeManager: ThemeManager
  
    
       var isDark: Bool {
           themeManager.colorScheme == .dark
       }
     
    var body: some View {
        ScrollView {
            VStack {
                BarChart(water:  viewModel.getBarQuantity(for: 97694) ?? 0,
                         juice: viewModel.getBarQuantity(for: 66) ?? 0,
                         milk: viewModel.getBarQuantity(for: 76) ?? 0,
                         tea:  viewModel.getBarQuantity(for: 114973) ?? 0,
                         coffee: viewModel.getBarQuantity(for: 168) ?? 0,
                         recommended: 2000)

                FluidImageSlider(
                    imageName: viewModel.containerImage,
                    imageOuter: viewModel.imageOuter,
                    fluidColor: viewModel.color,
                    topColor: isDark ? .customBackgroundDark2 : .white.opacity(0.9),
                    value: $viewModel.fluidLevel,
                    totalQuantity: viewModel.selectedGlassSize,
                    height: 250
                )

                Text("Last intake • 1h 34m ago")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                
                if viewModel.fluidList.isEmpty && viewModel.isLoading {
                    ProgressView()
                }
                else{
                    FluidGrid()
                }
                  
//                HStack(spacing: 4) {
//                    Image(systemName: "plus.circle")
//                        .foregroundColor(.blue)
//                    Text("Enter Fluid Manually")
//                        .font(.caption)
//                        .foregroundColor(.blue)
//                }
//                .padding(.top, 10)

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
                                    .background(viewModel.selectedGlassSize == size ? Color.blue : (isDark ? Color.customBackgroundDark2 :Color.white))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .onAppear(){
                    Task{
                        await  viewModel.getFoodList(hours : "24")
                        
                    }
                }
                
            }
            .background(isDark ? Color.customBackgroundDark : Color.customBackground)
            .padding(.vertical)

            if (viewModel.saveLoading  ) {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                if viewModel.fluidList.isEmpty && viewModel.isLoading {
                    
                }else{
                    CustomButton(title: "Submit") {
                        Task{
                            print(String(viewModel.fluidLevel) + "is Value")
                            await viewModel.saveIntake()
                            print("Button Tapped")}
                    }
                }
           
            }
          
        }
        .onAppear(){
            Task{
                await viewModel.getFoodHistoryList()
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


struct FluidGrid : View {
    @EnvironmentObject var themeManager: ThemeManager
  
    
       var isDark: Bool {
           themeManager.colorScheme == .dark
       }
    @EnvironmentObject var viewModel: FluidaViewModal
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 12) {
            ForEach(viewModel.fluidList, id: \.foodID) { drink in
                Button(action: {
                    viewModel.selectedDrink = drink.foodName
                            viewModel.containerImage = viewModel.getContainerImage(for: drink.foodID) ?? ""
                            viewModel.imageOuter = viewModel.getOuter(for: drink.foodID) ?? ""
                    viewModel.color = viewModel.getColor(for: drink.foodID) ?? .white
                            viewModel.selectedFoodId = drink.foodID
                    
                }) {
                    VStack {
                        Image(viewModel.getIcon(for: drink.foodID) ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .foregroundColor(viewModel.selectedDrink == drink.foodName ? .primaryBlue : .white)
                        Text(drink.foodName)
                            .font(.caption)
                            .foregroundColor(viewModel.selectedDrink == drink.foodName ? Color.textGrey : .textGrey)
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background( isDark ? Color.customBackgroundDark2 : Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(viewModel.selectedDrink == drink.foodName ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                    )

                }
            }
        }.background(isDark ? Color.customBackgroundDark : Color.customBackground2)
        
        .padding(.horizontal)
    }
    
    
}

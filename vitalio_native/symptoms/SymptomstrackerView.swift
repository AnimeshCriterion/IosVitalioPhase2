import SwiftUI

struct StillHaveSymptomsView: View {
    @EnvironmentObject var route: Routing
    @EnvironmentObject var viewModel : SymptomsViewModal
    @State private var currentSymptomIndex = 0
    @State private var selectedOption: String? = nil

    var body: some View {
        VStack(spacing: 32) {
            // Top bar
            CustomNavBarView(title: "SymptomsTracker", isDarkMode: false) {
                route.back()
            }

            Spacer()

            // Image
            Image("stillhave")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

            // Question
            if !viewModel.stillHaveSymptoms.isEmpty {
                let symptom = viewModel.stillHaveSymptoms[currentSymptomIndex]

                VStack(spacing: 8) {
                    Text("Do you still have")
                        .font(.title2)
                        .foregroundColor(.gray)

                    Text(symptom.details + "?")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.blue)
                }

                // Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        handleAnswer("Yes")
                    }) {
                        Text("Yes")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        handleAnswer("No")
                    }) {
                        Text("No")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                // Indicator
                HStack(spacing: 6) {
                    ForEach(0..<viewModel.stillHaveSymptoms.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentSymptomIndex ? Color.blue : Color.white.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
            } else {
                ProgressView("No Data")
            }

            Spacer()
        }

        .navigationBarHidden(true)
    }

    // MARK: - Functions

    func handleAnswer(_ answer: String) {
        let symptom = viewModel.stillHaveSymptoms[currentSymptomIndex]

        // Save the symptom if the answer is "Yes"
        if answer == "Yes" {
            let savingItem = SavingList(
                detailID: String(symptom.detailID),
                detailsDate: viewModel.getCurrentFormattedDateTime(),
                details: symptom.details,
                isFromPatient: "1"
            )
            
            if(currentSymptomIndex == viewModel.stillHaveSymptoms.count - 1 ){
                viewModel.sendSymptoms(savingList: viewModel.savingList)
                route.navigate(to: .dashboard )
            }else{
                viewModel.addSavingList(savingItem)
            }
            
        } else {
            if(currentSymptomIndex == viewModel.stillHaveSymptoms.count - 1 ){
                viewModel.sendSymptoms(savingList: viewModel.savingList)
                route.navigate(to: .dashboard )
            }
        }

        print("Symptom: \(symptom.details), Answer: \(answer)")

        withAnimation {
            if currentSymptomIndex < viewModel.stillHaveSymptoms.count - 1 {
                currentSymptomIndex += 1
            } else {
                print("All symptoms answered.")
                
            }
        }
    }


  
}

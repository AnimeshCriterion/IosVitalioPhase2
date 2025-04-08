import SwiftUI

struct SymptomTrackerView: View {
    let symptoms = ["Acidity", "Body pain", "Chills", "Cold", "Cough", "Diarrhea", "Fever", "Headache", "Tiredness", "Vomiting", "Chest Heaviness", "Dry cough"]
    
    let otherSymptoms = ["Abdominal Pain", "Bloating", "Chest pain", "Depression", "Chills", "Low BP", "Loss of Appetite", "Decrease Vision", "Cough", "Dizziness", "Heart burn", "Pain in Stomach", "Sneezing", "Difficult Breathing", "Pain in Left Arm", "Fatigue", "Pain in Left Leg", "Pain in Right Leg", "High BP", "Pain in Right Arm", "Muscle Cramp", "Itching", "Back Pain"]
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack(spacing: 16) {
            CustomNavBarView(title: "Symptoms Tracker",  isDarkMode: true ){}
            SearchBar(placeholder: "Search Symptoms i.e cold, cough")
            Text("Highlight any other symptoms you're experiencing from the list below.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(symptoms, id: \.self) { symptom in
                    SymptomCard(name: symptom)
                }
            }
            .padding(.horizontal)
            Text("Select Other Symptoms")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Spacer()
            CustomButton(title: "Save and Update Symptoms") {
                isSheetPresented.toggle()
                print("Symptoms Updated")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .padding(.top)
        .sheet(isPresented: $isSheetPresented) {
            AddVitalsBottomSheet(isPresented: $isSheetPresented)
                .presentationDetents([.fraction(0.6)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct SearchBar: View {
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(placeholder, text: .constant(""))
                .font(.system(size: 16))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// Symptom Card
struct SymptomCard: View {
    let name: String
    
    var body: some View {
        VStack {
            Image(systemName: "star.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            
            Text(name)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(width: 100, height: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}



struct SymptomTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        SymptomTrackerView()
    }
}


struct AddVitalsBottomSheet: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image("savevital")
                .resizable()
                .scaledToFit()
                .frame(height: 160)

            Text("Would you like to add your vitals?")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text("Adding your vitals now can enhance your health tracking and ensure accurate monitoring.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Button(action: {
                print("Add Vitals tapped")
                isPresented = false
            }) {
                Text("Add Vitals")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            Button(action: {
                isPresented = false
            }) {
                Text("Maybe later")
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(50)
    }
}


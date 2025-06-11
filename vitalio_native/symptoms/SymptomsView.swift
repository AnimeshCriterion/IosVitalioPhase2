import SwiftUI

struct SymptomTrackerView: View {
    @EnvironmentObject var symptomsVM : SymptomsViewModal
    @EnvironmentObject var route : Routing
    @EnvironmentObject var dark : ThemeManager
    @State private var isSheetPresented = false
    
    var isDark: Bool {
        dark.colorScheme == .dark
    }
 

    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(spacing: 16) {
                    HStack{
                        CustomNavBarView(title: "Symptoms Tracker",  isDarkMode: isDark ){
                            route.back()
                        }
                        Button(action: {
                            route.navigate(to: .symptomsHistory)
                              }) {
                                  Text("History")
                                      .foregroundColor(.primaryBlue)
                                      .padding(8)
                                      .background(isDark ? Color.customBackgroundDark2 : Color.white)
                                      .cornerRadius(20)
                              }
                    }
   
                    SearchBar(
                        placeholder: "Search Symptoms i.e cold, cough",
                        text: $symptomsVM.searchText,
                        suggestions: symptomsVM.otherSymptomsList
                    )
                    
                    Text("Highlight any other symptoms you're experiencing from the list below.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    if(symptomsVM.problemsWithIconList.isEmpty){
                        ProgressView()
                    }else{
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            
                            ForEach(symptomsVM.problemsWithIconList, id: \.problemId) { symptom in
                                let isSelected = symptomsVM.savingList.contains { $0.detailID == String(symptom.problemId) }
                                
                                SymptomCard(name: symptom.problemName, imageURL: symptom.displayIcon,
                                            isSelected: isSelected).onTapGesture {
                                    
                                    symptomsVM.addSavingList(SavingList(detailID: String(symptom.problemId), detailsDate: symptomsVM.getCurrentFormattedDateTime(), details: symptom.problemName, isFromPatient: "1"))
                                    
                                    //                        symptomsVM.addSymptom(OtherSymptom(problemId: symptom.problemId, problemName: symptom.problemName, isVisible: 1))
                                }
                            }
                        }
                        
                        
                        .padding(.horizontal)
                    }
                    
                    SavingListChipView()
                    CustomButton(title: "Save and Update Symptoms") {
                        
                        
                        let existingIDs = Set(symptomsVM.savingList.map { $0.detailID })

                        let newItems: [SavingList] = symptomsVM.symptomResponse.compactMap { item -> SavingList? in
                            let idString = String(item.detailID)
                            guard !existingIDs.contains(idString) else { return nil }

                            return SavingList(
                                detailID: idString,
                                detailsDate: item.detailsDate ?? "",
                                details: item.details,
                                isFromPatient: "0"
                            )
                        }

                        symptomsVM.savingList.append(contentsOf: newItems)

                        
                        
                        
                        if(symptomsVM.savingList.isEmpty){
                            symptomsVM.getStillHaveSymptoms()
                            isSheetPresented.toggle()
                        }else{
                            symptomsVM.sendSymptoms(savingList: symptomsVM.savingList)
                        }
                        //
                        print("Symptoms Updated")
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .onAppear(){
                    Task{
                        await symptomsVM.SymptomsHistory()
                        symptomsVM.icons()
                        symptomsVM.getStillHaveSymptoms()
                        symptomsVM.getSuggessions()
                        //                await symptomsVM.allSuggesstions()
                    }
                }
                .navigationBarHidden(true) // Hides the default AppBar
                .padding(.top)
                .sheet(isPresented: $isSheetPresented) {
                    AddVitalsBottomSheet(isPresented: $isSheetPresented)
                        .presentationDetents([.fraction(0.6)])
                        .presentationDragIndicator(.visible)
                }
     
            }
            SuccessPopupView(show: $symptomsVM.showSuccess, message: "Symptoms Added Successfully!")
                .zIndex(1)
    }}
}

struct SearchBar: View {
    @EnvironmentObject var symptomsVM : SymptomsViewModal
    let placeholder: String
    @Binding var text: String
    let suggestions: [OtherSymptom]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            // Show suggestions
            if !text.isEmpty {
                ForEach(suggestions.filter {
                    $0.problemName.lowercased().contains(text.lowercased())
                }, id: \.problemId) { suggestion in
                    Text(suggestion.problemName)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .onTapGesture {
                            symptomsVM.addSavingList(SavingList(detailID: String(suggestion.problemId), detailsDate: "", details: suggestion.problemName, isFromPatient: "1"))
                        text = suggestion.problemName
                            text = ""
                        }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct SymptomCard: View {
    let name: String
    let imageURL: String?
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: imageURL ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())

            Text(name)
                .font(.system(size: 14))
                .foregroundColor(isSelected ? .white : .gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(isSelected ? .primaryBlue : Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}



struct SymptomTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        SymptomTrackerView().environmentObject(SymptomsViewModal())
    }
}


struct AddVitalsBottomSheet: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var route : Routing
    @EnvironmentObject var viewModel : SymptomsViewModal
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
                if(viewModel.stillHaveSymptoms.isEmpty){
                    
                }else{
                    route.navigate(to: .stillHaveSymptomsView)
                }
            
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



struct SavingListChipView: View {
    @EnvironmentObject var symptomsVM: SymptomsViewModal

    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 8)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 2) {
                ForEach(symptomsVM.savingList) { item in
                    ZStack {
                        Text(item.details)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(16)
                            .onTapGesture {
                                // Re-adding the tapped chip again (optional logic)
                                symptomsVM.addSavingList(
                                    SavingList(
                                        detailID: item.detailID,
                                        detailsDate: Date().description, // or keep as is
                                        details: item.details,
                                        isFromPatient: item.isFromPatient
                                    )
                                )
                            }
                    }}
            }
            .padding()
        }
    }
}

import SwiftUI

struct ExpandableTileModel: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    var isExpanded: Bool = false
}

struct FAQView: View {
    @EnvironmentObject var route: Routing
    @EnvironmentObject var theme: ThemeManager
    
    var isDarkMode  : Bool {
        theme.colorScheme == .dark
    }
    
   
   
    @State private var tiles: [ExpandableTileModel] = [
        ExpandableTileModel(title: "How much cardio should I be doing?", content: "IMODIUM® products contain an active ingredient called Loperamide, which works by slowing down the movement of fluid through the gut. This allows for overall greater absorption of valuable fluids and salts back into your system and treats diarrhea symptoms."),
        ExpandableTileModel(title: "What is the best time to workout?", content: "The best time to work out is the one that fits your schedule and allows consistency."),
        ExpandableTileModel(title: "How to stay hydrated?", content: "Drinking enough water throughout the day is key, along with consuming hydrating foods like fruits and vegetables.")
    ]

    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            ScrollView {
                CustomNavBarView(title: "Frequently Asked Question",  isDarkMode: isDarkMode ) {
                    route.back()
                }
                .padding(.bottom,10)
                SearchBarView(isDark: isDarkMode)
                    .padding(.bottom,7)
                VStack(spacing: 10) {
                    ForEach(tiles.indices, id: \.self) { index in
                        ExpandableTileView(tile: $tiles[index], isDark: isDarkMode)
                    }
                }
                .padding(.horizontal, 16) 
                
                .padding(.top, 10)
            } .background(isDarkMode ? Color.customBackgroundDark : Color.white)
        }
        .background(isDarkMode ? Color.customBackgroundDark2 : Color.customBackgroundDark)
        .navigationBarHidden(true)
    }
}

struct ExpandableTileView: View {

    
    @Binding var tile: ExpandableTileModel
    var isDark : Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    tile.isExpanded.toggle()
                }
            }) {
            HStack {
                Text(tile.title)
                    .foregroundColor( isDark ? .white : .textGrey2)
                Spacer()

              
                    Image(systemName: tile.isExpanded ? "minus" : "plus")
                        .foregroundColor(.primaryBlue)
                }
            }

            if tile.isExpanded {
                Text(tile.content)
                    .font(.body)
                    .foregroundColor( isDark ? .gray : .black)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(isDark ? Color.customBackgroundDark2 : Color.white)
        .cornerRadius(10)

    }
}

struct ExpandableTileListView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}



struct SearchBarView: View {
    var isDark : Bool
    
    @State private var searchText: String = ""

    var body: some View {
        HStack {
            TextField("Search Symptoms i.e cold, cough", text: $searchText)
                .foregroundColor(isDark ? Color.white : Color.black)
                .font(.system(size: 16, weight: .regular, design: .default))
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(isDark ? Color.customBackgroundDark2 : Color.white)
                .cornerRadius(20)

            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray)
                .padding(.trailing, 12)
        }
        .background(isDark ? Color.customBackgroundDark2 : Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(isDark: true)
        
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.clear)
    }
}





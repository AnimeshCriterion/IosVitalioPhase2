
import SwiftUI

struct Fluid: View {
    
    
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fluidVM: FluidaViewModal
    
       var isDark: Bool {
           themeManager.colorScheme == .dark
       }
    
    @State private var isIntakeSelected = false


    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button(action: {
                    route.back()
                }) {
                    Image(systemName: "chevron.left").foregroundColor(.black)}
                Spacer().frame(width: 20)
                Text("Fluid Data Input")
                    .font(.headline)
                Spacer()
                Button(action: {
                    if (isIntakeSelected==true){
                        route.navigate(to: .inputHistoryView)
                    }else{
                        route.navigate(to: .outputHistoryView)
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
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
        .background(isDark ? Color.customBackgroundDark : Color.customBackground2)
    }
}
struct FluidOutputView_Previews: PreviewProvider {
    static var previews: some View {
        Fluid()      
            .environmentObject(ThemeManager())
    }
}

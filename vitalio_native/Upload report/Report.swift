//
//  Report.swift
//  vitalio_native
//
//  Created by HID-18 on 15/04/25.
//
import SwiftUI
struct ReportViewUI: View {
    @EnvironmentObject private var viewModel : UploadReportViewModel
    @EnvironmentObject private var routing : Routing
    @State private var selectedTabIndex = 0
    @State private var selectedTab: String? = "Radiology"
    @EnvironmentObject var dark: ThemeManager
    
    
    var isDarkMode: Bool {
        dark.colorScheme == .dark
    }
     let tabs = ["Radiology", "Imaging", "Lab"]
    var filteredReports: [AllReport] {
        return viewModel.allReports
    }

    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                CustomNavBarView(title: "Report", isDarkMode: isDarkMode) {
                    routing.back()
                }
                
                Button(action: {
                    routing.navigate(to: .addLabReportView)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.primaryBlue)
                        Text("Add Report")
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryBlue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(isDarkMode ? Color.customBackgroundDark2 : Color.white)
                    .cornerRadius(25)}
            }

            ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(tabs, id: \.self) { tab in
                                HStack {
                                    Image(systemName: getImage(for: tab))
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(selectedTab == tab ? .blue : .gray)

                                    VStack {
                                        Text(tab)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(selectedTab == tab ? .blue : .gray)
                                        if(selectedTab == tab){
                                            Text("\(filteredReports.count) Record\(filteredReports.count > 1 ? "s" : "")")
                                                .font(.caption)
                                                .foregroundColor(selectedTab == tab ? .blue : .gray)
                                        }
                                    }
                                }
                                .frame(width: 100, height: 40)
                                .padding()
                                .background(selectedTab == tab ?(isDarkMode ? Color.customBackgroundDark2 : Color.white) : Color.clear)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedTab == tab ? .blue : .clear, lineWidth: 1)
                                )
                                .onTapGesture {
                                    selectedTab = tab
                                    Task {
                                        await viewModel.getAllReport(name: tab)
                                    }
                                }
                            }
                        }
                    }
            Text("Results")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)
            if viewModel.isloading == true {
                ProgressView() .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else{
                if(filteredReports.isEmpty){
                    Text("Report not found")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                }else{
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredReports, id: \.id) { report in
                                ReportRowDynamic(report: report)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(isDarkMode ? Color.customBackgroundDark  : Color.customBackground2)
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await viewModel.getAllReport(name: tabs[0])
            }
        }
    }
    // Function to get the image for each tab
    func getImage(for tab: String) -> String {
        switch tab {
        case "Radiology": return "waveform.path.ecg"
        case "Imaging": return "heart.text.square"
        case "Lab": return "lab.flask.fill"
        default: return "circle" // Fallback
        }
    }
    
    // Function to get the count for each tab
    func getCount(for tab: String) -> Int {
        switch tab {
        case "Radiology": return 1
        case "Imaging": return 3
        case "Lab": return 4
        default: return 0 // Default count
        }
    }
}

struct ReportViewUI_Previews: PreviewProvider {
    static var previews: some View {
        ReportViewUI().environmentObject(UploadReportViewModel())
    }
}


struct ReportRowDynamic: View {
    var report: AllReport
    @EnvironmentObject var dark: ThemeManager
    
    
    var isDarkMode: Bool {
        dark.colorScheme == .dark
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(report.category )
                    .font(.headline)
                    .foregroundColor(isDarkMode ? .white : .black)

                Text("Time: \(report.dateTime )")
                    .font(.subheadline)
                    .foregroundColor(isDarkMode ? .white : .black)

                Text("Type: \(report.fileType )")
                    .font(.footnote)
                    .foregroundColor(isDarkMode ? .white : .black)

                Text(report.subCategory ?? "" )
                    .font(.caption)
                    .foregroundColor(isDarkMode ? .white : .black)
            }

            Spacer()

            AsyncImage(url: URL(string: report.filePath ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // or placeholder image
                                .frame(width: 100, height: 70)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 70)
                                .clipped()
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 70)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
        }
        .padding()
        .background(isDarkMode ? Color.customBackgroundDark2  : Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

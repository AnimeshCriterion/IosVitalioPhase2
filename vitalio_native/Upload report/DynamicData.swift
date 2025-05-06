import Foundation
import SwiftUI

struct DynamicData: Decodable, Identifiable {
    var id = UUID() // required for SwiftUI List
    var key: String?
    var value: Any?

    enum CodingKeys: CodingKey {
        case key, value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        key = try container.decodeIfPresent(String.self, forKey: .key)

        if let stringValue = try? container.decode(String.self, forKey: .value) {
            value = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .value) {
            value = intValue
        } else if let boolValue = try? container.decode(Bool.self, forKey: .value) {
            value = boolValue
        } else if let arrayValue = try? container.decode([DynamicData].self, forKey: .value) {
            value = arrayValue
        } else {
            value = nil
        }
    }

    init(key: String?, value: Any?) {
        self.key = key
        self.value = value
    }
}

struct DynamicResponseView: View {
    @EnvironmentObject var viewModel: UploadReportViewModel

    var body: some View {
     
            
            ZStack{
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let json = viewModel.serverJSON {
                            RecursiveView(data: json)
                                .padding()
                        } else {
                            if(viewModel.uploadingFile == true){
                                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                            }else{
                                
                                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                }}
                
                SuccessPopupView(show: $viewModel.completed, message: "Saved")
                    .zIndex(1)
                
            }
        
        Button("Save") {
         
            viewModel.insertInvestigationFromServerData()

            print(viewModel.serverJSON as Any)
        }
    }
}

struct RecursiveView: View {
    let data: Any
    let level: Int

    init(data: Any, level: Int = 0) {
        self.data = data
        self.level = level
    }

    var body: some View {
        Group {
            if let dict = data as? [String: Any] {
                ForEach(dict.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(key.capitalized)
                            .font(.system(size: 16 + CGFloat(max(0, 2 - level) * 2), weight: .bold))
                            .padding(.top, 4)

                        RecursiveView(data: value, level: level + 1)
                    }
                }
            } else if let array = data as? [Any] {
                ForEach(0..<array.count, id: \.self) { index in
                    RecursiveView(data: array[index], level: level + 1)
                        .padding(.leading, CGFloat(level * 10))
                }
            } else {
                TextField("", text: .constant("\(data)"))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(true)
            }
        }
    }
    
    
    

    
    
    
    
    
    
    
    
    
}

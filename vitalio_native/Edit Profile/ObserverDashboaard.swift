import SwiftUI

struct ChatOption: Identifiable {
    let id = UUID()
    let title: String
    let followUp: ChatQuestion?
    let view: AnyView?
}

struct ChatQuestion {
    let text: String
    let options: [ChatOption]?
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String?
    let isBot: Bool
    let view: AnyView?
    let options: [ChatOption]?
    let expectsInput: Bool

    init(text: String?, isBot: Bool, view: AnyView? = nil, options: [ChatOption]? = nil, expectsInput: Bool = false) {
        self.text = text
        self.isBot = isBot
        self.view = view
        self.options = options
        self.expectsInput = expectsInput
    }
}

struct ChatBotView: View {
    @EnvironmentObject var viewModel: FluidaViewModal
    @EnvironmentObject var chatViewModel: ChatViewModel


    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("ChatBot").font(.title2).bold()
                    Spacer()
                    Button("Restart") {
                        restart()
                    }
                    .foregroundColor(.red)
                }.padding()
                    .onAppear(){
                        Task {
                            await  viewModel.getFoodList(hours : "24")
                        }
                    }

                Divider()

                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(chatViewModel.messages) { msg in
                                messageView(msg)
                                    .id(msg.id)
                            }
                        }
                        .padding()
                    }
                    .coordinateSpace(name: "scroll")
                    .onChange(of: chatViewModel.messages.count) { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if let last = chatViewModel.messages.last {
                                  withAnimation {
                                      scrollProxy.scrollTo(last.id, anchor: .bottom)
                                  }
                              }
                          }
                    }
                }
                Divider()
            }
            .navigationBarHidden(true)
            .onAppear {
                restart()
            }
        }
    }

    func restart() {
        chatViewModel.messages.removeAll()

        let initialQuestion = ChatQuestion(
            text: "Hi! What would you like to do today?",
            options: [
                ChatOption(title: "Vitals", followUp: ChatQuestion(
                    text: "Would you like to add vitals or view vitals history?",
                    options: [
                        ChatOption(title: "Add Vitals", followUp: ChatQuestion(text: "Please enter your vitals.", options: nil), view: nil),
                        ChatOption(title: "View History", followUp: ChatQuestion(text: "Showing vitals history...", options: nil), view: nil)
                    ]), view: nil),

                ChatOption(title: "Fluid", followUp: ChatQuestion(
                    text: "Track input, output, or view history?",
                    options: [
                        ChatOption(title: "Input", followUp: ChatQuestion(text: "Here's your fluid input view. Select quantity and fluid name and then click submit", options: nil), view: AnyView(FluidChatIntake())),
                        ChatOption(title: "Output", followUp: ChatQuestion(text: "Please enter your fluid output.", options: nil), view: AnyView(FluidChatOutput())),
                        ChatOption(title: "View History", followUp: ChatQuestion(text: "Showing fluid history...", options: nil), view: AnyView(SeeInputHistoryView()))
                    ]), view: nil),

                ChatOption(title: "Pills", followUp: ChatQuestion(text: "Reminder: Time for your pills 💊", options: nil), view: nil),
                ChatOption(title: "Diet", followUp: ChatQuestion(text: "Let’s make healthy food choices today 🥗", options: nil), view: nil),
                ChatOption(title: "Upload Report", followUp: ChatQuestion(
                    text: "Do you want to upload a new report or view existing ones?",
                    options: [
                        ChatOption(title: "Upload", followUp: ChatQuestion(text: "Please upload your report.", options: nil), view: nil),
                        ChatOption(title: "View", followUp: ChatQuestion(text: "Showing your reports...", options: nil), view: nil)
                    ]), view: nil)
            ]
        )

        showBotQuestion(initialQuestion)
    }

    func showBotQuestion(_ question: ChatQuestion) {
        chatViewModel.messages.append(ChatMessage(text: question.text, isBot: true))
        if let options = question.options {
            chatViewModel.messages.append(ChatMessage(text: nil, isBot: true, options: options))
        } else {
            // Removed the .expectsInput message since no text input anymore
            chatViewModel.messages.append(ChatMessage(text: nil, isBot: true))
        }
    }

    func userSelected(_ option: ChatOption) {
        chatViewModel.messages.append(ChatMessage(text: option.title, isBot: false))

        if let view = option.view {
            chatViewModel.messages.append(ChatMessage(text: nil, isBot: true, view: view))
        }

        if let followUp = option.followUp {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                showBotQuestion(followUp)
            }
        }
    }

    func sendUserText(_ text: String) {
        // Function no longer used; kept for completeness if needed later
    }

    func messageView(_ message: ChatMessage) -> some View {
        VStack(alignment: message.isBot ? .leading : .trailing, spacing: 8) {
            if let text = message.text {
                Text(text)
                    .padding(12)
                    .background(message.isBot
                        ? Color.gray.opacity(0.15)
                        : Color.blue)
                    .foregroundColor(message.isBot ? .primary : .white)
                    .clipShape(
                        RoundedCornersShape(
                            radius: 20,
                            corners: message.isBot
                            ? [ .topRight, .bottomRight , .bottomLeft]  // receiver (bot) corners rounded except bottom-left
                            : [.topLeft, .bottomLeft, .bottomRight]   // sender corners rounded except bottom-right
                        )
                    )
                    .frame(maxWidth: 250, alignment: message.isBot ? .leading : .trailing)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .padding(message.isBot ? .leading : .trailing, 16)
                    .padding(message.isBot ? .trailing : .leading, 60)
            }

            if let options = message.options {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                    ForEach(options) { option in
                        Button(option.title) {
                            userSelected(option)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .frame(width: 100)
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                }
                .padding(.top, 4)
                .padding(message.isBot ? .leading : .trailing, 16)
                .padding(message.isBot ? .trailing : .leading, 60)
            }

            if let view = message.view {
                ScrollView(.horizontal, showsIndicators: true) {
                    view
                        .frame(width:  300)
                        .frame(maxHeight: 500)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }





        }
        .frame(maxWidth: .infinity, alignment: message.isBot ? .leading : .trailing)
        .padding(.vertical, 4) // vertical space between messages
    }

    // Custom Shape to round specific corners
    struct RoundedCornersShape: Shape {
        var radius: CGFloat = 20
        var corners: UIRectCorner = .allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
    struct FluidChatIntake: View {
        @EnvironmentObject var viewModel: FluidaViewModal
        @EnvironmentObject var chatViewModel: ChatViewModel
        @State private var showBottomSheet = false
        @EnvironmentObject var themeManager: ThemeManager

        var isDark: Bool {
            themeManager.colorScheme == .dark
        }

        var body: some View {
     

            VStack {
                if viewModel.fluidList.isEmpty && viewModel.isLoading {
                    ProgressView()
                } else {
                    FluidGrid()
                }
                if viewModel.saveLoading {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    if viewModel.containerImage != "beverage" {
                        FluidImageSlider(
                            imageName: viewModel.containerImage,
                            imageOuter: viewModel.imageOuter,
                            fluidColor: viewModel.color,
                            topColor: isDark ? .customBackgroundDark2 : .white.opacity(0.9),
                            value: $viewModel.fluidLevel,
                            totalQuantity: viewModel.selectedGlassSize,
                            height: 250
                        )
                        CustomButton(title: "Submit") {
                            Task {
                                print(String(viewModel.fluidLevel) + "is Value")
                                await viewModel.saveIntake()
                                print("Button Tapped")
                                chatViewModel.messages.append(ChatMessage(text: "Fluid Intake Added, you can see history below ", isBot: true,  view: AnyView(SeeInputHistoryView())))
                            }
                        }.frame(width: 100)
                    }
                }
            }
        }
    }
    
    struct SeeInputHistoryView: View {
        var body: some View {
            InputView(isFromChat: true)
        }
    }
    
        
    struct SeeOutputHistoryView: View {
        var body: some View {
            OutputHistoryView(isFromChat: true)
        }
    }
    
    
    

    struct FluidChatOutput: View {
        @EnvironmentObject var chatViewModel: ChatViewModel
        @EnvironmentObject var viewModel: FluidaViewModal
        @State private var showBottomSheet = false
        @EnvironmentObject var themeManager: ThemeManager
        @State private var fluidLevel: Int = 75

        var isDark: Bool {
            themeManager.colorScheme == .dark
        }
        
        var body: some View {
            HStack {
                OutputLiquidContainer(
                    imageName: "outputscale",
                    imageOuter: "outputscale",
                    fluidColor: .yellow,
                    topColor: .white,
                    value: $fluidLevel,
                    totalQuantity: 1000,
                    height: 200
                )
                Text("\(Int(fluidLevel)) ml")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.blue)
            }

            Button(action: {
                Task {
                    await viewModel.saveOutput(fluidLevel: String(fluidLevel))
                    chatViewModel.messages.append(ChatMessage(text: "Fluid Intake Added, you can see history below ", isBot: true,  view: AnyView(SeeOutputHistoryView())))
                }
            }) {
                if viewModel.isOutputLoading == true {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("Update")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryBlue)
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
            }
        }
    }
}



class ChatViewModel  : ObservableObject {
    
    @Published  var messages: [ChatMessage] = []
}


#Preview {
    ChatBotView()
}

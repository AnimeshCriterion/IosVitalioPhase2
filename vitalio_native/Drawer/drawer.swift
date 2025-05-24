//
//  drawer.swift
//  vitalio_native
//
//  Created by HID-18 on 24/03/25.
//

import SwiftUI


struct SideMenuView: View {
    
    @EnvironmentObject var editProfileVM: EditProfileViewModal
    @EnvironmentObject var loginViewModel: LoginViewModal
    @EnvironmentObject var route: Routing
    @EnvironmentObject var themeManager: ThemeManager
    
    var isDarkMode: Bool {
           themeManager.colorScheme == .dark
       }
    
    @State private var profileImage: UIImage?
    @EnvironmentObject var viewModel : DashboardViewModal
    @State private var showLogoutSheet = false
    @State private var selectedImage: UIImage?
    @State private var imageFilename: String?
    @State private var isShowingPicker = false
    @State private var isShowingActionSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var userData =  UserDefaultsManager.shared.getUserData()
    
    var body: some View {
        ZStack {
            (isDarkMode ? Color.customBackgroundDark : Color.customBackground2).ignoresSafeArea()

            ScrollView{
                
                VStack {
                    VStack(
                        alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                            Spacer()
                            
                            HStack {
                                Button(action: {
                                    viewModel.isDrawerOpen.toggle()
                                }) {
                                    Image("left").frame(maxWidth:  .infinity, alignment: .leading).padding(10)}
                                Button(action: {
                                               showLogoutSheet = true
                                }) {
                                    
                                    Image(systemName: "ellipsis")
                                        .font(.title3)
                                        .padding(10)
                                    .rotationEffect(.degrees(90))}
                            }
                            Spacer()

                            Button(action: {
                                                            isShowingActionSheet = true
                                                            print("SelectedImage: \(selectedImage?.description ?? "nil")")
                                                            if let filename = imageFilename {
                                                                print("Selected image file name: \(filename)")
                                                            }
                                                            print("FaheemCheck \(UserDefaultsManager.shared.getUserData()?.profileUrl ?? "No URL")")
                                                        }) {
                                                            Group {
                                                                if let urlString = UserDefaultsManager.shared.getUserData()?.profileUrl,
                                                                   let url = URL(string: urlString) {
                                                                     AsyncImage(url: url) { phase in
                                                                        if let image = phase.image {
                                                                            if editProfileVM.loadingImage {  ProgressView() } else {   image
                                                                                .resizable()
                                                                                .scaledToFill()
                                                                                .clipShape(Circle())}
                                                                        } else if phase.error != nil {
                                                                            Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                                                                                .resizable()
                                                                                .scaledToFit()
                                                                                .foregroundColor(.gray)
                                                                        } else {
                                                                            ProgressView()
                                                                        }
                                                                    }
                                                                    .frame(width: 100, height: 100)
                                                                } else {
                                                                    Image(systemName: "person.crop.circle")
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .frame(width: 100, height: 100)
                                                                        .foregroundColor(.gray)
                                                                }
                                                            }
                                                               }
                                                        .actionSheet(isPresented: $isShowingActionSheet) {
                                                            ActionSheet(title: Text("Select Image"), buttons: [
                                                                .default(Text("Camera")) {
                                                                    sourceType = .camera
                                                                    isShowingPicker = true
                                                                },
                                                                .default(Text("Photo Library")) {
                                                                    sourceType = .photoLibrary
                                                                    isShowingPicker = true
                                                                },
                                                                .cancel()
                                                            ])
                                                        }
                                                        .sheet(isPresented: $isShowingPicker, onDismiss: {
                                                            Task {
                                                                    guard let image = selectedImage,
                                                                          let imageData = image.jpegData(compressionQuality: 0.8),
                                                                          let imageFilename = imageFilename else {
                                                                        print("❌ No image selected")
                                                                        return
                                                                    }
                                                                    do {
                                                                        print("selected image \(imageFilename)")
                                                                         await editProfileVM.updateProfileDataForP(imageData: imageData, filename: imageFilename)
                                                                        editProfileVM.loadingImage = true
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                                            Task {
                                                                                await loginViewModel.loadData(uhid: UserDefaultsManager.shared.getUserData()?.uhID ?? "")
                                                                                editProfileVM.loadingImage = false
                                                                            }
                                                                        }
                                                                       
                                                                        
                                                                    }
                                                                }
                                                        }) {
                                                            ImagePicker(selectedImage: $selectedImage, imageFilename: $imageFilename, sourceType: sourceType)
                                                        }

                            
                            CustomText(userData?.patientName ?? "", color:    isDarkMode ? Color.white:  Color.black, size: 24, weight: Font.Weight.semibold)
                            
                            if let userData = UserDefaultsManager.shared.getUserData() {
                                CustomText("+91 \(userData.mobileNo)", color: Color.gray, size: 18, weight: .semibold)
                            } else {
                                CustomText("", color: Color.gray, size: 18, weight: .semibold)
                            }

                            Spacer()
                            Button(action: {
                                route.navigate(to: .editProfile)
                            }) {
                                HStack {
                                    Text("Edit Profile")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .frame(height: 30)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.primaryBlue)
                                .cornerRadius(15)
                            }
                            Spacer()
                        }
                        .frame(height: 310)
                        .background(isDarkMode ? Color.customBackgroundDark2 : Color.white)
                        .cornerRadius(15)
                        .padding()
                    VStack{
                        Button(action: {
                            route.navigate(to: .allergies)
                        }) {
                        DrawerTile(title: "Allergies", iconName: "allergies", dark: isDarkMode )}
                        Button(action: {
                            route.navigate(to: .sharedAccountView)
                        }) {
                            DrawerTile(title: "Switch account", iconName: "addmember", dark: isDarkMode )}
                        DrawerTile(title: "Connect Smart Watch", iconName: "watch", dark: isDarkMode )
                        DrawerTile(title: "Add Member", iconName: "addmember", dark: isDarkMode )
                        
                    }
                    .padding(10)
                    
                    VStack{
                        
                        GroupedDrawerTile(title: "Language", iconName: "language", dark: isDarkMode)
                        Button(action: {
                            route.navigate(to: .darkmode)
                        }) {
                            GroupedDrawerTile(title: "Dark Mode", iconName: "darkmode", dark: isDarkMode)}
                        Button(action: {
                            route.navigate(to: .faqView)
                        }) {
                            GroupedDrawerTile(title: "FAQs", iconName: "faq", dark: isDarkMode)
                        }
                        Button(action: {
                            route.navigate(to: .feedback)
                        })
                        {
                            GroupedDrawerTile(title: "Feedback", iconName: "feedback", dark: isDarkMode)
                        }
                               Button(action: {
                            route.navigate(to: .createAccountView)
                        })
                        {
                            GroupedDrawerTile(title: "Create Account", iconName: "feedback", dark: isDarkMode)
                        }
                        
                    }
                    .sheet(isPresented: $showLogoutSheet) {
                               LogoutConfirmationSheet(isPresented: $showLogoutSheet)
                                   .presentationDetents([.height(250)])
                                   .presentationDragIndicator(.visible)
                           }
                    .background( isDarkMode ?Color.customBackgroundDark2 : Color.white)
                    .cornerRadius(15)
                    .padding(10)
                }
            }
        }
    }
}

struct drawer: View {
   
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isDrawerOpen = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Button(action: {
                isDrawerOpen.toggle()
            }) {
                Text("Main Content")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            ZStack {
                if isDrawerOpen {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isDrawerOpen.toggle()
                            }
                        }
                }
                SideMenuView()
                    .offset(x: isDrawerOpen ? 0 : -500 + dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.width > 0 {
                                    dragOffset = value.translation.width
                                }
                            }
                            .onEnded { value in
                                if value.translation.width > 100 {
                                    isDrawerOpen = true
                                } else {
                                    isDrawerOpen = false
                                }
                                dragOffset = 0
                            }
                    )
             
                
            }
   
            .preferredColorScheme(themeManager.colorScheme)
            .animation(.easeInOut, value: isDrawerOpen)
        }
    }
}




#Preview {
    drawer()
        .environmentObject(ThemeManager())
}

struct DrawerTile: View {
    var title: String
    var iconName: String
    var dark : Bool

    var body: some View {
        HStack {
            Image(iconName)
                .font(.title2)
                .frame(height: 20)
                .foregroundColor( dark ? .red : .gray).padding(.leading, 16)
            CustomText(title,color: dark ? Color.white : Color.black)
                .font(.title3)
                .padding(.leading, 10)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(10)
        }
        .padding(5)
        .background(dark ? Color.customBackgroundDark2 : Color.white)
        .cornerRadius(8)
    }
}

struct GroupedDrawerTile: View {
    
    var title: String
    var iconName: String
    var dark : Bool

    var body: some View {
        HStack {
            Image(iconName)
                .font(.title2)
                .frame(height: 20)
                .foregroundColor(.blue).padding(.leading, 16)
            CustomText(title,color: dark ? Color.white: Color.black)
                .font(.title3)
                .padding(.leading, 10)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(10)
        }
        .padding(5)
        .background(dark ? Color.customBackgroundDark2 :  Color.white)
    }
}

struct LogoutConfirmationSheet: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var route: Routing
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.primary)
                .padding(.top)

            Text("Are you sure you want to logout?")
                .font(.headline)
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(10)
                }

                Button(action: {
                    isPresented = false
                    UserDefaultsManager.shared.saveIsLoggedIn(loggedIn: false)
                    route.navigatoToRoot()
                    
                    print("✅ Logged Out")
                }) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}


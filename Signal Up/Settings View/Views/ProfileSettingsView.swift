//
//  ProfileSettingsView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 18.03.25.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Binding var userProfile: UserProfile
    @State private var profileImage: Image?
    @State private var showingImagePicker = false
    @State private var showingQRCode = false
    @State private var isWalletAddressMasked = true
    @State private var showConfirmationDialog = false
    @State private var showValidationError = false
    @State private var validationErrorMessage = ""
    @State private var isWalletAddressCopied = false
    
    var body: some View {
        Form {
            // Section 1: Profile Picture
            Section(header: Text("Profile Picture")) {
                HStack {
                    if let profileImage = profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "brain.head.profile.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .padding()
                            .background {
                                Circle()
                                    .foregroundStyle(.black)
                            }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        Text("Change Photo")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // Section 2: User Profile
            Section(header: Text("User Profile")) {
                TextField("Full Name", text: $userProfile.userName)
                TextField("Email Address", text: $userProfile.userEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            // Section 3: Blockchain Information
            Section(header: Text("Blockchain Information")) {
                // Wallet Address
                HStack {
                    if isWalletAddressMasked {
                        Text("••••••••••••••••••••••••••")
                            .frame(maxWidth: 200)
                            .background(isWalletAddressCopied ? Color.blue.opacity(0.5) : Color.clear)
                            .lineLimit(1)
                            .cornerRadius(4)
                            .animation(.easeInOut(duration: 0.3), value: isWalletAddressCopied)
                        
                        Text("Copied")
                            .foregroundStyle(isWalletAddressCopied ? Color.blue : Color.clear)
                            .lineLimit(1)
                            .cornerRadius(4)
                            .animation(.easeInOut(duration: 0.3), value: isWalletAddressCopied)
                        Spacer()
                        
                        
                    } else {
                        Text(userProfile.walletAddress)
                            .frame(maxWidth: 200)
                            .lineLimit(1)
                            .background(isWalletAddressCopied ? Color.blue.opacity(0.5) : Color.clear)
                            .cornerRadius(4)
                            .animation(.easeInOut(duration: 0.3), value: isWalletAddressCopied)
                        
                        Text("Copied")
                            .foregroundStyle(isWalletAddressCopied ? Color.blue : Color.clear)
                            .lineLimit(1)
                            .cornerRadius(4)
                            .animation(.easeInOut(duration: 0.3), value: isWalletAddressCopied)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Copy Button
                    Button(action: {
                        UIPasteboard.general.string = userProfile.walletAddress
                        isWalletAddressCopied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isWalletAddressCopied = false
                        }
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Toggle Mask Button
                    Button(action: {
                        withAnimation(.snappy) {
                            isWalletAddressMasked.toggle()
                        }
                    }) {
                        Image(systemName: isWalletAddressMasked ? "lock.fill" : "lock.open.fill")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.snappy) {
                        isWalletAddressMasked.toggle()
                    }
                }
                
                // QR Code Button
                Button(action: {
                    showingQRCode = true
                }) {
                    HStack {
                        Image(systemName: "qrcode")
                        Text("Show Wallet Address")
                    }
                    .foregroundColor(.blue)
                }
            }
            
            // Section 4: Save Changes
            Section {
                Button(action: {
                    if validateInputs() {
                        showConfirmationDialog = true
                    } else {
                        showValidationError = true
                    }
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $profileImage)
        }
        .sheet(isPresented: $showingQRCode) {
            QRCodeView(walletAddress: userProfile.walletAddress)
        }
        .alert(isPresented: $showValidationError) {
            Alert(
                title: Text("Validation Error"),
                message: Text(validationErrorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .confirmationDialog("Are you sure you want to save changes?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Save", role: .destructive) {
                saveProfileChanges()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    // Validate Inputs
    private func validateInputs() -> Bool {
        if userProfile.userEmail.isEmpty || !userProfile.userEmail.contains("@") {
            validationErrorMessage = "Please enter a valid email address."
            return false
        }
        if userProfile.walletAddress.isEmpty {
            validationErrorMessage = "Wallet address cannot be empty."
            return false
        }
        return true
    }
    
    // Save Profile Changes
    private func saveProfileChanges() {
        // Save logic here (e.g., update database or API)
        print("Profile saved successfully!")
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}

// QR Code View
struct QRCodeView: View {
    var walletAddress: String
    
    var body: some View {
        VStack {
            Text("Wallet Address QR Code")
                .font(.headline)
            Image(uiImage: generateQRCode(from: walletAddress))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .padding()
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let data = string.data(using: .ascii)
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let output = filter.outputImage!.transformed(by: transform)
        return UIImage(ciImage: output)
    }
}

#Preview {
    ProfileSettingsView(userProfile: .constant(UserProfile(
        userName: "Aren Musayelyan",
        userEmail: "aren.musayelyan555@gmail.com",
        walletAddress: "05da34358247ae33f8a0506f6d118a19ec08f2b9966823d951ab874d4883ec6a"
    )))
}

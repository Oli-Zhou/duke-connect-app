////
////  PickablePhotoView.swift
////  xincheng
////
////  Created by xz353 on 10/6/23.
////
//
//import PhotosUI
//import SwiftUI
//
////Code of PhotosPicker adopted from https://www.youtube.com/watch?v=crULPMS7Uxs
//struct PickablePhotoView: View {
//    //@EnvironmentObject var modelData: DataModel
//    //@Binding var picture: String
//    @EnvironmentObject var user: User
//    @State private var selectedPhotos: [PhotosPickerItem] = []
//    @State private var photoData: Data?
//    @State private var myerrorMsg: String = ""
//    @State private var showError: Bool = false
//
//    var body: some View {
//        VStack {
//            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1, matching: .images) {
//                if let data = photoData, let uiimage = UIImage(data: data) {
//                    singleImage(size: 180)
//                }
//                else {
//                    singleImage(size: 180)
//                }
//            }
//            .overlay(alignment: .bottom) {
//                Circle()
//                    .trim(from: 0, to: 0.30)
//                    .rotation(.degrees(35))
//                    .opacity(0.8)
//                    .foregroundColor(Color.gray)
//                Image(systemName: "photo.stack")
//                    .offset(CGSize(width: 0, height: 70))
//            }
//        }
//        .onChange(of: selectedPhotos) {
//            guard let item = selectedPhotos.first else { return }
//            item.loadTransferable(type: Data.self) { result in  //onComplete
//                switch result {
//                    case .success(let data):
//                        photoData = data
//                        update_picture()
//                    case .failure(let error):
//                        print("failure: \(error)")
//                        showError = true
//                        myerrorMsg = "\(error)"
//                }
//            }
//        }
//        .alert(isPresented: $showError) {
//            Alert(
//                title: Text("Cannot load Photo: \(myerrorMsg)"),
//                dismissButton: .default(Text("ok"))
//            )
//        }
//        .onAppear {
//            photoData = Data(base64Encoded: user.picture ?? "")
//        }
//    }
//
//    private func update_picture() {
//        if let data = photoData, let uiimage = UIImage(data: data) {
//            if let compressedData = jpegImage(
//                image: uiimage,
//                maxSize: 500000,
//                minSize: 0,
//                times: 10
//            ) {
//                user.picture = compressedData.base64EncodedString()
//                print("\(String(describing: user.picture))")
//                updateUserAvatar(
//                    UserDTO(name: user.userid, avatar: user.picture)
//                ) { res, error in
//                    if !res {
//                        DispatchQueue.main.async {
//                            showError = true
//                            myerrorMsg = "Upload avatar to server failed."
//                        }
//                    }
//                    else {
//                        print("upload avatar to server succeeded!")
//                    }
//                }
//                print("compress successfully!")
//            }
//            else {
//                showError = true
//                myerrorMsg = "Cannot compress this Image to less than 500kB!"
//                photoData = nil
//            }
//        }
//    }
//}
//
//#Preview {
//    PickablePhotoView()
//        .environmentObject(User())
//}

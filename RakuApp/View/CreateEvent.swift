//
////
////  LearnView.swift
////  RakuApp
////
////  Created by Surya on 22/05/25.
////
//import SwiftUI
//import PhotosUI
//
//struct LearnView: View {
//    @StateObject private var viewModel = GripViewModel()
//    @State private var photoItem: PhotosPickerItem?
//
//    var body: some View {
//        VStack(spacing: 20) {
//            if let image = viewModel.selectedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 300)
//            } else {
//                Rectangle()
//                    .fill(Color.gray.opacity(0.2))
//                    .frame(height: 300)
//                    .overlay(Text("Select an image").foregroundColor(.gray))
//            }
//
//            PhotosPicker(selection: $photoItem, matching: .images, photoLibrary: .shared()) {
//                Text("Pick Image")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//
//            Button("Predict") {
//                viewModel.classifyImage()
//            }
//            .disabled(viewModel.selectedImage == nil)
//            .buttonStyle(.borderedProminent)
//
//            Text(viewModel.classLabel)
//                .font(.title2)
//                .padding()
//
//            Spacer()
//        }
//        .navigationTitle("Grip Check")
//        .padding()
//        .onChange(of: photoItem) { newItem in
//            Task {
//                if let data = try? await newItem?.loadTransferable(type: Data.self),
//                   let uiImage = UIImage(data: data) {
//                    viewModel.selectedImage = uiImage
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    LearnView()
//}

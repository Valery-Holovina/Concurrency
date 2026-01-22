//
//  PhotosPickerLearn.swift
//  Concurrency
//
//  Created by Valery on 22.01.2026.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject{
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil{
        didSet{
            setImage(from: imageSelection)
        }}
    
    
    
    
    @Published private(set) var selectedImages: [UIImage] = []
    @Published var imageSelections: [PhotosPickerItem] = []{
        didSet{
            setImages(from: imageSelections)
        }}
    
    
    
    private func setImage(from selection: PhotosPickerItem?){
        guard let selection else{return}
        
        Task{
            if let data = try? await selection.loadTransferable(type: Data.self){
                if let uiImage = UIImage(data: data){
                    selectedImage = uiImage
                    return
                }
            }
        }
    }
    
    
    
    private func setImages(from selections: [PhotosPickerItem]){
        
        
        Task{
            var images: [UIImage] = []
            for selection in selections{
                if let data = try? await selection.loadTransferable(type: Data.self){
                    if let uiImage = UIImage(data: data){
                        images.append(uiImage)
            
                    }
                }
            }
            selectedImages = images
        }
    }
}

struct PhotosPickerLearn: View {
    
    @StateObject private var vm = PhotoPickerViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            Text("hello")
            
            if let image = vm.selectedImage{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            PhotosPicker(selection: $vm.imageSelection, matching: .images) {
                Text("Open photo picker")
                    .foregroundStyle(.red)
            }
            if !vm.selectedImages.isEmpty{
                ScrollView(.horizontal){
                    HStack{
                        ForEach(vm.selectedImages, id: \.self) { img in
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                }
            }
            PhotosPicker(selection: $vm.imageSelections, matching: .images) {
                Text("Open photos picker")
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    PhotosPickerLearn()
}

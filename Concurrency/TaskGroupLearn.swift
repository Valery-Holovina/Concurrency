//
//  TaskGroupLearn.swift
//  Concurrency
//
//  Created by Valery on 26.11.2025.
//

import SwiftUI


class TaskGroupDataManager{
    
 

    func fetchImageWithAsyncLet() async throws -> [UIImage]{
        async let image1 = fetchImage(urlString:  "https://picsum.photos/200")
        async let image2 = fetchImage(urlString:  "https://picsum.photos/200")
        async let image3 = fetchImage(urlString:  "https://picsum.photos/200")
        async let image4 = fetchImage(urlString:  "https://picsum.photos/200")
        
        let (img1, img2, img3, img4) = await (try image1, try image2, try image3, try image4)
        return [img1,img2,img3,img4]
    }
    
    
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage]{
        return try await withThrowingTaskGroup(of: UIImage.self) { group in
            var images : [UIImage] = []
            
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/200")
            }
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/200")
            }
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/200")
            }
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/200")
            }
            
            
            for try await image in group{
                images.append(image)
            }
            
            
            
            return images
        }
    }
    
    
     
    private func fetchImage(urlString: String) async throws -> UIImage{
        guard let url = URL(string: urlString) else{
            throw URLError(.badURL)
        }
        
        do {
            let (data,_) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data){
                return image
            }else{
                throw URLError(.badURL)
            }
            
           
            
        } catch  {
            throw error
        }
    }

}



@Observable class TaskGroupViewModel{
    var images: [UIImage] = []
    
    let manager = TaskGroupDataManager()
    
    
    func getImages() async{
        if let images = try? await manager.fetchImagesWithTaskGroup(){
            self.images.append(contentsOf: images)
        }
    }
}





struct TaskGroupLearn: View {
    @State private var vm = TaskGroupViewModel()
    
    let col = [GridItem(.flexible()), GridItem(.flexible())]
  
    
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVGrid(columns: col) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group 🌷")
            .task {
                await vm.getImages()
            }
        }
    }
}

#Preview {
    TaskGroupLearn()
}

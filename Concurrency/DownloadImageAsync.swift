//
//  DownloadImageAsync.swift
//  Concurrency
//
//  Created by Valery on 18.11.2025.
//

import SwiftUI


class DownloadImageLoader{
    
    let url = URL(string: "https://picsum.photos/200")!
    
    
    func handleRwsponse(data: Data?, response: URLResponse?) -> UIImage?{
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else{
            
            return nil
        }
        return image
    }
    
    
    //-------------- Escaping-------
    //func that returns void
    func downloadWithEscaping(complitionHandler: @escaping(_ image: UIImage?, _ error: Error?) -> Void){
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleRwsponse(data: data, response: response)
            complitionHandler(image,error)
        }
        .resume()
    }
    
    
    
    
    
    
    
    
    
    
    
}


class DownloadImageAsyncViewModel: ObservableObject{
    
    @Published var image: UIImage? = nil
    let loader = DownloadImageLoader()
    
    func fetchImage(){
        loader.downloadWithEscaping { [weak self] image, error in
            DispatchQueue.main.async {
                self?.image = image
            }
               
            
        }
    }
}

struct DownloadImageAsync: View {
    
    @StateObject private var vm = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack{
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear{
            vm.fetchImage()
        }
    }
}

#Preview {
    DownloadImageAsync()
}

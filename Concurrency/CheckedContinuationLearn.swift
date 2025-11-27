//
//  CheckedContinuationLearn.swift
//  Concurrency
//
//  Created by Valery on 27.11.2025.
//

import SwiftUI



class CheckedContinuationNetworkManager{
    func getData(url: URL) async throws -> Data{
        do {
            let (data,_) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch  {
            throw error
        }
    }
    
    
    func getData2(url: URL) async throws -> Data{
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    continuation.resume(returning: data) //must resume only once
                }else if let error =  error{
                    continuation.resume(throwing: error)
                }else{
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    
    func getHeartImageFromDataBase(completionHandler: @escaping(_ image: UIImage) -> ()){
        DispatchQueue.main.asyncAfter(deadline: .now()+5){
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    
    func getHeartImageFromDataBase2() async throws -> UIImage{
        return await withCheckedContinuation { continuation in
            getHeartImageFromDataBase { image in
                continuation.resume(returning: image)
            }
        }
    }
}


@Observable class CheckedContinuationViewModel{
    
    var imaage : UIImage? = nil
    let manager = CheckedContinuationNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else {return}
        
        do {
            let data = try await manager.getData2(url: url)
            if let image = UIImage(data: data){
                await MainActor.run {
                    self.imaage = image
                }
            }
        } catch  {
            print(error)
        }
    }
    
    func getHeartImage() async {
//        manager.getHeartImageFromDataBase {[weak self] image in
//            self?.imaage = image
//        }
        
        do {
            self.imaage = try await manager.getHeartImageFromDataBase2()
        } catch {
            print(error)
        }

        
    }
}




struct CheckedContinuationLearn: View {
    
    @State private var vm = CheckedContinuationViewModel()
    
    var body: some View {
        ZStack{
            if let image = vm.imaage{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
//            await vm.getImage()
            await vm.getHeartImage()
        }
    }
}

#Preview {
    CheckedContinuationLearn()
}

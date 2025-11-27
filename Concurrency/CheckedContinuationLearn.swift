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
}


@Observable class CheckedContinuationViewModel{
    
    var imaage : UIImage? = nil
    let manager = CheckedContinuationNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else {return}
        
        do {
            let data = try await manager.getData(url: url)
            if let image = UIImage(data: data){
                await MainActor.run {
                    self.imaage = image
                }
            }
        } catch  {
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
            await vm.getImage()
        }
    }
}

#Preview {
    CheckedContinuationLearn()
}

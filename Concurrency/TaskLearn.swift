//
//  TaskLearn.swift
//  Concurrency
//
//  Created by Valery on 20.11.2025.
//

import SwiftUI


@Observable class TaskLearnViewModel{
    
    var image : UIImage? = nil
    
    
    func fetchImgae() async{
        do {
            
            guard let url = URL(string: "https://picsum.photos/200") else {return}
            let (data,_) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = UIImage(data: data)
            self.image = image
        } catch  {
            print(error.localizedDescription)
        }
    }
}

struct TaskLearn: View {
    
    private var vm = TaskLearnViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear{
            Task{
                await vm.fetchImgae()
            }
        }
    }
}

#Preview {
    TaskLearn()
}

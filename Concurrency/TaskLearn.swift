//
//  TaskLearn.swift
//  Concurrency
//
//  Created by Valery on 20.11.2025.
//

import SwiftUI


@Observable class TaskLearnViewModel{
    
    var image : UIImage? = nil
    var image2 : UIImage? = nil
    
    func fetchImgae() async{
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            
            guard let url = URL(string: "https://picsum.photos/200") else {return}
            let (data,_) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = UIImage(data: data)
            await MainActor.run {
                self.image = image
            }
          
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
    
    func fetchImgae2() async{
        do {
            
            guard let url = URL(string: "https://picsum.photos/200") else {return}
            let (data,_) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = UIImage(data: data)
            await MainActor.run {
                self.image2 = image
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
}


struct TaskLearnHomeView: View{
    var body: some View{
        NavigationStack{
            ZStack{
                NavigationLink {
                    TaskLearn()
                } label: {
                    Text("Click me")
                }

            }
        }
    }
}

struct TaskLearn: View {
    
    private var vm = TaskLearnViewModel()
//    @State private var  fetchTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image2 = vm.image2{
                Image(uiImage: image2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }

        }
        // new version
        .task {
            await vm.fetchImgae()
//            try Task.checkCancellation() (not here but in tasks  that are long (loops))
        }
        
        // old version
//        .onDisappear{
//            fetchTask?.cancel() // to cancel task
//        }
//        .onAppear{
//            fetchTask = Task{
////                await Task.yield() // like sleep (to give other tasks to do first)
//                await vm.fetchImgae()
//             
//            }
        
        
        
        
        
        
//            Task{
//                await vm.fetchImgae2()
//            }
            
            //PRIORITY
        // 1. high and userInitiated
        // 2. medium
        // 3. low
        // 4. utitlity
        // 5. background
        }
    }
//}

#Preview {
    TaskLearn()
}

//
//  GlobalActorLearn.swift
//  Concurrency
//
//  Created by Valery on 05.12.2025.
//

import SwiftUI

//or just struct instead of final class(you can not inherit from that class)
@globalActor final class MyFirstGlobalActor{
    
    static var shared = MyNewDataManager()
}

actor MyNewDataManager{
    func getDataFromDatabase() -> [String]{
        return ["One", "Two", "Three", "Four", "Five", "Six"]
    }
}

@Observable class GlobalActorViewModel{
    // if there are many dataArrays we mark class as @MainActor not var
    @MainActor var dataArray: [String] = [] // updates on mainActor
    let manager = MyFirstGlobalActor.shared
    
    //running on the actor

//    @MainActor // main thread
    @MyFirstGlobalActor
    func getData(){
        
        //HEAVY COMPLEX METHODS
        Task{
            
            let data = await manager.getDataFromDatabase()
            await MainActor.run {
                self.dataArray = data
            }
      
        }
    }
}


struct GlobalActorLearn: View {
    
    @State private var vm = GlobalActorViewModel()
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(vm.dataArray, id: \.self) { text in
                    Text(text)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.getData()
        }
    }
}

#Preview {
    GlobalActorLearn()
}

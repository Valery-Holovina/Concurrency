//
//  StrongWeakReference.swift
//  Concurrency
//
//  Created by Valery on 18.12.2025.
//

import SwiftUI


final class StrongSelfDataService{
    func getData() async -> String{
        "Updated data"
    }
}

@Observable final class StrongSelfViewModel{
    var data: String = "Some title"
    let dataService = StrongSelfDataService()
    
    private var someTask: Task<Void,Never>? = nil
    private var myTasks: [Task<Void,Never>] = []
    
    func cancelTasks(){
        someTask?.cancel()
        someTask = nil
        
        myTasks.forEach ({$0.cancel()})
        myTasks = []
    }
    
    
    //This implies a strong reference...
    func updateData(){
        Task{
            data = await dataService.getData()
        }
    }
    
    //This is a strong reference...
    func updateData2(){
        Task{
            self.data = await dataService.getData()
        }
    }
    
    //This is a strong reference...
    func updateData3(){
        Task{ [self] in
            self.data = await dataService.getData()
        }
    }
    
    //This is a weak reference...
    func updateData4(){
        Task{ [weak self] in
            if let data = await self?.dataService.getData(){
                self?.data = data
            }
        }
    }
    
    //We do not need to manage weak/strong
    // We can manage the Task!
    func updateData5(){
        someTask = Task{
            self.data = await dataService.getData()
        }
    }
    
    
    func updateData6(){
       let task1 = Task{
            self.data = await dataService.getData()
        }
        myTasks.append(task1)
        let task2 = Task{
             self.data = await dataService.getData()
         }
        myTasks.append(task2)
    }
    
    
    //We purposly do not cancel tasks to keep strong references
    func updateData7(){
         Task{
             self.data = await self.dataService.getData()
        }
        
        Task.detached{
            self.data = await self.dataService.getData()
       }
        
    }
    
    func updateData8() async{
       
            self.data = await dataService.getData()
    }
    
}

struct StrongWeakReference: View {
    @State private var  vm = StrongSelfViewModel()
    
    var body: some View {
        Text(vm.data)
            .onAppear {
                vm.updateData()
            }
            .onDisappear {
                vm.cancelTasks()
            }
            .task {
                await vm.updateData8()
            }
            
    }
}

#Preview {
    StrongWeakReference()
}

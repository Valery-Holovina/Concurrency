//
//  MVVMLeasson.swift
//  Concurrency
//
//  Created by Valery on 22.12.2025.
//

import SwiftUI


final class MyMannagerClass{
    
    func getData() async throws -> String{
        return "Some data"
    }
}

actor MyManagerActor{
    func getData() async throws -> String{
        return "Some data"
    }
}

@MainActor
@Observable final class MVVMLessonViewModel{
    
    let managerClass = MyMannagerClass()
    let managerActor = MyManagerActor()
    
    private(set) var myData: String = "Starting text"
    private var tasks: [Task<Void,Never>] = []
    
    
    
    func cancelTasks(){
        tasks.forEach({$0.cancel()})
        tasks = []
    }
    
//    @MainActor
    func onCallToActionButtonPressed(){
        let task = Task{
            do{
//                myData = try await managerClass.getData()
                myData = try await managerActor.getData()
            }catch{
                print(error)
            }
        }
        tasks.append(task)
    }
    
}

struct MVVMLeasson: View {
    
    @State private var vm = MVVMLessonViewModel()
    
    var body: some View {
        VStack {
            Button(vm.myData) {
                vm.onCallToActionButtonPressed()
            }
            .onDisappear {
                
            }
        }
    }
}

#Preview {
    MVVMLeasson()
}

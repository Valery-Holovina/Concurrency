//
//  AsyncAwaitLearn.swift
//  Concurrency
//
//  Created by Valery on 19.11.2025.
//

import SwiftUI

@Observable class AsyncAwaitViewModel{
    
    var dataArray: [String] = []
    
    func addTitle1(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.dataArray.append("Title1 : \(Thread.current)")
        }
     
    }
    
    func addTitle2(){
        DispatchQueue.global().asyncAfter(deadline: .now() + 2){
            let title = "Title2: \(Thread.current)"
            DispatchQueue.main.async{
                self.dataArray.append(title)
            }
                
        }
       
     
    }
    
    
    
    func addAuthor1() async{
        //main thread
        let author1 = "Author1: \(Thread.current)"
        self.dataArray.append(author1)
        
        
        try? await Task.sleep(nanoseconds: 2_000_000_000) // go on background thread
        
        let author2 =  "Author2: \(Thread.current)"
        await MainActor.run { // go on main thread
            self.dataArray.append(author2)
        }
        await addSomething()
        
        
    }

    func addSomething() async{
        try? await Task.sleep(nanoseconds: 2000000000)
        let sm =  "sm: \(Thread.current)"
        await MainActor.run { // go on main thread
            self.dataArray.append(sm)
        }
    }
    
    
}

struct AsyncAwaitLearn: View {
    
    @State private var vm = AsyncAwaitViewModel()
    
    var body: some View {
        List{
            ForEach(vm.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear{
            Task{
                await vm.addAuthor1()
            
                
                let finalText = "Final \(Thread.current)"
                vm.dataArray.append(finalText)
            }
//            vm.addTitle1()
//            vm.addTitle2()
        }
    }
}

#Preview {
    AsyncAwaitLearn()
}

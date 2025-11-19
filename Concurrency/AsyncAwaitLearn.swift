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
            vm.addTitle1()
            vm.addTitle2()
        }
    }
}

#Preview {
    AsyncAwaitLearn()
}

//
//  AsyncStreamLearn.swift
//  Concurrency
//
//  Created by Valery on 26.01.2026.
//

import SwiftUI


class AsyncStreamDataManager{
    
    
    func getAsyncStream() -> AsyncThrowingStream<Int, Error>{
        AsyncThrowingStream{ [weak self] continuation in
            self?.getFakeData { value in
                continuation.yield(value)
            } onFinish: { error in
                if let error{
                    continuation.finish(throwing: error)
                }else{
                    continuation.finish()
                }
            }

        }
    }
    
    func getFakeData(completion: @escaping(_ value: Int) ->(),
                     onFinish: @escaping(_ error: Error?) ->()
    ) {
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10]
        
        for item in items{
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item), execute: {
                completion(item)
                if item == items.last{
                    onFinish(nil)
                }
            })
        }
    }
}

@MainActor
@Observable final class AsyncStreamVm{
    let manager = AsyncStreamDataManager()
    private(set) var currentNum : Int = 0
    
    func onViewAppear(){
//        manager.getFakeData { [weak self] value in
//            self?.currentNum = value
//        }
        
        let task = Task{
            do{
                //drops first two
                for try await value in manager.getAsyncStream().dropFirst(2){
                    currentNum = value
                }}catch{
                    print(error)
                }
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            task.cancel() // cancels UI only, not whole process
            
        })
        }
    }


struct AsyncStreamLearn: View {
    
    @State private var vm = AsyncStreamVm()
    
    var body: some View {
        Text("\(vm.currentNum)")
            .onAppear {
                vm.onViewAppear()
            }
    }
}

#Preview {
    AsyncStreamLearn()
}

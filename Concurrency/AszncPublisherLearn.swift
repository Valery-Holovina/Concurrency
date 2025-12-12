//
//  AszncPublisherLearn.swift
//  Concurrency
//
//  Created by Valery on 12.12.2025.
//

import SwiftUI


actor AsyncPublisherDataManager{
    
    @Published var myData: [String] = []
    
    func addDtata() async{
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Mango")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
    }
}

class AsyncPublisherLearnViewModel: ObservableObject{
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    
    init() {
        addSubscribers()
    }
    
    
    private func addSubscribers() {
        Task{
            for await value in await manager.$myData.values{
                await MainActor.run {
                    self.dataArray = value
                }
            }
        }
    }
    
    func start() async{
        await manager.addDtata()
    }
}

struct AszncPublisherLearn: View {
    
    @StateObject private var vm = AsyncPublisherLearnViewModel()
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(vm.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.start()
        }
    }
}

#Preview {
    AszncPublisherLearn()
}

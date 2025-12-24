//
//  RefreshableLearn.swift
//  Concurrency
//
//  Created by Valery on 24.12.2025.
//

import SwiftUI


final class RefreshableLearnDataService{
    func getData()async throws -> [String]{
        try? await Task.sleep(nanoseconds: 5000000000)
        return ["Apple", "Orange", "Banana"].shuffled()
    }
}

@MainActor
@Observable final class RefreshableLearnViewModel{
    
    private(set) var items: [String] = []
    let manager = RefreshableLearnDataService()
    
    func loadData() async {
        
            do{
                items = try await manager.getData()
            }catch{
                print(error)
            }
    }
    
}

struct RefreshableLearn: View {
    
    @State private var vm = RefreshableLearnViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    ForEach(vm.items,id: \.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable{
                await vm.loadData()
            }
            .navigationTitle("Refreshable")
            .task{
                await vm.loadData()
            }
        }
    }
}

#Preview {
    RefreshableLearn()
}

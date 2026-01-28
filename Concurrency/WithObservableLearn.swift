//
//  WithObservableLearn.swift
//  Concurrency
//
//  Created by Valery on 28.01.2026.
//

import SwiftUI

actor TitleDataBase{
    func getNewTitle() -> String{
        "Some new title"
    }
}



@Observable class ObservableVM{
    
    @ObservationIgnored let database = TitleDataBase()
    @MainActor var title: String = "Starting title"
    
    @MainActor
    func updateTitle() async {
        title = await database.getNewTitle()
        print(Thread.current)
      
    }
    
    // -------------- OR ----------
    
    func updateTitle2() async {
        let title = await database.getNewTitle()
        
        await MainActor.run {
            self.title = title
        }
      
    }
    
    
    func updateTitle3() {
        Task{ @MainActor in
            title = await database.getNewTitle()
        }

      
    }

    
}

struct WithObservableLearn: View {
    @State private var vm = ObservableVM()
    
    var body: some View {
        Text(vm.title)
            .task {
                await vm.updateTitle()
            }
//            .onAppear {
//                vm.updateTitle3()
//            }

    }
}

#Preview {
    WithObservableLearn()
}

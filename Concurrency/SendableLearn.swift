//
//  SendableLearn.swift
//  Concurrency
//
//  Created by Valery on 09.12.2025.
//

import SwiftUI

//Sendable = indicates that given type can be safely used in concurrent code


actor CurrentUserManager{
    
    func updateDatabase(userInfo: String){
        
    }
    
}


struct MyUserInfo: Sendable{
//    let name: String
    var name: String
}

final class MyClassUserInfo: @unchecked Sendable{
    
//    let name: String
    
    // we check ourselves if it is Sendable ( @unchecked Sendable)
   private var name: String
    let lock = DispatchQueue(label: "MyApp.lock") // make thread safe
    
    init(name: String) {
        self.name = name
    }
    
    
    func updateName(name: String){
        lock.async {
            self.name =  name
        }
       
    }
}

@Observable class SendableLearnViewModel{
    let manager = CurrentUserManager()
    
    
    func updateCurrentUserInfo() async{
        
//        let info = "USER INFO" // Sendable by default because value type
//        let info = MyUserInfo(name: "info")
        let info = MyClassUserInfo(name: "info")
        await manager.updateDatabase(userInfo: "\(info)")
    }
}

struct SendableLearn: View {
    
    @State private var vm = SendableLearnViewModel()
    
    var body: some View {
        Text("Hello, World!")
            .task {
                
            }
    }
}

#Preview {
    SendableLearn()
}

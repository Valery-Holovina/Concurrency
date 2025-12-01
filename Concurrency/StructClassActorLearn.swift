//
//  StructClassActorLearn.swift
//  Concurrency
//
//  Created by Valery on 01.12.2025.
//

import SwiftUI

struct StructClassActorLearn: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear{
                runTest()
            }
    }
}

#Preview {
    StructClassActorLearn()
}



struct MyStruct{
    var title: String
}


class MyClass{
    var title: String
    
    init(title: String) {
        self.title = title
    }
}


extension StructClassActorLearn{
    private func runTest(){
        print("test started")
        structTest1()
        divide()
        classTest1()
        
        
        /**
         test started
            STRUCT
         ObjA:  Starting title
         Pass the VALUES of objA to objB
         objB:  Starting title
         objB title changed
         ObjA:  Starting title
         objB:  Second title
         -------------------------
            CLASS
         ObjA:  Starting title
         objB:  Starting title
         Pass the REFERENCE of objA to objB
         objB title changed
         ObjA:  Second title
         objB:  Second title
         */
    }
    
    private func structTest1(){
        let objA = MyStruct(title: "Starting title")
        print("ObjA: ", objA.title)
        
        // we create new obj
        print("Pass the VALUES of objA to objB")
        var objB = objA
        print("objB: ", objB.title)
        
        
        objB.title = "Second title"
        print("objB title changed ")
        print("ObjA: ", objA.title)
        print("objB: ", objB.title)
    }
    
    private func divide(){
        print("-------------------------")
    }
    
    
    private func classTest1(){
        let objA = MyClass(title: "Starting title")
        print("ObjA: ", objA.title)
        
        // we go inside existing obj and change data inside it
        //pointing to the same obj in memory
        print("Pass the REFERENCE of objA to objB")
        let objB = objA
        print("objB: ", objB.title)
        
        objB.title = "Second title"
        print("objB title changed ")
        print("ObjA: ", objA.title)
        print("objB: ", objB.title)
        
        
    }
}

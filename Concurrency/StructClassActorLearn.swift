//
//  StructClassActorLearn.swift
//  Concurrency
//
//  Created by Valery on 01.12.2025.
//






//ARC (Automatic Reference Counting) - for objects in the Heap. To track and manage memory usage, automatically frees up the memory when thos instances are no longer needed
// (Value types are not affected by ARC)
// Every isnatance of a slass has property called Reference Count (if count greater than 0 is kept in memory, otherwise will be removed from memory)


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
    
    
    func updateTitle(newTitle: String){
        title = newTitle
    }
}


extension StructClassActorLearn{
    private func runTest(){
        print("test started")
//        structTest1()
//        divide()
//        classTest1()
        
        
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
        
        //--------------------------------------------
        structTest2()
        divide()
        classTest2()
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




//Immutable struct (everything is going to be (let) inside, do not change)
struct CustomStruct{
    let title: String
    
    
    func updateTitle(newTitle: String)-> CustomStruct{
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct{
    private(set) var title: String // we wnat to set it privatly but get it outside
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String){
        title = newTitle
    }
}

extension StructClassActorLearn{
    private func structTest2(){
        print("struct test2")
        
        var struct1 = MyStruct(title: "title1")
        print("Struct1: ", struct1.title)
        
        struct1.title = "title2"
        print("Struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("Struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4: ", struct4.title)
    }
}





extension StructClassActorLearn{
    private func classTest2(){
        print("class test2")
        
        let class1 = MyClass(title: "tittle1")
        print("Class1:", class1.title)
        
        class1.title = "Title2"
        print("Class1:", class1.title)
        
        let class2 = MyClass(title: "tittle1")
        print("Class2:", class2.title)
        
        class2.updateTitle(newTitle: "Title2")
        print("Class2:", class2.title)
    }
}

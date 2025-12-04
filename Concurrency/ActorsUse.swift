//
//  ActorsUse.swift
//  Concurrency
//
//  Created by Valery on 04.12.2025.
//

import SwiftUI

//  1. What is the problem that the actor are solving?
// 2. How was this problem solved prior to actors?
// 3. Actors can solve the problem!


class MyDataManager{
    
    static let instance = MyDataManager()
    private init(){}
    
    var data: [String] = []
    //old fix
    private let lock = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(completionHandler: @escaping(_ title: String?) -> ()){
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
       
    }
}


actor MyActorDataManager{
    
    static let instance = MyActorDataManager()
    private init(){}
    
    var data: [String] = []
    
    nonisolated let randomText: String = "kskksk"
    
    
    func getRandomData() -> String?{
            self.data.append(UUID().uuidString)
            print(Thread.current)
            return self.data.randomElement()
       
    }
    
    //When we do not want to await
    nonisolated func getSavedData() -> String{
        return "New Data"
    }
}

struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onAppear{
            
            //nonisolated
            let newString =  manager.getSavedData()
            let text = manager.randomText
//            Task{
////                await manager.data
//
//            }
        }
        .onReceive(timer) { _ in
//            DispatchQueue.global(qos: .background).async{
//                
//                manager.getRandomData { title in
//                    if let data = title{
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                       
//                    }
//                }
//             
//            }
            
            
            Task{
                if let data = await manager.getRandomData(){
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
          
        }
    }
}


struct BrowseView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color.yellow.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
//            DispatchQueue.global(qos: .default).async{
//                manager.getRandomData { title in
//                    if let data = title{
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                       
//                    }
//                }
//            }
            
            Task{
                if let data = await manager.getRandomData(){
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        }
    }
}

struct ActorsUse: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Browse", systemImage: "magnifyingglass") {
                BrowseView()
            }
           

        }
    }
}

#Preview {
    ActorsUse()
}

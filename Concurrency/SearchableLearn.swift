//
//  SearchableLearn.swift
//  Concurrency
//
//  Created by Valery on 02.01.2026.
//




// Control + i ( correct formatting )

import SwiftUI
import Combine

struct Restaurant: Identifiable, Hashable{
    let id: String
    let title: String
    let cuisine: CuisineOption
}

enum CuisineOption: String{
    case american, italian, japanese
}


final class RestaurantManager{
    
    func getAllRestaurants() async throws-> [Restaurant]{
        [
            Restaurant(id: "1", title: "Burger Shack", cuisine: .american),
            Restaurant(id: "2", title: "Pasta Palace", cuisine: .italian),
            Restaurant(id: "3", title: "Sushi Heaven", cuisine: .japanese),
            Restaurant(id: "4", title: "Local Market", cuisine: .american),
        ]
    }
}

@MainActor
final class SearchableViewModel: ObservableObject{
    
    @Published private(set) var allRestaurants: [Restaurant] = []
    @Published private(set) var filteredRestaurants: [Restaurant] = []
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    let manager = RestaurantManager()
    
    
    
    init(){
        addSubscribers()
    }
    
    private func addSubscribers(){
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterRestaurants(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterRestaurants(searchText: String){
        guard !searchText.isEmpty else{
            filteredRestaurants = []
            
            return
        }
        let search = searchText.lowercased()
        filteredRestaurants = allRestaurants.filter({ restaurant in
            let titleContainsSearch = restaurant.title.lowercased().contains(search)
            let cuisineContainsSearch = restaurant.cuisine.rawValue.lowercased().contains(search)
            return titleContainsSearch || cuisineContainsSearch
        })
    }
    
    func loadRestaurants() async{
        do {
            allRestaurants = try await manager.getAllRestaurants()
        } catch  {
            print(error)
        }
    }
    
    
}

struct SearchableLearn: View {
    
    @StateObject private var vm = SearchableViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(spacing: 20) {
                    ForEach(vm.isSearching ? vm.filteredRestaurants: vm.allRestaurants) { restaurant in
                        restaurantRow(restaurant: restaurant)
                    }
                }
                .padding()
//                Text("ViewModel is searching: \(vm.isSearching.description)")
//                SearchChildView()
            }
            .searchable(text: $vm.searchText, placement: .automatic, prompt: Text("Search restaurants"))
            
            .navigationTitle("Restaurants")
            .task {
                await vm.loadRestaurants()
            }
        }
    }
    
    private func restaurantRow(restaurant: Restaurant) -> some View{
        VStack(alignment: .leading, spacing: 10) {
            Text(restaurant.title)
                .font(.headline)
            Text(restaurant.cuisine.rawValue.capitalized)
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.black.opacity(0.05))
    }
}

struct SearchChildView: View{
    @Environment(\.isSearching) private var isSearching
    
    var body: some View{
        Text("Child View is searching: \(isSearching.description)")
    }
}

#Preview {
    NavigationStack{
        SearchableLearn()
    }
}

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
    @Published var searchScope: SearchScopeOption = .all
    @Published private(set) var allSearchScopes: [SearchScopeOption] = []
    
    private var cancellables = Set<AnyCancellable>()
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    enum SearchScopeOption: Hashable{
        case all
        case cusine(option: CuisineOption)
        
        
        var title:String{
            switch self {
            case .all:
                return "All"
            case .cusine(option: let option):
                return option.rawValue.capitalized
            }
        }
    }
    
    let manager = RestaurantManager()
    
    
    
    init(){
        addSubscribers()
    }
    
    private func addSubscribers(){
        $searchText
            .combineLatest($searchScope)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText, searchScope in
                self?.filterRestaurants(searchText: searchText, searchScope: searchScope)
            }
            .store(in: &cancellables)
    }
    
    private func filterRestaurants(searchText: String, searchScope: SearchScopeOption){
        guard !searchText.isEmpty else{
            filteredRestaurants = []
            self.searchScope = .all
            
            return
        }
        
        //Filter on search scope
        var restaurantsInScope = allRestaurants
        switch searchScope {
        case .all:
            break
        case .cusine(option: let option):
            restaurantsInScope = allRestaurants.filter({restaurant in
                return restaurant.cuisine == option
            })
        }
        
        //Filter on searchText
        let search = searchText.lowercased()
        filteredRestaurants = restaurantsInScope.filter({ restaurant in
            let titleContainsSearch = restaurant.title.lowercased().contains(search)
            let cuisineContainsSearch = restaurant.cuisine.rawValue.lowercased().contains(search)
            return titleContainsSearch || cuisineContainsSearch
        })
    }
    
    func loadRestaurants() async{
        do {
            allRestaurants = try await manager.getAllRestaurants()
            
            let allCusines = Set(allRestaurants.map{$0.cuisine})
            allSearchScopes = [.all] + allCusines.map({option in
                SearchScopeOption.cusine(option: option)
            })
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
            .searchScopes($vm.searchScope, scopes: {
                ForEach(vm.allSearchScopes, id: \.self) { scope in
                    Text(scope.title)
                        .tag(scope)
                }
            })
            
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

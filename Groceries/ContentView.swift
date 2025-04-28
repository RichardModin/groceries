import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GroceryListView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Groceries")
                }
            
            MealsView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Meals")
                }
            
            StoresView()
                .tabItem {
                    Image(systemName: "building.2")
                    Text("Stores")
                }
            
            GroupsView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Groups")
                }
        }
    }
}

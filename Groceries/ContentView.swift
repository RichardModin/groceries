import SwiftUI

struct ContentView: View {
    @StateObject private var groceryList = GroceryList()
    @StateObject private var stores = Stores()
    @StateObject private var groups = Groups()

    var body: some View {
        TabView {
            GroceryListView(groceryList: groceryList, stores: stores, groups: groups)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Groceries")
                }
            
            MealsView(groceryList: groceryList)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Meals")
                }
            
            StoresView(stores: stores)
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

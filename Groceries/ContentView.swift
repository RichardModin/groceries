import SwiftUI

struct ContentView: View {
    @StateObject private var groceryList = GroceryList()

    var body: some View {
        TabView {
            GroceryListView(groceryList: groceryList)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Groceries")
                }
            
            MealsView(groceryList: groceryList)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Meals")
                }
        }
    }
}

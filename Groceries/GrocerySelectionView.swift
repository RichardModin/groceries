import SwiftUI

struct GrocerySelectionView: View {
    @Binding var selectedGroceries: [GroceryItem]
    @State private var groceryList: [GroceryItem] = []

    var body: some View {
        NavigationView {
            List(groceryList) { grocery in
                Button(action: {
                    if !selectedGroceries.contains(grocery) {
                        selectedGroceries.append(grocery)
                    }
                }) {
                    HStack {
                        Text(grocery.name)
                        Spacer()
                        if selectedGroceries.contains(grocery) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("Select Groceries")
            .onAppear {
                loadGroceryList()
            }
        }
    }

    private func loadGroceryList() {
        if let data = UserDefaults.standard.data(forKey: "GroceryList"),
           let decoded = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            groceryList = decoded
        }
    }
}

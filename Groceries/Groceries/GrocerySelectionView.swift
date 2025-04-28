import SwiftUI

struct GrocerySelectionView: View {
    @Binding var selectedGroceries: [GroceryItem]
    @State private var groceryList: [GroceryItem] = []

    var body: some View {
        NavigationView {
            List(groceryList) { grocery in
                Button(action: {
                    if let index = selectedGroceries.firstIndex(where: { $0.id == grocery.id }) {
                        selectedGroceries.remove(at: index)
                    } else {
                        selectedGroceries.append(grocery)
                    }
                }) {
                    HStack {
                        Text(grocery.name)
                        Spacer()
                        if selectedGroceries.contains(where: { $0.id == grocery.id }) {
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

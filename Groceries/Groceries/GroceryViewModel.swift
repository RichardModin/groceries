import SwiftUI

class GroceryViewModel: ObservableObject {
    @Published var groceryList: [GroceryItem] = []
    @Published var stores: [String] = []
    @Published var groups: [String] = []
    @Published var isPresentingAddForm = false
    @Published var isEditing = false
    @Published var locked = false
    @Published var selectedStore = "All"
    @Published var showOnlyNeeds = false
    @Published var isPresentingFilters = false
    @Published var showInCartOnly = false

    var groupedGroceryList: [String: [GroceryItem]] {
        let filteredList = selectedStore == "All" ? groceryList :
            groceryList.filter { $0.store == selectedStore }
        let needsFilteredList = showOnlyNeeds ? filteredList.filter { $0.need } : filteredList
        let finalList = showInCartOnly ? needsFilteredList.filter { !$0.inCart } : needsFilteredList
        return Dictionary(grouping: finalList, by: { $0.group })
    }

    var groceryStores: [String] {
        let uniqueStores = Set(groceryList.map { $0.store })
        return uniqueStores.sorted()
    }

    func deleteGrocery(at offsets: IndexSet, in group: String) {
        if let itemsInGroup = groupedGroceryList[group] {
            for index in offsets {
                if let itemIndex = groceryList.firstIndex(of: itemsInGroup[index]) {
                    groceryList.remove(at: itemIndex)
                }
            }
            saveGroceryList()
        }
    }

    func saveGroceryList() {
        if let encoded = try? JSONEncoder().encode(groceryList) {
            UserDefaults.standard.set(encoded, forKey: "GroceryList")
        }
    }

    func loadGroceryList() {
        if let data = UserDefaults.standard.data(forKey: "GroceryList"),
           let decoded = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            groceryList = decoded
        }
    }

    func loadStores() {
        if let savedStores = UserDefaults.standard.array(forKey: "SavedStores") as? [String] {
            stores = savedStores
        }
    }

    func loadGroups() {
        if let savedGroups = UserDefaults.standard.array(forKey: "SavedGroups") as? [String] {
            groups = savedGroups
        }
    }

    func uncheckAll() {
        for index in groceryList.indices {
            groceryList[index].need = false
            groceryList[index].inCart = false
        }
        saveGroceryList()
    }
}

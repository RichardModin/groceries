import SwiftUI

struct GroceryListView: View {
    @ObservedObject var groceryList: GroceryList
    @ObservedObject var stores: Stores
    @ObservedObject var groups: Groups
    @State private var isPresentingAddForm = false
    @State private var isEditing = false
    @State private var locked = false
    @State private var selectedStore = "All"
    @State private var showOnlyNeeds = false
    @State private var isPresentingFilters = false
    @State private var showInCartOnly = false

    var groupedGroceryList: [String: [GroceryItem]] {
        let filteredList = selectedStore == "All" ? groceryList.items :
            groceryList.items.filter { $0.store == selectedStore }
        let needsFilteredList = showOnlyNeeds ? filteredList.filter { $0.need } : filteredList
        let finalList = showInCartOnly ? needsFilteredList.filter { !$0.inCart } : needsFilteredList
        return Dictionary(grouping: finalList, by: { $0.group })
    }
    
    var groceryStores: [String] {
        let uniqueStores = Set(groceryList.items.map { $0.store })
        return uniqueStores.sorted()
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(groupedGroceryList.keys.sorted(), id: \.self) { group in
                            Section(header: Text(group)) {
                                ForEach(groupedGroceryList[group] ?? []) { item in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                            Text(item.store)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Button(action: {
                                            if !locked {
                                                if let index = groceryList.items.firstIndex(of: item) {
                                                    groceryList.items[index].need.toggle()
                                                    saveGroceryList()
                                                }
                                            }
                                        }) {
                                            Image(systemName: item.need ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(item.need ? .green : .gray)
                                        }

                                        if locked && item.need {
                                            Button(action: {
                                                if let index = groceryList.items.firstIndex(of: item) {
                                                    groceryList.items[index].inCart.toggle()
                                                    saveGroceryList()
                                                }
                                            }) {
                                                Image(systemName: item.inCart ? "cart.fill" : "cart")
                                                    .foregroundColor(item.inCart ? .blue : .gray)
                                            }
                                        }
                                    }
                                    .foregroundColor(item.inCart ? .gray : .primary)
                                }
                                .onDelete { offsets in
                                    deleteGrocery(at: offsets, in: group)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Groceries")
                .navigationBarItems(
                    leading: Button("Filters") {
                        isPresentingFilters = true
                    },
                    trailing: Button(action: {
                        isPresentingAddForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                )
                .sheet(isPresented: $isPresentingAddForm) {
                    AddGroceryView(stores: stores, groups: groups) { newItem in
                        groceryList.items.append(newItem)
                        saveGroceryList()
                    }
                }
                .onAppear {
                    loadGroceryList()
                    loadStores()
                    loadGroups()
                }
            }
            .sheet(isPresented: $isPresentingFilters) {
                NavigationView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Store")
                                    .font(.subheadline)
                                    .bold()
                                Spacer()
                                Picker("Filter by store", selection: $selectedStore) {
                                    Text("All").tag("All")
                                    ForEach(groceryStores, id: \.self) { store in
                                        Text(store).tag(store)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        )

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Spacer()
                                Toggle(isOn: $showOnlyNeeds) {
                                    Text("Needs Only")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .toggleStyle(SwitchToggleStyle())
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        )

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Spacer()
                                Toggle(isOn: $locked) {
                                    Text("Locked")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .toggleStyle(SwitchToggleStyle())
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        )

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Spacer()
                                Toggle(isOn: $showInCartOnly) {
                                    Text("Hide In Cart Items")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .toggleStyle(SwitchToggleStyle())
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        )

                        HStack {
                            Spacer()
                            Button(action: {
                                for index in groceryList.items.indices {
                                    groceryList.items[index].need = false
                                    groceryList.items[index].inCart = false
                                }
                                saveGroceryList()
                            }) {
                                Text("Uncheck All")
                                    .foregroundColor(.blue)
                            }
                            .padding(.top)
                        }

                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Filters")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }

    private func deleteGrocery(at offsets: IndexSet, in group: String) {
        if let itemsInGroup = groupedGroceryList[group] {
            for index in offsets {
                if let itemIndex = groceryList.items.firstIndex(of: itemsInGroup[index]) {
                    groceryList.items.remove(at: itemIndex)
                }
            }
            saveGroceryList()
        }
    }

    private func saveGroceryList() {
        if let encoded = try? JSONEncoder().encode(groceryList.items) {
            UserDefaults.standard.set(encoded, forKey: "GroceryList")
        }
    }

    private func loadGroceryList() {
        if let data = UserDefaults.standard.data(forKey: "GroceryList"),
           let decoded = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            groceryList.items = decoded
        }
    }
    
    private func loadStores() {
        if let savedStores = UserDefaults.standard.array(forKey: "SavedStores") as? [String] {
            stores.storeList = savedStores
        }
    }

    private func loadGroups() {
        if let savedGroups = UserDefaults.standard.array(forKey: "SavedGroups") as? [String] {
            groups.groupList = savedGroups
        }
    }
}

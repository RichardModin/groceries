import SwiftUI

struct GroceryListView: View {
    @ObservedObject var groceryList: GroceryList
    @ObservedObject var stores: Stores
    @ObservedObject var groups: Groups
    @State private var isPresentingAddForm = false
    @State private var isEditing = false
    @State private var selectedStore = "All"
    @State private var showOnlyNeeds = false
    @State private var isPresentingFilters = false

    var groupedGroceryList: [String: [GroceryItem]] {
        let filteredList = selectedStore == "All" ? groceryList.items :
            groceryList.items.filter { $0.store == selectedStore }
        let finalList = showOnlyNeeds ? filteredList.filter { $0.need } : filteredList
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
                                        if isEditing {
                                            Button(action: {
                                                if let index = groceryList.items.firstIndex(of: item) {
                                                    groceryList.items.remove(at: index)
                                                    saveGroceryList()
                                                }
                                            }) {
                                                Image(systemName: "minus.circle")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                            Text(item.store)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Button(action: {
                                            if let index = groceryList.items.firstIndex(of: item) {
                                                groceryList.items[index].need.toggle()
                                                saveGroceryList()
                                            }
                                        }) {
                                            Image(systemName: item.need ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(item.need ? .green : .gray)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Groceries")
                .navigationBarItems(
                    leading: Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit")
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
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresentingFilters = true
                        }) {
                            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresentingFilters) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Filters")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom)
                    
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
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1) // Lighter gray border
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Larger, darker shadow
                    )
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Options")
                                .font(.subheadline)
                                .bold()
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
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1) // Lighter gray border
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Larger, darker shadow
                    )
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            for index in groceryList.items.indices {
                                groceryList.items[index].need = false
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
            }
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

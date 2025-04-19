import SwiftUI

struct GroceryListView: View {
    @ObservedObject var groceryList: GroceryList
    @State private var isPresentingAddForm = false
    @State private var isEditing = false
    @State private var selectedStore = "All"
    @State private var showOnlyNeeds = false
    @State private var isPresentingFilters = false

    let stores = ["All", "SuperStore", "Metro", "Walmart", "PetsMart", "Georges Market"]

    var filteredGroceryList: [GroceryItem] {
        var list = selectedStore == "All" ? groceryList.items :
            groceryList.items.filter { $0.store == selectedStore }
        if showOnlyNeeds {
            list = list.filter { $0.need }
        }
        return list
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(filteredGroceryList) { item in
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
                    AddGroceryView { newItem in
                        groceryList.items.append(newItem)
                        saveGroceryList()
                    }
                }
                .onAppear {
                    loadGroceryList()
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
                        .font(.headline)
                        .padding(.bottom)

                    VStack(alignment: .leading) {
                        Text("Store")
                            .font(.subheadline)
                            .bold()
                        Picker("Filter by store", selection: $selectedStore) {
                            ForEach(stores, id: \.self) { store in
                                Text(store)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    VStack(alignment: .leading) {
                        Text("Options")
                            .font(.subheadline)
                            .bold()
                        Toggle("Needs Only", isOn: $showOnlyNeeds)
                            .toggleStyle(SwitchToggleStyle())
                    }

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
}

import SwiftUI

struct GroceryListView: View {
    @StateObject private var viewModel = GroceryViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(viewModel.groupedGroceryList.keys.sorted(), id: \.self) { group in
                            Section(header: Text(group)) {
                                ForEach(viewModel.groupedGroceryList[group] ?? []) { item in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                            Text(item.store)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Button(action: {
                                            if !viewModel.locked {
                                                if let index = viewModel.groceryList.firstIndex(of: item) {
                                                    viewModel.groceryList[index].need.toggle()
                                                    viewModel.saveGroceryList()
                                                }
                                            }
                                        }) {
                                            Image(systemName: item.need ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(item.need ? .green : .gray)
                                        }

                                        if viewModel.locked && item.need {
                                            Button(action: {
                                                if let index = viewModel.groceryList.firstIndex(of: item) {
                                                    viewModel.groceryList[index].inCart.toggle()
                                                    viewModel.saveGroceryList()
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
                                    viewModel.deleteGrocery(at: offsets, in: group)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Groceries")
                .navigationBarItems(
                    leading: Button("Filters") {
                        viewModel.isPresentingFilters = true
                    },
                    trailing: Button(action: {
                        viewModel.isPresentingAddForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                )
                .sheet(isPresented: $viewModel.isPresentingAddForm) {
                    AddGroceryView(viewModel: viewModel) { newItem in
                        viewModel.groceryList.append(newItem)
                        viewModel.saveGroceryList()
                    }
                }
                .onAppear {
                    viewModel.loadGroceryList()
                    viewModel.loadStores()
                    viewModel.loadGroups()
                }
            }
            .sheet(isPresented: $viewModel.isPresentingFilters) {
                GroceryFiltersView(viewModel: viewModel)
            }
        }
    }
}

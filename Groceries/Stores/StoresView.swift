import SwiftUI

struct StoresView: View {
    @ObservedObject var stores: Stores
    @State private var storeName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add a Store")) {
                        TextField("Store Name", text: $storeName)
                        Button(action: {
                            if !storeName.isEmpty {
                                stores.storeList.append(storeName)
                                saveStores()
                                storeName = ""
                            }
                        }) {
                            Text("Add Store")
                        }
                    }
                    
                    Section(header: Text("Stores")) {
                        List {
                            ForEach(stores.storeList, id: \.self) { store in
                                HStack {
                                    Text(store)
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                if let index = stores.storeList.firstIndex(of: store) {
                                                    stores.storeList.remove(at: index)
                                                    saveStores()
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Stores")
            .onAppear(perform: loadStores)
        }
    }

    private func saveStores() {
        UserDefaults.standard.set(stores.storeList, forKey: "SavedStores")
    }

    private func loadStores() {
        if let savedStores = UserDefaults.standard.array(forKey: "SavedStores") as? [String] {
            stores.storeList = savedStores
        }
    }
}

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
                                    Spacer()
                                    Button(action: {
                                        if let index = stores.storeList.firstIndex(of: store) {
                                            stores.storeList.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Stores")
        }
    }
}

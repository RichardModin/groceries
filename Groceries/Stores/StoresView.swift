import SwiftUI

struct StoresView: View {
    @StateObject private var viewModel = StoresViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add a Store")) {
                        TextField("Store Name", text: $viewModel.storeName)
                        Button(action: {
                            viewModel.addStore()
                        }) {
                            Text("Add Store")
                        }
                    }

                    Section(header: Text("Stores")) {
                        List {
                            ForEach(viewModel.storeList, id: \.self) { store in
                                HStack {
                                    Text(store)
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                if let index = viewModel.storeList.firstIndex(of: store) {
                                                    viewModel.deleteStore(at: index)
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
        }
    }
}

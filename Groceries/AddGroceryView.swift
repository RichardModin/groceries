import SwiftUI

struct AddGroceryView: View {
    @ObservedObject var stores: Stores
    @Environment(\.dismiss) var dismiss
    @State private var newItem = ""
    @State private var selectedStore = "None"
    var onAdd: (GroceryItem) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Item")) {
                    TextField("Enter grocery item", text: $newItem)
                }
                Section(header: Text("Store")) {
                    Picker("Select a store", selection: $selectedStore) {
                        Text("None").tag("None")
                        ForEach(stores.storeList, id: \.self) { store in
                            Text(store)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("Add Grocery")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    let trimmed = newItem.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    onAdd(GroceryItem(name: trimmed, store: selectedStore))
                    dismiss()
                }
            )
        }
    }
}

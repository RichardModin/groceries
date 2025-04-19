import SwiftUI

struct AddGroceryView: View {
    @ObservedObject var stores: Stores
    @ObservedObject var groups: Groups
    @Environment(\.dismiss) var dismiss
    @State private var newItem = ""
    @State private var selectedStore = "None"
    @State private var selectedGroup = "None"
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
                Section(header: Text("Group")) {
                    Picker("Select a group", selection: $selectedGroup) {
                        Text("None").tag("None")
                        ForEach(groups.groupList, id: \.self) { group in
                            Text(group)
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
                    onAdd(GroceryItem(name: trimmed, store: selectedStore, group: selectedGroup))
                    dismiss()
                }
            )
        }
    }
}

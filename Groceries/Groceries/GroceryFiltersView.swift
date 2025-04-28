import SwiftUI

struct GroceryFiltersView: View {
    @ObservedObject var viewModel: GroceryViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Store")
                            .font(.subheadline)
                            .bold()
                        Spacer()
                        Picker("Filter by store", selection: $viewModel.selectedStore) {
                            Text("All").tag("All")
                            ForEach(viewModel.groceryStores, id: \.self) { store in
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
                        Toggle(isOn: $viewModel.showOnlyNeeds) {
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
                        Toggle(isOn: $viewModel.locked) {
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
                        Toggle(isOn: $viewModel.showInCartOnly) {
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
                        viewModel.uncheckAll()
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

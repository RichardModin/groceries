import SwiftUI

struct EditMealView: View {
    @ObservedObject var viewModel: MealsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var mealName: String
    @State private var selectedGroceries: [GroceryItem]

    init(viewModel: MealsViewModel, meal: Meal) {
        self.viewModel = viewModel
        self._mealName = State(initialValue: meal.name)
        self._selectedGroceries = State(initialValue: meal.groceries)
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter meal name", text: $mealName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // List for Groceries grouped by category
                List {
                    ForEach(viewModel.groupedKeys, id: \.self) { category in
                        Section(header: Text(category)) {
                            ForEach(viewModel.groupedGroceries[category] ?? [], id: \.id) { grocery in
                                Button(action: {
                                    if let index = selectedGroceries.firstIndex(where: { $0.id == grocery.id }) {
                                        selectedGroceries.remove(at: index)
                                    } else {
                                        selectedGroceries.append(grocery)
                                    }
                                }) {
                                    HStack {
                                        Text(grocery.name)
                                            .foregroundColor(selectedGroceries.contains(where: { $0.id == grocery.id }) ? .green : .primary)
                                        Spacer()
                                        if selectedGroceries.contains(where: { $0.id == grocery.id }) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("Edit Meal")
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    let trimmed = mealName.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    viewModel.updateMeal(name: trimmed, groceries: selectedGroceries)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
                .disabled(mealName.isEmpty)
            )
            .onAppear {
                viewModel.loadGroceryList()
            }
        }
    }
}

import SwiftUI

struct AddMealView: View {
    @ObservedObject var viewModel: MealsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var mealName: String = ""
    @State private var selectedGroceries: [GroceryItem] = []

    var body: some View {
        NavigationView {
            VStack {
                // Top Section: Meal Name Input
                TextField("Enter meal name", text: $mealName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // List for Groceries
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
            .navigationTitle("Add New Meal")
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    let trimmed = mealName.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    let newMeal = Meal(id: UUID(), name: trimmed, groceries: selectedGroceries)
                    viewModel.saveMeal(newMeal)
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

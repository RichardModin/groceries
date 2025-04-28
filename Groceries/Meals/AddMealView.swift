import SwiftUI

struct AddMealView: View {
    @Binding var meals: [Meal]
    var saveMeals: () -> Void
    @State private var mealName: String = ""
    @State private var selectedGroceries: [GroceryItem] = []
    @State private var groceryList: [GroceryItem] = []
    @Environment(\.presentationMode) var presentationMode

    var groupedGroceries: [String: [GroceryItem]] {
        Dictionary(grouping: groceryList, by: { $0.group })
    }

    var body: some View {
        NavigationView {
            VStack {
                // Top Section: Meal Name Input
                TextField("Enter meal name", text: $mealName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Grouped List for Groceries
                List {
                    ForEach(groupedGroceries.keys.sorted(), id: \.self) { group in
                        Section(header: Text(group)) {
                            ForEach(groupedGroceries[group] ?? []) { grocery in
                                Button(action: {
                                    if let index = selectedGroceries.firstIndex(where: { $0.id == grocery.id }) {
                                        // Remove from selectedGroceries
                                        selectedGroceries.remove(at: index)
                                    } else {
                                        // Add to selectedGroceries
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
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let trimmed = mealName.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    let newMeal = Meal(name: trimmed, groceries: selectedGroceries)
                    meals.append(newMeal)
                    saveMeals()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(mealName.isEmpty)
            )
            .onAppear {
                loadGroceryList()
            }
        }
    }

    private func loadGroceryList() {
        if let data = UserDefaults.standard.data(forKey: "GroceryList"),
           let decoded = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            groceryList = decoded
        }
    }
}

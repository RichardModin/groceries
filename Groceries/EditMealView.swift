import SwiftUI

struct EditMealView: View {
    @Binding var meal: Meal
    @Binding var meals: [Meal]
    var saveMeals: () -> Void
    @State private var mealName: String
    @State private var selectedGroceries: [GroceryItem]
    @State private var groceryList: [GroceryItem] = []
    @Environment(\.presentationMode) var presentationMode

    var groupedGroceries: [String: [GroceryItem]] {
        Dictionary(grouping: groceryList, by: { $0.group })
    }

    init(meal: Binding<Meal>, meals: Binding<[Meal]>, saveMeals: @escaping () -> Void) {
        self._meal = meal
        self._meals = meals
        self.saveMeals = saveMeals
        self._mealName = State(initialValue: meal.wrappedValue.name)
        self._selectedGroceries = State(initialValue: meal.wrappedValue.groceries)
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter meal name", text: $mealName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                List {
                    ForEach(groupedGroceries.keys.sorted(), id: \.self) { group in
                        Section(header: Text(group)) {
                            ForEach(groupedGroceries[group] ?? []) { grocery in
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
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let trimmed = mealName.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    if let index = meals.firstIndex(where: { $0.id == meal.id }) {
                        meals[index] = Meal(id: meal.id, name: trimmed, groceries: selectedGroceries, need: meal.need)
                    }
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

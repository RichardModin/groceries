import SwiftUI

struct MealsView: View {
    @ObservedObject var groceryList: GroceryList
    @State private var isEditing = false
    @State private var isPresentingAddMealForm = false
    @State private var meals: [Meal] = []

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(meals) { meal in
                        HStack {
                            if isEditing {
                                Button(action: {
                                    if let index = meals.firstIndex(where: { $0.id == meal.id }) {
                                        meals.remove(at: index)
                                        saveMeals()
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                }
                            }
                            Text(meal.name)
                            Spacer()
                            Button(action: {
                                if let index = meals.firstIndex(where: { $0.id == meal.id }) {
                                    meals[index].need.toggle()
                                    saveMeals() // Save the updated state
                                }
                            }) {
                                Image(systemName: meal.need ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(meal.need ? .green : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle("Meals")
            .navigationBarItems(
                leading: Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit")
                },
                trailing: Button(action: {
                    isPresentingAddMealForm = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isPresentingAddMealForm) {
                AddMealView(meals: $meals, saveMeals: saveMeals)
            }
            .onAppear {
                loadMeals()
            }
        }
    }

    private func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: "Meals")
        }
    }

    private func loadMeals() {
        if let data = UserDefaults.standard.data(forKey: "Meals"),
           let decoded = try? JSONDecoder().decode([Meal].self, from: data) {
            meals = decoded
        }
    }
}

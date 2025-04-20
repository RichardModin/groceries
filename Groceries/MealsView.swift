import SwiftUI

struct MealsView: View {
    @ObservedObject var groceryList: GroceryList
    @State private var isPresentingAddMealForm = false
    @State private var meals: [Meal] = []

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(meals) { meal in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(meal.name)
                                if !meal.groceries.isEmpty {
                                    Text(meal.groceries.map { $0.name }.joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            Button(action: {
                                if let index = meals.firstIndex(where: { $0.id == meal.id }) {
                                    meals[index].need.toggle()
                                    saveMeals()
                                    
                                    if meals[index].need {
                                        for grocery in meal.groceries {
                                            if let groceryIndex = groceryList.items.firstIndex(where: { $0.id == grocery.id }) {
                                                groceryList.items[groceryIndex].need = true
                                            }
                                        }
                                        saveGroceryList()
                                    }
                                }
                            }) {
                                Image(systemName: meal.need ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(meal.need ? .green : .gray)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = meals.firstIndex(where: { $0.id == meal.id }) {
                                    meals.remove(at: index)
                                    saveMeals()
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Meals")
            .navigationBarItems(
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
    
    private func saveGroceryList() {
        if let encoded = try? JSONEncoder().encode(groceryList.items) {
            UserDefaults.standard.set(encoded, forKey: "GroceryList")
        }
    }
}

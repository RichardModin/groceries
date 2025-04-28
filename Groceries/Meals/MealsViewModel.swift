import Foundation

class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var mealToEdit: Meal?
    @Published var isPresentingAddMealForm = false
    @Published var isPresentingEditMealForm = false
    @Published var groceryList: GroceryList = GroceryList(items: [])
    @Published var groupedGroceries: [String: [GroceryItem]] = [:]
    @Published var groupedKeys: [String] = []

    init(groceryList: GroceryList) {
        self.groceryList = groceryList
        loadMeals()
    }

    func toggleMealNeed(for meal: Meal) {
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
    }
    
    func loadGroceryList() {
        // Load the grocery list (implementation depends on your data source)
        // Example:
        groceryList = self.groceryList

        // Precompute groupedGroceries and its keys
        groupedGroceries = Dictionary(grouping: groceryList.items, by: { $0.group })
        groupedKeys = groupedGroceries.keys.sorted()
    }

    func deleteMeal(at index: Int) {
        meals.remove(at: index)
        saveMeals()
    }

    func editMeal(_ meal: Meal) {
        mealToEdit = meal
        isPresentingEditMealForm = true
    }

    func addMeal() {
        isPresentingAddMealForm = true
    }
    
    func updateMeal(name: String, groceries: [GroceryItem]) {
        if let index = meals.firstIndex(where: { $0.id == mealToEdit?.id }) {
            meals[index].name = name
            meals[index].groceries = groceries
            saveMeals()
        }
    }
    
    func saveMeal(_ meal: Meal) {
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals[index] = meal
        } else {
            meals.append(meal)
        }
        saveMeals()
    }

    func saveMeals() {
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

    func saveGroceryList() {
        if let encoded = try? JSONEncoder().encode(groceryList.items) {
            UserDefaults.standard.set(encoded, forKey: "GroceryList")
        }
    }
}

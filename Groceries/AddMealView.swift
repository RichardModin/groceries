import SwiftUI

struct AddMealView: View {
    @Binding var meals: [Meal]
    var saveMeals: () -> Void
    @State private var mealName: String = ""
    @State private var selectedGroceries: [GroceryItem] = []
    @State private var isPresentingGroceryList = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter meal name", text: $mealName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    isPresentingGroceryList = true
                }) {
                    Text("Add Groceries")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $isPresentingGroceryList) {
                    GrocerySelectionView(selectedGroceries: $selectedGroceries)
                }

                List(selectedGroceries) { grocery in
                    Text(grocery.name)
                }

                Spacer()
            }
            .navigationTitle("Add New Meal")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let newMeal = Meal(name: mealName, groceries: selectedGroceries)
                    meals.append(newMeal)
                    saveMeals()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(mealName.isEmpty)
            )
        }
    }
}

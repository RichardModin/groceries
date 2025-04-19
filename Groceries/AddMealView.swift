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
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
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
                    let trimmed = mealName.trimmingCharacters(in: .whitespaces)
                    guard !trimmed.isEmpty else { return }
                    let newMeal = Meal(name: trimmed, groceries: selectedGroceries)
                    meals.append(newMeal)
                    saveMeals()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(mealName.isEmpty)
            )
        }
    }
}

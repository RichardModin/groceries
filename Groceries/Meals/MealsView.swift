import SwiftUI

struct MealsView: View {
    @StateObject private var viewModel = MealsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.meals) { meal in
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
                                viewModel.toggleMealNeed(for: meal)
                            }) {
                                Image(systemName: meal.need ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(meal.need ? .green : .gray)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let index = viewModel.meals.firstIndex(where: { $0.id == meal.id }) {
                                    viewModel.deleteMeal(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.editMeal(meal)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Meals")
            .navigationBarItems(
                trailing: Button(action: {
                    viewModel.addMeal()
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $viewModel.isPresentingAddMealForm) {
                AddMealView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.isPresentingEditMealForm) {
                if let mealToEdit = viewModel.mealToEdit {
                    EditMealView(viewModel: viewModel, meal: mealToEdit)
                }
            }
            .onAppear {
                viewModel.loadGroceryList()
            }
        }
    }
}

import SwiftUI

class GroceryList: ObservableObject {
    @Published var items: [GroceryItem] = []
}

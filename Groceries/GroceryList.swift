import SwiftUI

class GroceryList: ObservableObject {
    @Published var items: [GroceryItem]
    
    init(items: [GroceryItem] = []) {
        self.items = items
    }
}

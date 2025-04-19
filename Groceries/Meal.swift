import SwiftUI

struct Meal: Identifiable, Equatable, Codable {
    var id = UUID()
    var name: String
    var groceries: [GroceryItem]
}

import SwiftUI

struct GroceryItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var store: String
    var group: String
    var need: Bool = false
    var inCart: Bool = false
}

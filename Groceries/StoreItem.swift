import SwiftUI

struct StoreItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
}

import SwiftUI

class Stores: ObservableObject {
    @Published var storeList: [String] = [] {
        didSet {
            saveStores()
        }
    }

    init() {
        loadStores()
    }

    private func saveStores() {
        if let data = try? JSONEncoder().encode(storeList) {
            UserDefaults.standard.set(data, forKey: "storeList")
        }
    }

    private func loadStores() {
        if let data = UserDefaults.standard.data(forKey: "storeList"),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            storeList = decoded
        }
    }
}

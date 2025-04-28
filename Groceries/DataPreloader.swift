import Foundation


struct SeedGroceryItem: Codable {
    var id: UUID?
    let name: String
    let store: String
    let group: String
    let need: Bool
    var inCart: Bool?
}

struct SeedStoreItem: Codable {
    var id: UUID?
    let name: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        if let idString = try? container.decode(String.self, forKey: .id) {
            id = UUID(uuidString: idString)
        } else {
            id = nil
        }
    }
}

struct SeedGroupItem: Codable {
    var id: UUID?
    let name: String
}

class DataPreloader {
    static let shared = DataPreloader()
    private let preloadKey = "hasPreloadedData"

    func preloadDataIfNeeded() {
        resetPreloadKey();

        print("Preloading data if needed.")
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: preloadKey) {
            print("Preloading data for the first time.")
            // Preload your data here
            loadInitialData()

            // Mark as preloaded
            userDefaults.set(true, forKey: preloadKey)
            userDefaults.synchronize()
        }
    }

    private func resetPreloadKey() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: preloadKey)
        userDefaults.synchronize()
        print("Preload key erased.")
    }

    private func loadInitialData() {
        print("Trying to load.")
        if let url = Bundle.main.url(forResource: "InitialData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let initialData = try JSONDecoder().decode(InitialData.self, from: data)

                // Write data to the correct objects
                saveGroceries(initialData.groceries)
                saveStores(initialData.stores)
                saveGroups(initialData.groups)

                print("Data preloaded successfully.")
            } catch {
                print("Failed to load initial data: \(error)")
            }
        }
    }

    private func saveGroceries(_ groceries: [SeedGroceryItem]) {
        do {
            var mutableGroceries = groceries // Create a mutable copy
            for i in 0..<mutableGroceries.count {
                mutableGroceries[i].id = UUID()
                mutableGroceries[i].inCart = false
            }
            let data = try JSONEncoder().encode(mutableGroceries)
            UserDefaults.standard.set(data, forKey: "GroceryList")
            print("Groceries saved successfully.")
        } catch {
            print("Failed to save groceries: \(error)")
        }
    }

    private func saveStores(_ stores: [SeedStoreItem]) {
        let storeNames = stores.map { $0.name } // Extract group names
        UserDefaults.standard.set(storeNames, forKey: "SavedStores")
        print("Stores saved successfully.")
    }

    private func saveGroups(_ groups: [SeedGroupItem]) {
        let groupNames = groups.map { $0.name } // Extract group names
        UserDefaults.standard.set(groupNames, forKey: "SavedGroups")
        print("Groups saved successfully.")
    }
}

struct InitialData: Codable {
    let groceries: [SeedGroceryItem]
    let stores: [SeedStoreItem]
    let groups: [SeedGroupItem]
}

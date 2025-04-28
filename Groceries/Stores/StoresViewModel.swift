import Foundation

class StoresViewModel: ObservableObject {
    @Published var storeList: [String] = []
    @Published var storeName: String = ""

    init() {
        loadStores()
    }

    func addStore() {
        guard !storeName.isEmpty else { return }
        storeList.append(storeName)
        saveStores()
        storeName = ""
    }

    func deleteStore(at index: Int) {
        storeList.remove(at: index)
        saveStores()
    }

    private func saveStores() {
        UserDefaults.standard.set(storeList, forKey: "SavedStores")
    }

    private func loadStores() {
        if let savedStores = UserDefaults.standard.array(forKey: "SavedStores") as? [String] {
            storeList = savedStores
        }
    }
}

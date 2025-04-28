import Foundation

class Groups: ObservableObject {
    @Published var groupList: [String] = [] {
        didSet {
            saveGroups()
        }
    }
    
    init() {
        loadGroups()
    }
    
    private func saveGroups() {
        if let data = try? JSONEncoder().encode(groupList) {
            UserDefaults.standard.set(data, forKey: "groupList")
        }
    }

    private func loadGroups() {
        if let data = UserDefaults.standard.data(forKey: "groupList"),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            groupList = decoded
        }
    }
}

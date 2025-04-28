import Foundation

class GroupsViewModel: ObservableObject {
    @Published var groupList: [String] = []
    @Published var groupName: String = ""

    init() {
        loadGroups()
    }

    func addGroup() {
        guard !groupName.isEmpty else { return }
        groupList.append(groupName)
        saveGroups()
        groupName = ""
    }

    func deleteGroup(at index: Int) {
        groupList.remove(at: index)
        saveGroups()
    }

    private func saveGroups() {
        UserDefaults.standard.set(groupList, forKey: "SavedGroups")
    }

    private func loadGroups() {
        if let savedGroups = UserDefaults.standard.array(forKey: "SavedGroups") as? [String] {
            groupList = savedGroups
        }
    }
}

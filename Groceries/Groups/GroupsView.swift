import SwiftUI

struct GroupsView: View {
    @ObservedObject var groups: Groups
    @State private var groupName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add a Group")) {
                        TextField("Group Name", text: $groupName)
                        Button(action: {
                            if !groupName.isEmpty {
                                groups.groupList.append(groupName)
                                saveGroups()
                                groupName = ""
                            }
                        }) {
                            Text("Add Group")
                        }
                    }
                    
                    Section(header: Text("Groups")) {
                        List {
                            ForEach(groups.groupList, id: \.self) { group in
                                HStack {
                                    Text(group)
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                if let index = groups.groupList.firstIndex(of: group) {
                                                    groups.groupList.remove(at: index)
                                                    saveGroups()
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Groups")
            .onAppear(perform: loadGroups)
        }
    }

    private func saveGroups() {
        UserDefaults.standard.set(groups.groupList, forKey: "SavedGroups")
    }

    private func loadGroups() {
        if let savedGroups = UserDefaults.standard.array(forKey: "SavedGroups") as? [String] {
            groups.groupList = savedGroups
        }
    }
}

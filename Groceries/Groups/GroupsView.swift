import SwiftUI

struct GroupsView: View {
    @StateObject private var viewModel = GroupsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add a Group")) {
                        TextField("Group Name", text: $viewModel.groupName)
                        Button(action: {
                            viewModel.addGroup()
                        }) {
                            Text("Add Group")
                        }
                    }

                    Section(header: Text("Groups")) {
                        List {
                            ForEach(viewModel.groupList, id: \.self) { group in
                                HStack {
                                    Text(group)
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                if let index = viewModel.groupList.firstIndex(of: group) {
                                                    viewModel.deleteGroup(at: index)
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
        }
    }
}

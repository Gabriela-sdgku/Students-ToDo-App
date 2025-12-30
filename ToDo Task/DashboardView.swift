//
//  DashboardView.swift
//  ToDo Task
//
//  Created SDGKU
//

import SwiftUI

struct DashboardView: View {
    
    @Binding var profile: Profile
    @State private var selectedGroup: TaskGroup?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var isShowingAddGroup = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedGroup) {
                    ForEach(profile.groups) { group in
                        NavigationLink(value: group) {
                            Label(group.title, systemImage: group.symbolName)
                        }
                    }
                
            }
            .navigationTitle(profile.name)
            .listStyle(.sidebar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label : {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Home")
                        }
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button { isShowingAddGroup = true } label : {
                        Image(systemName: "plus")
                    }
                }
            }
        } detail: {
            if let group = selectedGroup {
                if let index = profile.groups.firstIndex(where: { $0.id == group.id}) {
                    TaskGroupDetailView(groups: $profile.groups[index])
                }
            } else {
                ContentUnavailableView("Select a Group", systemImage: "sidebar.left")
            }
        }
        .sheet(isPresented: $isShowingAddGroup) {
            NewGroupView { newGroup in
                profile.groups.append(newGroup)}
        }
    }
}

//
//  TaskGroupDetailView.swift
//  ToDo Task
//
//  Created by SDGKU
//

import SwiftUI

struct TaskGroupDetailView: View {
    @Binding var groups: TaskGroup
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        List {
            Section {
                if sizeClass == .regular {
                    GroupStatsView(tasks: groups.tasks)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color(.secondarySystemBackground))
                }
                
                ForEach($groups.tasks) { $task in
                    VStack(alignment: .leading, spacing: 8) {
                        // Top Row: Toggle, Title and Priority (picker on the right)
                        HStack(alignment: .center) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(task.isCompleted ? .cyan : .gray)
                                .onTapGesture {
                                    withAnimation {
                                        task.isCompleted.toggle()
                                    }
                                }
                                .accessibilityIdentifier("TaskToggle_\(task.id)")

                            TextField("Task Title", text: $task.title)
                                .strikethrough(task.isCompleted)
                                .accessibilityIdentifier("TaskTextField_\(task.id)")

                            Spacer()

                            Picker("Priority", selection: $task.priority) {
                                ForEach(Priority.allCases, id: \.self) { p in
                                    Text(p.rawValue.capitalized).tag(p)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .accessibilityIdentifier("TaskPriorityPicker_\(task.id)")

                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { index in
                    groups.tasks.remove(atOffsets: index)
                }
            }
        }
        .navigationTitle(groups.title)
        .toolbar {
            Button("Add Task") {
                withAnimation {
                    groups.tasks.append(TaskItem(title: ""))
                }
            }
            .accessibilityIdentifier("AddTaskButton")
        }
    }
}


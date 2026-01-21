//
//  TaskGroupDetailView.swift
//  ToDo Task
//
//  Created SDGKU
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
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isCompleted ? .cyan : .gray)
                            .onTapGesture {
                                withAnimation {
                                    task.isCompleted.toggle()
                                }
                            }
                            .accessibilityIdentifier("taskCompletionToggle_\(task.title)")
                        
                        TextField("Task Title", text: $task.title)
                            .strikethrough(task.isCompleted)
                            .foregroundColor(task.isOverdue && !task.isCompleted ? .red : .primary)
                            .accessibilityIdentifier("taskTextField_\(task.title)")
                        
                        DatePicker("", selection:Binding (
                            get: {task.dueDate ?? Date()},
                            set: {task.dueDate = $0}
                        ), displayedComponents: .date)
                        .labelsHidden()
                        .frame(width: 100)
                        .tint(task.isOverdue ? .red : .accentColor)
                        .background(task.isOverdue ? Color.red.opacity(0.1) : Color.clear)
                        .cornerRadius(4)
                    }
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
            .accessibilityIdentifier("addTaskButton")
        }
    }
}

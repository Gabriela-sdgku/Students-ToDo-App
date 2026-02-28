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
                            .accessibilityIdentifier("TaskToggle_\(task.id)")
                        
                        TextField("Task Title", text: $task.title)
                            .strikethrough(task.isCompleted)
                            .accessibilityIdentifier("TaskTextField_\(task.id)")
                        
                        
                        VStack {
                            DatePicker("Goal Date", selection: $task.dueDate, displayedComponents: .date)
                                .labelsHidden()
                                .scaleEffect(0.9)
                                .accessibilityIdentifier("TaskDatePicker")
                            
                            Text("Due: \(task.dueDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .accessibilityIdentifier("TaskDateLabel")
                        }
                        .padding(.leading, 12)
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
            .accessibilityIdentifier("AddTaskButton")
        }
    }
}

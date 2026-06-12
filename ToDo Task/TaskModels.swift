//
//  TaskModels.swift
//  ToDo Task
//
//  Created by SDGKU
//

import Foundation

enum Priority: String, Codable, CaseIterable, Hashable {
    case low
    case medium
    case high
}

struct TaskItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var priority: Priority = .medium
}

struct TaskGroup: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var symbolName: String
    var tasks: [TaskItem]
}

struct Profile: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var profileImage: String
    var groups: [TaskGroup]
}


// MOCK DATA
extension TaskGroup {
    static let sampleData: [TaskGroup] = [
        TaskGroup(title: "Groceries", symbolName: "storefront.circle.fill", tasks: [
            TaskItem(title: "Buy Apples", priority: .low),
            TaskItem(title: "Buy Milk", priority: .medium)
        ]),
        
        TaskGroup(title: "Home", symbolName: "house.fill", tasks: [
            TaskItem(title: "Walk the dog", isCompleted: true, priority: .low ),
            TaskItem(title: "Clean the kitchen", priority: .high)
        ])
    ]
}

extension Profile {
    static let sample: [Profile] = [
        Profile(name: "Professor", profileImage: "professor", groups: TaskGroup.sampleData),
        Profile(name: "Student", profileImage: "student", groups: [])
    ]
}

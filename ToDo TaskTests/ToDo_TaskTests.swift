//
//  ToDo_TaskTests.swift
//  ToDo TaskTests
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import Testing
import Foundation
@testable import ToDo_Task

struct Todo_TaskTests {

    // MARK: - Logic & Progress Tests
    
    @Test("Verify progress calculation with mixed task states")
    func testProgressCalculation() {
        let tasks = [
            TaskItem(title: "Task 1", isCompleted: true),
            TaskItem(title: "Task 2", isCompleted: false),
            TaskItem(title: "Task 3", isCompleted: false)
        ]
        
        let completedCount = tasks.filter { $0.isCompleted }.count
        let progress = Double(completedCount) / Double(tasks.count)
        
        #expect(completedCount == 1)
        #expect(progress > 0.33 && progress < 0.34)
    }
    
    @Test("Verify 100% completion state")
    func testFullCompletionProgress() {
        let tasks = [
            TaskItem(title: "Task 1", isCompleted: true),
            TaskItem(title: "Task 2", isCompleted: true)
        ]
        
        let progress = Double(tasks.filter { $0.isCompleted }.count) / Double(tasks.count)
        
        #expect(progress == 1.0)
    }

    // MARK: - Model Integrity Tests
    
    @Test("TaskItem initialization defaults to not completed")
    func testTaskItemDefaultState() {
        let newTask = TaskItem(title: "New Lesson")
        #expect(newTask.isCompleted == false)
    }
    
    @Test("TaskGroup starts with an empty task list by default")
    func testTaskGroupEmptyInit() {
        let group = TaskGroup(title: "Research", symbolName: "book", tasks: [])
        #expect(group.tasks.isEmpty)
    }

    // MARK: - Data Transformation (Codable)
    
    @Test("Verify Profile can be encoded and decoded (Persistence check)")
    func testProfileEncodingDecoding() throws {
        let originalProfile = Profile(name: "Test Prof", profileImage: "image", groups: [])
        
        // Encode
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalProfile)
        
        // Decode
        let decoder = JSONDecoder()
        let decodedProfile = try decoder.decode(Profile.self, from: data)
        
        #expect(decodedProfile.name == originalProfile.name)
        #expect(decodedProfile.id == originalProfile.id)
    }
}

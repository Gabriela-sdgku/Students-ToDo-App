//
//  ToDo_TaskTests.swift
//  ToDo TaskTests
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import Testing
import Foundation
import XCTest
@testable import ToDo_Task

struct Todo_TaskTests {
    /*
     AAA: Arrange, Act and Assert
     Given, When , Then
     */
    
    // Test: verify that a task is showing a Due Date
    
    @Test("Verify that the TaskItem can store and retrieve a Due Date")
    func testTaskHasDueDate() {
        let testDate = Date(timeIntervalSince1970: 1776220044) // april 14 2026
        let task = TaskItem(title: "Create Test", isCompleted: false, dueDate: testDate)
        #expect(task.dueDate == testDate)
    }
    
    @Test("Task should be identified as overdue if the due date is in the past")
    func testOverdueTask() {
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let task = TaskItem(title: "Create Test Overdue", isCompleted: false, dueDate: pastDate)
        #expect(task.isOverdue == true, "A task with a past date and not completde should be overdue")
    }
}

class ToDo_TaskTests: XCTestCase {
    func testProgressCalculation() {
        // GIVEN/ARRANGE: Have all the context (ingredients) ready to test
        let tasks = [
            TaskItem(title: "Test 1", isCompleted: true),
            TaskItem(title: "Test 2", isCompleted: true),
            TaskItem(title: "Text 3", isCompleted: false),
            TaskItem(title: "Text 4", isCompleted: false)
        ]
        
        let group = TaskGroup(title: "Group Test", symbolName: "star", tasks: tasks)
            
        //WHEN/ACT: Calculate the process
        let completedCount = group.tasks.filter { $0.isCompleted}.count
        let progress = Double(completedCount) / Double(group.tasks.count)
        
        // THEN/ASSERT: Compare the result to what I expect (2/4 = 0.5 = 50%)
        XCTAssertEqual(progress, 0.5, "Progress should be 50% when half the tasks are done")
    }
}

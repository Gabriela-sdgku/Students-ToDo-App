//
//  ToDo_TaskTests.swift
//  ToDo TaskTests
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import XCTest
@testable import ToDo_Task

class ToDo_TaskTests: XCTestCase {
    
    // Always needs to starts with the word test
    func testProgressCalcuation() {
        // Arrange : have all the variable we need to make the the test work
        
        let tasks = [
            TaskItem(title: "test1", isCompleted: false),
            TaskItem(title: "test2", isCompleted: true),
            TaskItem(title: "test3", isCompleted: true),
            TaskItem(title: "test4", isCompleted: false)
        ]
        
        let group = TaskGroup(title: "GroupTest", symbolName: "house.fill", tasks: tasks)
        
        // ACT: Calculating the logic
        let completedCount = group.tasks.filter{$0.isCompleted}.count
        let progress = Double(completedCount) / Double(group.tasks.count)
        
        // ASSERT: What is the final output of the logic
        XCTAssertEqual(progress, 0.5, "Progress should be 50% when half the tasks are done.")
    }

    func testYourExample() {
        // test
    }
}

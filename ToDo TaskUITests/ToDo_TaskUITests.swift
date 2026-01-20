//
//  ToDo_TaskUITests.swift
//  ToDo TaskUITests
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import XCTest

final class ToDo_TaskUITests: XCTestCase {
    
    let app = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testLaunchInEnglish() {
        app.launchArguments = ["-AppleLanguages", "(en)"] // set the language
        app.launch()
        
        let header = app.staticTexts["Who is working today?"]
        XCTAssertTrue(header.exists, "The english header of 'Who is working today' is not found")
        
    }
    
    func testLaunchInSpanish() {
        app.launchArguments = ["-AppleLanguages", "(es)"] // set the language
        app.launch()
        let header = app.staticTexts["Quien esta trabajando hoy?"]
        XCTAssertTrue(header.exists, "The spanish header of 'Who is working today' in spanish is not found")
    }
    
    func testNewGroupCreationIcons() {
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        
        let firstProfile = app.buttons.firstMatch
        if firstProfile.exists {
            firstProfile.tap()
            
            let addButton = app.buttons["Add"]
            if addButton.waitForExistence(timeout: 2) {
                addButton.tap()
                
                XCTAssertTrue(app.staticTexts["Group Name"].exists)
                XCTAssertTrue(app.staticTexts["Select Icon"].exists)
            }
        }
    }
    
    // MARK: 117 - 1
    func testFullUserFlow() throws {
        // 1. Select the "Professor" Profile from ContentView
        let professorCard = app.buttons["profileCard_Professor"]
        XCTAssertTrue(professorCard.waitForExistence(timeout: 5), "The Professor profile card should exist.")
        professorCard.tap()
        
        // 2. Verify we are on the Dashboard and tap "Add Group"
        let addGroupButton = app.buttons["addGroupButton"]
        XCTAssertTrue(addGroupButton.waitForExistence(timeout: 5), "The Add Group button should be visible on the Dashboard.")
        addGroupButton.tap()
        
        let groupNameField = app.textFields["newGroupNameField"]
        XCTAssertTrue(groupNameField.waitForExistence(timeout: 2), "The Group Name text field should be present.")
        groupNameField.tap()
        groupNameField.typeText("Work Project")
        
        // Dismiss the keyboard to reveal the toolbar buttons
        if app.keyboards.buttons["Return"].exists {
            app.keyboards.buttons["Return"].tap()
        } else {
            // Fallback: tap the navigation bar to dismiss keyboard
            app.navigationBars["New Group Creator"].tap()
        }
        
        // Select an icon (e.g., the graduation cap)
        let iconButton = app.buttons["iconSelect_graduationcap.fill"]
        if iconButton.exists {
            iconButton.tap()
        }
        
        // Tap Save - Now guaranteed to be visible/hittable
        let saveGroupButton = app.buttons["saveGroupButton"]
        XCTAssertTrue(saveGroupButton.isHittable, "The Save button is not interactable.")
        saveGroupButton.tap()
        // 4. Verify the group was created and select it
        let newGroupRow = app.buttons["groupRow_Work Project"]
        XCTAssertTrue(newGroupRow.waitForExistence(timeout: 5), "The new group 'Work Project' should appear in the sidebar.")
        newGroupRow.tap()
        
        // 5. Add a Task inside the group
        let addTaskButton = app.buttons["addTaskButton"]
        XCTAssertTrue(addTaskButton.exists, "The Add Task button should be available in the detail view.")
        addTaskButton.tap()
        
        // Type the task title
        let taskTextField = app.textFields.firstMatch
        taskTextField.tap()
        taskTextField.typeText("Finish UI Tests")
        
        // 6. Toggle Task Completion
        let completionToggle = app.images["taskCompletionToggle_Finish UI Tests"]
        XCTAssertTrue(completionToggle.exists, "The task completion toggle should exist.")
        completionToggle.tap()
        
        // 7. Navigate back to Home
        let backButton = app.buttons["backToHomeButton"]
        XCTAssertTrue(backButton.exists, "The back button to return to Profile selection should exist.")
        backButton.tap()
        
        // Verify we are back at the Welcome screen
        let welcomeText = app.staticTexts["Who is working today?"]
        XCTAssertTrue(welcomeText.exists, "Should be back on the profile selection screen.")
    }
    
    func testCancelGroupCreation() throws {
        // Select Professor
        app.buttons["profileCard_Professor"].tap()
        
        // Open Add Group
        app.buttons["addGroupButton"].tap()
        
        // Tap Cancel
        let cancelButton = app.buttons["cancelGroupButton"]
        XCTAssertTrue(cancelButton.exists)
        cancelButton.tap()
        
        // Verify we are back on Dashboard without the new group
        XCTAssertTrue(app.buttons["addGroupButton"].exists)
    }
}

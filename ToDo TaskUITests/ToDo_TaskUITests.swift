//
//  ToDo_TaskUITests.swift
//  ToDo TaskUITests
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import XCTest

final class ProfessorToDoUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunchInEnglish() {
            // 1. Force the app to launch in English
            app.launchArguments = ["-AppleLanguages", "(en)"]
            app.launch()
            
            // 2. CHANGE: Look for the large visible header instead of the hidden "Home" title
            let header = app.staticTexts["Who is working today?"]
            
            XCTAssertTrue(header.exists, "The English header 'Who is working today?' was not found.")
        }

    func testLaunchInSpanish() {
            // 1. Force the app to launch in Spanish
            app.launchArguments = ["-AppleLanguages", "(es)"]
            app.launch()
            
            // 2. CHANGE: Look for the Spanish translation of the header
            // Make sure this EXACT string matches your String Catalog translation
            let spanishHeader = app.staticTexts["¿Quién está trabajando hoy?"]
            
            XCTAssertTrue(spanishHeader.waitForExistence(timeout: 2), "The Spanish header '¿Quién está trabajando hoy?' was not found.")
        }
    
    func testNewGroupSheetLocalization() {
        // Test that modal sheets also respect the language argument
        app.launchArguments = ["-AppleLanguages", "(es)"]
        app.launch()
        
        // 1. Tap the first profile (Professor/Student) to enter Dashboard
        // (This relies on your ContentView structure)
        let firstProfile = app.buttons.firstMatch
        if firstProfile.exists {
            firstProfile.tap()
            
            // 2. Tap the "Add Group" (+) button
            let addButton = app.buttons["Add"] // Or verify the accessibility identifier in your code
            if addButton.waitForExistence(timeout: 2) {
                addButton.tap()
                
                // 3. Verify the Form Labels are Spanish
                // "Group Name" -> "Nombre del Grupo"
                XCTAssertTrue(app.staticTexts["Nombre del Grupo"].exists)
                
                // "Select Icon" -> "Seleccionar Icono"
                XCTAssertTrue(app.staticTexts["Seleccionar Icono"].exists)
            }
        }
    }
    func testCreateNewTaskGroup() {
        let app = XCUIApplication()
        app.launch()

        // 1. Select a profile on the Dashboard
        // Uses the ID: "ProfileCard_\(profile.name)"
        let profileCard = app.buttons["ProfileCard_Professor"]
        XCTAssertTrue(profileCard.exists)
        profileCard.tap()

        // 2. Tap the plus button in ContentView
        // Uses the ID: "AddGroupButton"
        let addButton = app.buttons["AddGroupButton"]
        XCTAssertTrue(addButton.exists)
        addButton.tap()

        // 3. Fill out the New Group form
        // Uses the ID: "GroupNameTextField"
        let nameField = app.textFields["GroupNameTextField"]
        nameField.tap()
        nameField.typeText("Work Projects")

        // 4. Select an icon
        // Uses the ID: "Icon_cart.fill"
        let iconButton = app.images["Icon_cart.fill"]
        iconButton.tap()

        // 5. Save the group
        // Uses the ID: "SaveGroupButton"
        app.buttons["SaveGroupButton"].tap()

        // 6. Verify the new group appears in the Sidebar
        // Uses the ID: "GroupLink_Work Projects"
        XCTAssertTrue(app.buttons["GroupLink_Work Projects"].exists)
    }
    
    func testNavigationToTaskGroup() {
        let app = XCUIApplication()
        app.launch()

        // 1. Select the Professor profile from the Dashboard
        let professorCard = app.buttons["ProfileCard_Professor"]
        XCTAssertTrue(professorCard.exists, "The Professor profile card should be on the Home screen.")
        professorCard.tap()

        // 2. Identify and tap the 'Groceries' group in the sidebar/list
        // Note: We use the accessibilityIdentifier defined in ContentView.swift
        let groceriesGroup = app.buttons["GroupLink_Groceries"]
        XCTAssertTrue(groceriesGroup.waitForExistence(timeout: 2), "The Groceries group should be visible in the list.")
        groceriesGroup.tap()

        // 3. Assert that the navigation title updated to 'Groceries'
        // This confirms the TaskGroupDetailView is now active.
        let detailTitle = app.navigationBars["Groceries"]
        XCTAssertTrue(detailTitle.exists, "The navigation bar should display 'Groceries' after tapping the group.")
    }

    //CLASE 2: Priority TDD Development Testing
    func testTaskPriorityPicker() {
        let app = XCUIApplication()
        app.launch()

        // Reuse initial steps from testCreateNewTaskGroup: select profile, add a group "Work Projects"
        let profileCard = app.buttons["ProfileCard_Professor"]
        XCTAssertTrue(profileCard.waitForExistence(timeout: 2))
        profileCard.tap()

        let addButton = app.buttons["AddGroupButton"]
        XCTAssertTrue(addButton.exists)
        addButton.tap()

        let nameField = app.textFields["GroupNameTextField"]
        nameField.tap()
        nameField.typeText("Work Projects")

        app.buttons["SaveGroupButton"].tap()
        XCTAssertTrue(app.buttons["GroupLink_Work Projects"].waitForExistence(timeout: 2))
        app.buttons["GroupLink_Work Projects"].tap()

        // Ensure at least one task exists: add one and type its title
        let addTaskButton = app.buttons["AddTaskButton"]
        XCTAssertTrue(addTaskButton.exists)
        addTaskButton.tap()

        let allTextFields = app.textFields
        let lastTaskField = allTextFields.element(boundBy: allTextFields.count - 1)
        lastTaskField.tap()
        lastTaskField.typeText("Sample Task")

        // Tap the priority picker and select High
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "TaskPriorityPicker_")
        let pickers = app.buttons.matching(predicate)
        XCTAssertTrue(pickers.count > 0, "There should be at least one priority picker visible")

        let firstPicker = pickers.element(boundBy: 0)
        XCTAssertTrue(firstPicker.exists)
        firstPicker.tap()

        if app.buttons["High"].waitForExistence(timeout: 2) {
            app.buttons["High"].tap()
        } else if app.staticTexts["High"].waitForExistence(timeout: 2) {
            app.staticTexts["High"].tap()
        }
    }
}

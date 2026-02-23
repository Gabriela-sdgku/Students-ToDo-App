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
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLaunchInEnglish() {
        // 1. Force the app to launch in a language
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        
        let header = app.staticTexts["Who is working today?"]
        XCTAssertTrue(header.exists, "The english header was not found")
    }
    func testLaunchInSpanish() {
        // 1. Force the app to launch in a language
        app.launchArguments = ["-AppleLanguages", "(es)"]
        app.launch()
        
        let header = app.staticTexts["¿Quién está trabajando hoy?"]
        XCTAssertTrue(header.exists, "The spanish header was not found")
    }
    
    func testCreateNewTaskGroup(){
        app.launch()
        
        let profileCard = app.buttons["ProfileCard_Professor"]
        XCTAssertTrue(profileCard.exists)
        profileCard.tap()
        
        let addButton = app.buttons["AddGroupButton"]
        XCTAssertTrue(addButton.exists)
        addButton.tap()
        
        let nameField = app.textFields["GroupNameTextField"]
        XCTAssertTrue(nameField.exists)
        nameField.tap()
        nameField.typeText("Testing Group")
        
        let iconButton = app.images["Icon_house.fill"]
        iconButton.tap()
        
        app.buttons["SaveGroupButton"].tap()
        
        XCTAssertTrue(app.buttons["GroupLink_Testing Group"].exists)
    }
}

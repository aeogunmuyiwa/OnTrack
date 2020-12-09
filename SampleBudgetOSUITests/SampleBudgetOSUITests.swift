//
//  SampleBudgetOSUITests.swift
//  SampleBudgetOSUITests
//
//  Created by Adebayo  Ogunmuyiwa on 2020-12-07.
//

import XCTest

class SampleBudgetOSUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTakeScreenShot(){
        let app = XCUIApplication()
        XCUIDevice.shared.orientation = .portrait
        snapshot("1-Homepage")
        sleep(2)
        app.buttons[CustomAssisbilityLabel.homepage.showfullBudegt].tap()
        snapshot("Full budget list")
      //  snapshot("Full budget list")
        sleep(3)
        
        
        app.staticTexts["Bills & Utilities"].tap()
        
        snapshot("Bills & Utilities")
        
        app.staticTexts["Internet"].tap()
        snapshot("Internet")
        sleep(2)
        app.buttons["Back"].tap()
        //app.buttons[CustomAssisbilityLabel.editTransaction.goBack].tap()
        app.buttons["Add transaction"].tap()
        snapshot("New Transaction")
        sleep(2)
        app.buttons["Back"].tap()
        sleep(1)
        app.buttons[CustomAssisbilityLabel.budgetList.goBack].tap()
        sleep(1)
        
        app.buttons["OnTrack"].tap()
        sleep(1)
        app.buttons[CustomAssisbilityLabel.homepage.showfullTransactions].tap()
        snapshot("All transaction")
        sleep(1)
    }
    
    func EnterBuget(){
        let app = XCUIApplication()
        let EnterBudgetName =  app.textFields[CustomAssisbilityLabel.Label.AddCategory_baseCardView_categoryNameInput]
        EnterBudgetName.tap()
        sleep(1)
        EnterBudgetName.typeText("Trip to mexico")
        
        let EnterBudgetAmount = app.textFields[CustomAssisbilityLabel.Label.AddCategory_baseCardView_budgetInput]
        EnterBudgetAmount.tap()
        sleep(2)
        dismissKeyboardIfPresent()
        sleep(2)
    }
    
    func dismissKeyboardIfPresent() {
        let app = XCUIApplication()
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
    }
    
    func EnterNewTransaction(){
        
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        sleep(3)
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("metasaleing@gmail.com")
        webView.press(forDuration: 0.1, thenDragTo: webView)
        sleep(2)
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("3DyPx23s")
        webView.tap()
        sleep(2)
        
        webView.buttons["Login"].tap()
        
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeDown()
        sleep(2)
        
        let cellToLike = tableQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        XCTAssertTrue(cell.buttons["LikeButton"].waitForExistence(timeout: 1))
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        cellToLike.buttons["LikeButton"].tap()
        sleep(3)
        
        cellToLike.tap()
        let image = app.scrollViews.images.element(boundBy: 0)
        sleep(3)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        XCTAssertTrue(app.buttons["BackButton"].waitForExistence(timeout: 5))
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Ivan Ryabov"].exists)
        XCTAssertTrue(app.staticTexts["@ove2xrate"].exists)
        
        app.buttons["LogoutButton"].tap()
        
        XCTAssertTrue(app.alerts["Пока, пока!"].waitForExistence(timeout: 5))
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}

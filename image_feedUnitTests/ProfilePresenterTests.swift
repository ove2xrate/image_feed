import XCTest
@testable import image_feed

final class ProfilePresenterTests: XCTestCase {
    
    let viewController = ProfileViewController()
    let presenter = ProfilePresenterSpy()
    
    override func setUpWithError() throws {
        // given
        viewController.presenter = presenter as ProfilePresenterProtocol
        presenter.view = viewController
    }
    
    func testViewControllerCallViewDidLoad() {
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallResetAccount() {
        // when
        _ = viewController.view
        presenter.logout()
        
        // then
        XCTAssertTrue(presenter.viewDidResetAccount)
    }
}

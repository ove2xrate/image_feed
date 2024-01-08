import XCTest
@testable import image_feed

final class ProfileViewControllerTests: XCTestCase {
    
    let viewController = ProfileViewControllerSpy()
    let presenter = ProfilePresenter()
    
    override func setUpWithError() throws {
        viewController.presenter = presenter
        presenter.view = (viewController as any ProfileViewControllerProtocol)
    }
    
    func testPresenterCallsLoadProfile() {
        // given
        let testUser = "test"
        let testProfile = Profile(username: testUser, name: testUser, loginName: testUser, bio: testUser)
        
        // when
        viewController.fillProfileDetails(testProfile)
        
        // then
        XCTAssertTrue(viewController.viewDidLoadProfile)
        
        XCTAssertEqual(viewController.profileUserNameLabel.text, testUser)
        XCTAssertEqual(viewController.profileLoginNameLabel.text, testUser)
        XCTAssertEqual(viewController.profileBioLabel.text, testUser)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // given
        let testUrl = URL(string: "https://apple.com")!
        
        // when
        viewController.updateAvatar(url: testUrl)
        
        // then
        XCTAssertTrue(viewController.viewDidUpdateAvatar)
    }
}

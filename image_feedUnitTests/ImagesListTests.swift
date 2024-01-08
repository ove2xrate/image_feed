@testable import image_feed
import XCTest

final class ImagesListTests: XCTestCase {
    
    let viewController = ImagesListViewController()
    let presenter = ImagesListPresenterSpy()
    let indexPath = IndexPath(row: 1, section: 0)
    
    override func setUpWithError() throws {
        // given
        viewController.presenter = presenter
        presenter.view = viewController
    }
    
    func testViewControllerCallViewDidLoad() {
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadWasCalled)
    }
    
    func testUpdateTableViewAnimated() {
        // when
        _ = viewController.view
        presenter.updateTableViewAnimated()
        
        // then
        XCTAssertTrue(presenter.animationWasCalled)
    }
    
    func testCalculateHeight() {
        // when
        _ = viewController.view
        let result = presenter.calculateHeight(indexPath: indexPath)
        
        // then
        XCTAssertTrue(presenter.heightCalculatorWasCalled)
        XCTAssertTrue(presenter.heightCalculatorGotIndexPath)
        XCTAssertEqual(result, CGFloat(100))
    }
    
    func testPhotosPerPageChecker() {
        // when
        _ = viewController.view
        presenter.photosPerPageChecker(indexPath: indexPath)
        
        // then
        XCTAssertTrue(presenter.photosCheckerWasCalled)
        XCTAssertTrue(presenter.photosCheckerGotIndex)
    }
    
    func testGetPhotoStructure() {
        // when
        _ = viewController.view
        _ = presenter.getPhotoStructure(indexPath: indexPath)
        
        // then
        XCTAssertTrue(presenter.photoStructureWasCalled)
        XCTAssertTrue(presenter.photoStructureGotIndex)
    }
    
    func testImagesListCellDidTapLike() {
        // when
        _ = viewController.view
        presenter.imagesListCellDidTapLike(ImagesListCell(), indexPath: indexPath)
        
        // then
        XCTAssertTrue(presenter.tapLikeWasCalled)
        XCTAssertTrue(presenter.tapLikeGotIndex)
    }
}

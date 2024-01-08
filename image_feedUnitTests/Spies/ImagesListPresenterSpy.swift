import Foundation
import image_feed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: image_feed.ImagesListViewControllerProtocol?
    var totalNumberOfPhotos: Int = 0
    
    var viewDidLoadWasCalled = false
    var animationWasCalled = false
    
    var heightCalculatorWasCalled = false
    var heightCalculatorGotIndexPath = false
    
    var photosCheckerWasCalled = false
    var photosCheckerGotIndex = false
    
    var  photoStructureWasCalled = false
    var photoStructureGotIndex = false
    
    var tapLikeWasCalled = false
    var tapLikeGotIndex = false
    
    func viewDidLoad() {
        viewDidLoadWasCalled = true
    }
    
    func updateTableViewAnimated() {
        animationWasCalled = true
    }
    
    func calculateHeight(indexPath: IndexPath) -> CGFloat {
        heightCalculatorWasCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            heightCalculatorGotIndexPath = true
        }
        return CGFloat(100)
    }
    
    
    func photosPerPageChecker(indexPath: IndexPath) {
        photosCheckerWasCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            photosCheckerGotIndex = true
        }
    }
    
    func getPhotoStructure(indexPath: IndexPath) -> image_feed.Photo? {
        photoStructureWasCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            photoStructureGotIndex = true
        }
        return nil
    }
    
    func imagesListCellDidTapLike(_ cell: image_feed.ImagesListCell, indexPath: IndexPath) {
        tapLikeWasCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            tapLikeGotIndex = true
        }
    }
}

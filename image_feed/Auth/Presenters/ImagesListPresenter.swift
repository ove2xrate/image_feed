import Foundation

import Foundation
import UIKit
import Kingfisher

// MARK: - Protocol

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var totalNumberOfPhotos: Int { get }
    
    func viewDidLoad()
    func updateTableViewAnimated()
    func calculateHeight(indexPath: IndexPath) -> CGFloat
    func photosPerPageChecker(indexPath: IndexPath)
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func getPhotoStructure(indexPath: IndexPath) -> Photo?
}

// MARK: - Class

final class ImagesListPresenter {
    
    // MARK: - Private properties
    
    private var imagesListService = ImagesListService.shared
    
    // MARK: - Public properties
    
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var totalNumberOfPhotos: Int {
        photos.count
    }
    // MARK: - Public method
    
    // non-private for unit tests
    func setupImageListService() {
        imagesListService.fetchPhotosNextPage()
        updateTableViewAnimated()
    }
}

// MARK: - ImagesListPresenterProtocol

extension ImagesListPresenter: ImagesListPresenterProtocol {
    func viewDidLoad() {
        view?.setupTableView()
        setupImageListService()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        photos = imagesListService.photos
        let newCount = photos.count
        
        if oldCount != newCount {
            view?.tableView.performBatchUpdates {
                let indexes = (oldCount..<newCount).map { index in
                    IndexPath(row: index, section: 0)
                }
                view?.tableView.insertRows(at: indexes, with: .automatic)
            }
        }
    }
    
    func calculateHeight(indexPath: IndexPath) -> CGFloat {
        guard let view else { return 0 }
        let thumbImageSize = photos[indexPath.row].thumbSize
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = view.tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = thumbImageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = thumbImageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func photosPerPageChecker(indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self ] result in
            guard let self else { return }
            switch result {
            case .success(let isLiked):
                self.photos[indexPath.row].isLiked = isLiked
                cell.likeCheck(isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                preconditionFailure("\(error.localizedDescription)")
            }
        }
    }
    
    func getPhotoStructure(indexPath: IndexPath) -> Photo? {
        photos[indexPath.row]
    }
}

// MARK: - Private methods

private extension ImagesListPresenter {
  func setupKfCache() {
    let cache = ImageCache.default
    cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
    cache.memoryStorage.config.countLimit = 150
    cache.diskStorage.config.sizeLimit = 1024 * 1024 * 1024
    cache.memoryStorage.config.expiration = .seconds(600)
    cache.diskStorage.config.expiration = .days(10)
    cache.memoryStorage.config.cleanInterval = 300
  }
}

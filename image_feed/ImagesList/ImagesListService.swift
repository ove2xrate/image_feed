import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let session = URLSession.shared
    private let requestBuilder = URLRequestBuilder.shared
    private let dateFormatter = ISO8601DateFormatter()
    
    private var currentTask: URLSessionTask?
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    
    private init() { }
    
    func makeLikeRequest(for id: String, with method: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: "/photos/\(id)/like", httpMethod: method)
    }
    
    func makePhotosListRequest(page: Int) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&&per_page=\(10)"
        )
    }
    
    func makeNextPageNumber() -> Int {
        guard let lastLoadedPage else { return 1 }
        return lastLoadedPage + 1
    }
    
    func convert(result photoResult: PhotoResult) -> Photo {
        let thumbWidth = 200.0
        let aspectRatio = Double(photoResult.width) / Double(photoResult.height)
        let thumbHeight = thumbWidth / aspectRatio
        let date = photoResult.createdAt.flatMap { dateFormatter.date(from: $0) }
        return Photo(
            id: photoResult.id,
            size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)),
            createdAt: date,
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.small,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser,
            thumbSize: CGSize(width: thumbWidth, height: thumbHeight)
        )
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard currentTask == nil else { return }
        let method = isLike ? "POST" : "DELETE"
        
        guard let request = makeLikeRequest(for: photoId, with: method) else {
            assertionFailure("Invalid request")
            print(NetworkError.invalidRequest)
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let photoLiked):
                    let likedByUser = photoLiked.photo.likedByUser
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: likedByUser,
                            thumbSize: photo.thumbSize
                        )
                        self.photos[index] = newPhoto
                    }
                    completion(.success(likedByUser))
                    self.currentTask = nil
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        currentTask = task
        task.resume()
    }
    
    func clearPhotosArray() {
        photos = []
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard currentTask == nil else {
            return
        }
        
        let nextPage = makeNextPageNumber()
        
        guard let request = makePhotosListRequest(page: nextPage) else {
            assertionFailure("Invalid request")
            print(NetworkError.invalidRequest)
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { preconditionFailure("Can't create weak link") }
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    var photos: [Photo] = []
                    photoResults.forEach { photo in
                        photos.append(self.convert(result: photo))
                    }
                    self.photos += photos
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    self.lastLoadedPage = nextPage
                }
            case .failure(let error):
                print("\(String(describing: error))")
            }
            self.currentTask = nil
        }
        currentTask = task
        task.resume()
    }
}

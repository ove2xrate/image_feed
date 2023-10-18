import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = [] {
        didSet {
            NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
        }
    }
    
    static let DidChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private var currentPage = 1
    private var lastLoadedPage: Int?
    
    private var isLoadingInProgress = false
    private var photoId = Photo.CodingKeys.id
    
    func fetchPhotosNextPage() {
        guard !isLoadingInProgress else {
            return
        }
        
        isLoadingInProgress = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let url = URL(string: "https://api.unsplash.com/photos?client_id=\(accessKey)&page=\(self.currentPage)&per_page=10") else {
            isLoadingInProgress = false
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.isLoadingInProgress = false
                return
            }
            
            if let data = data {
                if String(data: data, encoding: .utf8) != nil {
                }
                
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let photos = try decoder.decode([Photo].self, from: data)
                        
                        if photos.isEmpty {
                            
                        } else {
                            if nextPage == 1 {
                                self.photos = photos
                            } else {
                                self.photos.append(contentsOf: photos)
                            }
                            self.lastLoadedPage = nextPage
                            self.currentPage += 1
                        }
                        
                        NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self)
                        
                    } catch {
                    }
                    
                    self.isLoadingInProgress = false
                }
            }
        }
        task.resume()
    }
}

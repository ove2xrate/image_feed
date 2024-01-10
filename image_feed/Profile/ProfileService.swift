import Foundation
import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    
    private var urlSession = URLSession.shared
    private let requestBuilder: URLRequestBuilder
    private var fetchProfileTask: URLSessionTask?
    private(set) var profile: Profile?
    
    init(urlSession: URLSession = .shared, requestBuilder: URLRequestBuilder = .shared) {
        self.urlSession = urlSession
        self.requestBuilder = requestBuilder
    }
}

private extension ProfileService {
    
    func makeProfileRequest() -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: AuthConfigConstants.profileRequestPathString)
    }
}

extension ProfileService {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if fetchProfileTask != nil { return }
        fetchProfileTask?.cancel()
        
        guard let request = makeProfileRequest() else {
            assertionFailure("Invalid request")
            completion(.failure(ProfileError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) {
            [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            self.fetchProfileTask = nil
            switch result {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(_):
                completion(.failure(ProfileError.decodingFailed))
            }
        }
        self.fetchProfileTask = task
        task.resume()
    }
}

enum ProfileError: Error {
    case unauthorized
    case invalidData
    case invalidRequest
    case decodingFailed
}

private struct ProfileKeys {
    static let noBio = ""
    static let noLastname = ""
}

enum ProfileServiceError: Error {
    case invalidURL
    case invalidRequest
    case invalidData
    case decodingFailed
}

import Foundation

import Foundation
import WebKit
import Kingfisher

// MARK: - Protocol

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func resetAccount()
}

// MARK: - Class

final class ProfilePresenter {
    
    // MARK: - Public properties
    
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private properties
    
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private var oauth2TokenStorage = OAuth2TokenStorage.shared
}

// MARK: - ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    
    func viewDidLoad() {
        checkAvatar()
        checkProfile()
    }
    
    func resetAccount() {
        resetToken()
        resetView()
        resetPhotos()
        cleanCookies()
        switchToSplashViewController()
    }
}

// MARK: - Private methods

private extension ProfilePresenter {
    
    func checkAvatar() {
        if let url = profileImageService.avatarURL {
            view?.updateAvatar(url: url)
        }
    }
    
    func checkProfile() {
        guard let profile = profileService.profile else {
            return
        }
        view?.loadProfile(profile)
    }
    
    func resetToken() {
        guard oauth2TokenStorage.deleteToken() else {
            assertionFailure("Failed remove token")
            return
        }
    }
    
    func resetView() {
        view?.loadProfile(nil)
    }
    
    func resetPhotos() {
        ImagesListService.shared.clearPhotosArray()
    }
    
    func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) { }
            }
        }
    }
    
    func switchToSplashViewController() {
        
        guard let window = UIApplication.shared.windows.first else {
            preconditionFailure("Invalid Configuration") }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}

import Foundation
import WebKit
import Kingfisher

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logout()
}

final class ProfilePresenter {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private var oauth2TokenStorage = OAuth2TokenStorage.shared
}

extension ProfilePresenter: ProfilePresenterProtocol {
    
    func viewDidLoad() {
        checkAvatar()
        checkProfile()
    }
    
    func logout() {
        oauth2TokenStorage.deleteToken()
        resetView()
        ImagesListService.shared.clearPhotosArray()
        removeCookiesAndWebData()
        switchToSplashViewController()
    }
}

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
        view?.fillProfileDetails(profile)
    }
    
    func resetView() {
        view?.fillProfileDetails(nil)
    }
    
    func removeCookiesAndWebData() {
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

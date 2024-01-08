import Foundation
import UIKit.UILabel
@testable import image_feed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var viewDidUpdateAvatar = false
    var viewDidLoadProfile = false
    
    var profileUserNameLabel = UILabel()
    var profileLoginNameLabel = UILabel()
    var profileBioLabel = UILabel()
    
    func updateAvatar(url: URL) {
        viewDidUpdateAvatar = true
    }
    
    func fillProfileDetails(_ profile: Profile?) {
        viewDidLoadProfile = true
        if let profile {
            profileUserNameLabel.text = profile.name
            profileLoginNameLabel.text = profile.loginName
            profileBioLabel.text = profile.bio
        }
    }
}

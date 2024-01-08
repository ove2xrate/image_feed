import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func fillProfileDetails(_ profile: Profile?)
}

final class ProfileViewController: UIViewController {
    private var profileUserNameLabel = UILabel()
    private var profileLoginNameLabel = UILabel()
    private var profileBioLabel = UILabel()
    private let profileUserPhotoImage = UIImageView()
    private var logoutButton: UIButton!
    
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    var presenter: ProfilePresenterProtocol?
    let profileImagePlaceholder = UIImage(named: "placeholder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1A1B22")
        presenter?.viewDidLoad()
        
        NotificationObserver()
        
        setupImageView()
        setupLabels()
        setupButton()
    }
}

private extension ProfileViewController {
    
    @objc func didTapButton() {
        showLogoutAlert()
    }
    
    @objc func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo[Notification.userInfoImageURLKey] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        updateAvatar(url: url)
    }
    
    func NotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                guard let self else { return }
                self.updateAvatar(notification: notification)
            }
        )
    }
    
    private func showLogoutAlert() {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "Да",
            style: .default,
            handler: { (_) in
                self.presenter?.logout()
            }
        )
        
        let noAction = UIAlertAction(
            title: "Нет",
            style: .default,
            handler: nil
        )
        
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupImageView() {
        profileUserPhotoImage.image = profileImagePlaceholder
        profileUserPhotoImage.tintColor = .gray
        
        profileUserPhotoImage.accessibilityIdentifier = "ProfilePhoto"
        
        profileUserPhotoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileUserPhotoImage)
        
        NSLayoutConstraint.activate([
            profileUserPhotoImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileUserPhotoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileUserPhotoImage.widthAnchor.constraint(equalToConstant: 70),
            profileUserPhotoImage.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupLabels() {
        
        profileUserNameLabel.accessibilityIdentifier = "ProfileName"
        profileUserNameLabel.textColor = .white
        let font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18 / font.pointSize
        let attributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        profileUserNameLabel.attributedText = NSAttributedString(string: profileUserNameLabel.text ?? "", attributes: attributes)
        
        profileUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileUserNameLabel)
        
        
        profileLoginNameLabel.accessibilityIdentifier = "ProfileLogin"
        profileLoginNameLabel.textColor = .gray
        let font2 = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: font2,
            .paragraphStyle: paragraphStyle
        ]
        profileLoginNameLabel.attributedText = NSAttributedString(string: profileLoginNameLabel.text ?? "", attributes: attributes2)
        profileLoginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLoginNameLabel)
        
        
        profileBioLabel.accessibilityIdentifier = "ProfileBio"
        profileBioLabel.textColor = .white
        let font3 = UIFont.systemFont(ofSize: 13, weight: .regular)
        profileBioLabel.font = font3
        profileBioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileBioLabel)
        
        NSLayoutConstraint.activate([
            profileUserNameLabel.leadingAnchor.constraint(equalTo: profileUserPhotoImage.leadingAnchor),
            profileUserNameLabel.topAnchor.constraint(equalTo: profileUserPhotoImage.bottomAnchor, constant: 20),
            profileLoginNameLabel.leadingAnchor.constraint(equalTo: profileUserNameLabel.leadingAnchor),
            profileLoginNameLabel.topAnchor.constraint(equalTo: profileUserNameLabel.bottomAnchor, constant: 20),
            profileBioLabel.leadingAnchor.constraint(equalTo: profileUserNameLabel.leadingAnchor),
            profileBioLabel.topAnchor.constraint(equalTo: profileLoginNameLabel.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupButton() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage(),
            target: self,
            action: #selector(self.didTapButton)
        )
        
        logoutButton.accessibilityIdentifier = "LogoutButton"
        
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: profileUserPhotoImage.centerYAnchor)
        ])
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    
    func fillProfileDetails(_ profile: Profile?) {
        if let profile = profileService.profile {
            profileUserNameLabel.text = profile.name
            profileLoginNameLabel.text = profile.loginName
            profileBioLabel.text = profile.bio
        } else {
            profileUserNameLabel.text = "Error"
            profileLoginNameLabel.text = "Error"
            profileBioLabel.text = "Error"
            profileUserPhotoImage.image = profileImagePlaceholder
        }
    }
    
    func updateAvatar(url: URL) {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileUserPhotoImage.kf.indicatorType = .activity
        profileUserPhotoImage.kf.setImage(with: url,
                                          placeholder: UIImage(named: "placeholder"),
                                          options: [.processor(processor)])
    }
}

extension Notification {
    
    static let userInfoImageURLKey: String = "URL"
    
    var userInfoImageURL: String? {
        userInfo?[Notification.userInfoImageURLKey] as? String
    }
}

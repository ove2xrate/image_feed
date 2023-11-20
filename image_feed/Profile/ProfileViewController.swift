import UIKit
import WebKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var loginLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(hex: "#AEAFB4")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var logoutButton:UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "Logout") ?? UIImage(),
                                           target: self,
                                           action: #selector(didTapButton)
        )
        button.tintColor = UIColor(hex: "#F56B6C")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "user_picture")
        image.tintColor = .gray
        image.clipsToBounds = true
        image.layer.cornerRadius = 35
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        loadAvatar()
        preparingProfileDetails(profile: profileService.profile)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillProfileDetails()
    }
    
    @objc private func didTapButton() {
        showLogoutAlert()
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
                self.logout()
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
    
    @objc func updateAvatar(notification: Notification) {
        guard
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo[Notification.userInfoImageURLKey] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        updateAvatar(url: url)
    }
    
    func loadAvatar() {
        if let url = profileImageService.avatarURL {
            updateAvatar(url: url)
        }
    }
    
    func updateAvatar(url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url,
                                 placeholder: UIImage(named: "placeholder"),
                                 options: [.processor(processor)])
    }
    
    func preparingProfileDetails(profile: Profile?) {
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
    
    func fillProfileDetails() {
        if let profile = profileService.profile {
            nameLabel.text = profile.name
            loginLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        } else {
            nameLabel.text = ""
            loginLabel.text = ""
            descriptionLabel.text = ""
        }
    }
    
    private func layout() {
        view.backgroundColor = UIColor(hex: "#1A1B22")
        
        view.addSubview(logoutButton)
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            
            loginLabel.heightAnchor.constraint(equalToConstant: 18),
            loginLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45)
        ])
    }
    
    private func logout() {
        removeCookiesAndWebData()
        OAuth2TokenStorage.shared.deleteToken()
        ImagesListService.shared.clearPhotosArray()
        switchToSplashViewController()
    }
    
    func removeCookiesAndWebData() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func switchToSplashViewController() {
        
        guard let window = UIApplication.shared.windows.first else { preconditionFailure("Invalid Configuration") }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}

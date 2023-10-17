import UIKit
import WebKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter = AlertPresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        layout()
        UIBlockingProgressHUD.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        authStatusChecker()
    }
    
    private func authStatusChecker () {
        guard UIBlockingProgressHUD.isShowing == false else { return }
        
        if oauth2Service.isAuthenticated {
            UIBlockingProgressHUD.show()
            fetchProfile {
                [weak self] in
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()
            }
        } else {
            switchToAuthViewController()
        }
    }
    
    private func showLoginAlert(error: Error) {
        alertPresenter.showAlert(title: "Что-то пошло не так",
                                 message: "Не удалось войти в систему, \(error.localizedDescription)") {
            
            self.switchToAuthViewController()
    }
}
        
    private func switchToAuthViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { preconditionFailure("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func layout() {
        view.backgroundColor = UIColor(hex: "#1A1B22")
        
        let splashScreenImage: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "launchscreen")
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        } ()
        
        view.addSubview(splashScreenImage)
        
        NSLayoutConstraint.activate([
            splashScreenImage.heightAnchor.constraint(equalToConstant: 78),
            splashScreenImage.widthAnchor.constraint(equalToConstant: 75),
            splashScreenImage.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            splashScreenImage.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        ])
    }
    
    private func fetchAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            switch result {
            case .success(_):
                self?.fetchProfile(completion: {
                    UIBlockingProgressHUD.dismiss()
                })
            case .failure(let error):
                self?.showLoginAlert(error: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfile(completion: @escaping () -> Void) {
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                let userName = profile.username
                self?.fetchProfileImage(userName: userName)
                self?.switchToTabBarController()
                completion()
            case .failure(let error):
                self?.showLoginAlert(error: error)
            }
            completion()
        }
    }
    
    private func fetchProfileImage(userName: String) {
        
        profileImageService.fetchProfileImageURL(userName: userName) { [weak self] profileImageUrl in
            
            guard let self else { return }
            
            switch profileImageUrl {
            case .success(let mediumPhoto):
                print("\(mediumPhoto)")
            case .failure(let error):
                self.showLoginAlert(error: error)
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) {
            [weak self] in
            guard let self else { return }
            self.fetchAuthToken(code)
        }
    }
}

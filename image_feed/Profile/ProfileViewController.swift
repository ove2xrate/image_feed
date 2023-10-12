import UIKit

final class ProfileViewController: UIViewController {
    let profileImage = UIImage(named: "avatar")
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Image
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // MARK: - Label's
        let namelabel = UILabel()
        let loginNameLabel = UILabel()
        let descriptionLabel = UILabel()
        
        namelabel.text = "Екатерина Новикова"
        loginNameLabel.text = "@ekaterina_nov"
        descriptionLabel.text = "Hello, world!"
        
        namelabel.textColor = .white
        loginNameLabel.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.705, alpha: 1)
        descriptionLabel.textColor = .white
        
        namelabel.font = UIFont.boldSystemFont(ofSize: 23)
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(namelabel)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        
        // MARK: - Button
        let button = UIButton.systemButton(
            with: UIImage(named: "Logout")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = UIColor(red: 0.961, green: 0.420, blue: 0.424, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        // MARK: - Constraint's
        NSLayoutConstraint.activate([
            namelabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            namelabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: namelabel.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: namelabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    // MARK: - Private Methods
    @objc
    private func didTapButton() {
    }
}


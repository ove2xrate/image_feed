import UIKit

final class ProfileViewController: UIViewController {
// MARK: - IBOutlet
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
// MARK: - IBAction
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
}

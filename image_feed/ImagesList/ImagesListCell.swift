import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Private Properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}

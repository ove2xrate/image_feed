import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

public final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    private let placeholderImage = UIImage(named: "placeholder_loading")
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imagesListCellDidTapLike(self)
    }
    
    func likeCheck(_ isLiked: Bool) {
        let likedImage = isLiked ? UIImage(named: "Like") : UIImage(named: "Unlike")
        likeButton.setImage(likedImage, for: .normal)
    }
    
    func loadCell(from photo: Photo) -> Bool {
        
        var status = false
        
        if let photoDate = photo.createdAt {
            dateLabel.text = longDateFormatter.string(from: photoDate)
        } else {
            dateLabel.text = ""
        }
        likeButton.accessibilityIdentifier = "LikeButton"
        
        likeCheck(photo.isLiked)
        
        guard let photoURL = URL(string: photo.thumbImageURL) else { return status }
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photoURL, placeholder: placeholderImage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                status = true
            case .failure(let error):
                cellImage.image = placeholderImage
                preconditionFailure("\(error.localizedDescription)")
            }
        }
        return status
    }
}

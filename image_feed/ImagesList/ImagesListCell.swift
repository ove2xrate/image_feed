import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    private let placeholderImage = UIImage(named: "placeholder_loading")
    weak var delegate: ImagesListCellDelegate?
    
    let longDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMMM YYYY"
        return df
    }()
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
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
        
        likeCheck(photo.isLiked)
        
        guard let photoURL = URL(string: photo.thumbImageURL) else { return status }
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photoURL, placeholder: placeholderImage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                status = true
            case .failure(_):
                cellImage.image = placeholderImage
            }
        }
        return status
    }
}

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
// MARK: - IBOutlet
    @IBOutlet var imageView: UIImageView!
    
// MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}

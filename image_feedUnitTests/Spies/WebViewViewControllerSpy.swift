import Foundation
import image_feed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: image_feed.WebViewPresenterProtocol?
    var viewDidLoadRequest = false
    
    func load(request: URLRequest) {
        viewDidLoadRequest = true
    }
    
    func setProgressValue(_ newValue: Float) { }
    
    func setProgressHidden(_ flag: Bool) { }
}

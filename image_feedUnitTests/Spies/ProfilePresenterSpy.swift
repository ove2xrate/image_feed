import Foundation
@testable import image_feed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var viewDidResetAccount = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logout() {
        viewDidResetAccount = true
    }
}

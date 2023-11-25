import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() { }
    
    private let keyChainStorage = KeychainWrapper.standard
    
    var token: String? {
        get {
            keyChainStorage.string(forKey: .tokenKey)
        }
        set {
            if let token = newValue {
                keyChainStorage.set(token, forKey: .tokenKey)
            } else { return }
        }
    }
    
    func deleteToken() -> Bool {
        keyChainStorage.removeObject(forKey: .tokenKey)
    }
}

extension String {
    static let tokenKey = "bearerToken"
}

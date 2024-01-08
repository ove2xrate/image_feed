import Foundation

// MARK: - Protocol

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

// MARK: - Class & AuthHelperProtocol

final class AuthHelper: AuthHelperProtocol {
    
    // MARK: - Public properties
    
    let configuration: AuthConfiguration
    
    // MARK: - Init
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    // MARK: - Nested types
    
    private enum WebConstants {
        static let clientId: String = "client_id"
        static let redirectUri: String = "redirect_uri"
        static let responseType: String = "response_type"
        static let scope: String = "scope"
    }
    
    // MARK: - Public methods
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: WebConstants.clientId, value: configuration.accessKey),
            URLQueryItem(name: WebConstants.redirectUri, value: configuration.redirectURI),
            URLQueryItem(name: WebConstants.responseType, value: AuthConfigConstants.code),
            URLQueryItem(name: WebConstants.scope, value: configuration.accessScope)
        ]
        guard let url = urlComponents.url else {
            preconditionFailure("Incorrect URL: \(String(describing: urlComponents.url))")
        }
        return url
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == AuthConfigConstants.authorizedURLPath,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == AuthConfigConstants.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURL: URL)
    {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        AuthConfiguration(
            accessKey: AuthConfigConstants.accessKey,
            secretKey: AuthConfigConstants.secretKey,
            redirectURI: AuthConfigConstants.redirectURI,
            accessScope: AuthConfigConstants.accessScope,
            authURLString: AuthConfigConstants.unsplashAuthorizeURLString,
            defaultBaseURL: AuthConfigConstants.defaultBaseURL!)
    }
}

import Foundation

enum AuthConfigConstants {
    static let accessKey = "FZZcSz8S8wEx54SSGEsaf2yP1tddEDgInUijZhE2tO0"
    static let secretKey = "S4OyUQZZOG1haTy7HweItLrWsz8XwzsVqidPLHnipcY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let baseURLString = "https://unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    static let authorizedURLPath = "/oauth/authorize/native"
    static let tokenRequestPathString = "/oauth/token"
    static let profileRequestPathString = "/me"
    
    static let postMethodString = "POST"
    static let getMethodString = "GET"
    static let deleteMethodString = "DELETE"
    
    static let tokenRequestGrantTypeString = "authorization_code"
    static let code = "code"
    static let bearerToken = "bearerToken"
}

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
    
    // MARK: - DateFormatter
    let longDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "d MMMM YYYY"
    return df
}()

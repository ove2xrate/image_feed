import Foundation

enum AuthConfigConstants {
    
    static let accessKey = "FZZcSz8S8wEx54SSGEsaf2yP1tddEDgInUijZhE2tO0"
    static let secretKey = "S4OyUQZZOG1haTy7HweItLrWsz8XwzsVqidPLHnipcY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let baseURLString = "https://unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    // MARK: - Unsplash base AIP paths
    static let authorizedURLPath = "/oauth/authorize/native"
    static let tokenRequestPathString = "/oauth/token"
    static let profileRequestPathString = "/me"
    
    // MARK: - Request method's strings
    static let postMethodString = "POST"
    static let getMethodString = "GET"
    static let deleteMethodString = "DELETE"
    
    // MARK: - Storage constants
    static let tokenRequestGrantTypeString = "authorization_code"
    static let code = "code"
    static let bearerToken = "bearerToken"
}

// MARK: - DateFormatter
let longDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "d MMMM YYYY"
    return df
}()

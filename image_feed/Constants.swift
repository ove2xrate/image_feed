import Foundation

let accessKey: String = "FZZcSz8S8wEx54SSGEsaf2yP1tddEDgInUijZhE2tO0"
let secretKey: String = "S4OyUQZZOG1haTy7HweItLrWsz8XwzsVqidPLHnipcY"
let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
let accessScope: String = "public+read_user+write_likes"
let defaultBaseURL = URL(string: "https://unsplash.com/oauth/token")!

enum Constants: String {
    case accessKey = "FZZcSz8S8wEx54SSGEsaf2yP1tddEDgInUijZhE2tO0"
    case secretKey = "S4OyUQZZOG1haTy7HweItLrWsz8XwzsVqidPLHnipcY"
    case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    case accessScope = "public+read_user+write_likes"
    case defaultBaseURL = "https://unsplash.com/oauth/token"
}

import Foundation

class Session {
    static let instance = Session()
    
    private init() {}
    
    var userId: Int = 0
    var token: String = ""
    var tokenExpires: Int = 0
}

import Foundation

class Session {
    static let instance = Session()
    
    private init() {}
    
    var userId: String = ""
    var token: Int = 0
}

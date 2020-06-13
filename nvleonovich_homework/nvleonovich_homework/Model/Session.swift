import Foundation

class Session {
    static let instance = Session()
    
    private init() {}
    
    let userId: String = ""
    let token: Int = 0
}

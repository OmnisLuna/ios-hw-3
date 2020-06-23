import Foundation

class Storage {
    
    static let instance = Storage()
    
    private init() {}
    
    var myFriends: [User] = []
    var myGroups: [Group] = []
    var allGroups: [Group] = []
    var allUserPhotos: [Photo] = []
}

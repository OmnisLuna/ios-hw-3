import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

struct Photo {
    //фотография
    let id: Int
    let ownerId: Int
    var url: String
    var isLikedByMe: Bool
    var likesCount: Int
    
//    init(json: JSON) {
//        self.id = json["id"].intValue
//        self.ownerId = json["owner_id"].intValue
//        self.url = json["sizes"][3]["url"].stringValue
//        self.isLikedByMe = json["likes"]["user_likes"].boolValue
//        self.likesCount = json["likes"]["count"].intValue
//    }
}

class PhotoRealm: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    var sizes = List<PhotoRealmSize>()
    var likes = Likes()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension PhotoRealm {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownerId = "owner_id"
        case sizes = "sizes"
        case likes = "likes"

    }
}

struct PhotoRealmResponse: Decodable {
    let response: PhotoRealmItems
}

struct PhotoRealmItems: Decodable {
    let items: [PhotoRealm]
}

class PhotoRealmSize: Object, Decodable {
    @objc dynamic var height: Int
    @objc dynamic var url: String
    @objc dynamic var type: String
    @objc dynamic var width: Int
    
    let owner = LinkingObjects(fromType: PhotoRealm.self, property: "sizes")
}

extension PhotoRealmSize {
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case url = "url"
        case type = "type"
        case width = "width"
    }
}

class Likes: Object, Decodable {
    @objc dynamic var isLikedByMe: Bool
    @objc dynamic var likesCount: Int

    let owner = LinkingObjects(fromType: PhotoRealm.self, property: "likes")
}

extension Likes {
    enum CodingKeys: String, CodingKey {
        case isLikedByMe = "user_likes"
        case likesCount = "count"
    }
}



import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class MyGroupRealm: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var isMember: Int
    @objc dynamic var avatar: String
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension MyGroupRealm {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case avatar = "photo_100"
        case isMember = "is_member"
    }
}

struct MyGroupRealmResponse: Decodable {
    let response: MyGroupRealmItems
}

struct MyGroupRealmItems: Decodable {
    let items: [MyGroupRealm]
}

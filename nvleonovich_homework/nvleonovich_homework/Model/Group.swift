import UIKit
import SwiftyJSON
import Alamofire

class Group {
    //данные элемента группа
    let id: Int
    var name: String
    var isMember: Int
    var avatar: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.isMember = json["is_member"].intValue
        self.avatar = json["photo_100"].stringValue
    }
}

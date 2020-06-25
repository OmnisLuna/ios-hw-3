import UIKit
import SwiftyJSON
import Alamofire

class Photo {
    //фотография
    let id: Int
    let ownerId: Int
    var url: String
    var isLikedByMe: Bool
    var likesCount: Int

//    var pic: UIImage
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.url = json["sizes"][3]["url"].stringValue
        self.isLikedByMe = json["likes"]["user_likes"].boolValue
        self.likesCount = json["likes"]["count"].intValue
    }
}


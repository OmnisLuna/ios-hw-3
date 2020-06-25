import SwiftyJSON
import Alamofire

class LikesWorker {
    
    func addLike(_ itemId: Int, _ ownerId: Int) {
        let parameters: Parameters = [
                "access_token": "\(Session.instance.token)",
                "v": "5.110",
                "owner_id": "\(ownerId)",
                "item_id": "\(itemId)",
                "type": "photo",
               ]
        AF.request("https://api.vk.com/method/likes.add", method: .post, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
    
    func deleteLike(_ itemId: Int, _ ownerId: Int) {
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "owner_id": "\(ownerId)",
            "item_id": "\(itemId)",
            "type": "photo",
           ]
               
        AF.request("https://api.vk.com/method/likes.delete", method: .post, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
}

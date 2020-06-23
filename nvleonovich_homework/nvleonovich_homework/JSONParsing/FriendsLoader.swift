import SwiftyJSON
import Alamofire

class FriendsLoader {

    func getMyFriends(completion: @escaping (_ friends: [User]) -> ()) {
        
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "user_id": "\(Session.instance.userId)",
            "fields": "photo_100, nickname",
        ]
        
        AF.request("https://api.vk.com/method/friends.get", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            let json = JSON(response.value!)
            let friends = json["response"]["items"].map { User(json: $0.1) }
            completion(friends)
//            print(friends)
        }
    }
}

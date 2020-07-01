import SwiftyJSON
import Alamofire

class UsersLoader {

    func getUsersInfo(ids: [Int]) -> [User] {
        
        var users: [User] = []
        
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "user_ids": "\(ids)",
            "fields": "photo_100",
        ]
        
        AF.request("https://api.vk.com/method/users.get", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            let json = JSON(response.value!)
//            users = json["response"].map { User(json: $0.1) }
        }
        print("Пользователи: \(users)") //сделано для проверки во время разработки, что сами данные существуют
        return users
    }
}

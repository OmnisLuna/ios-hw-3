import SwiftyJSON
import Alamofire

class PhotosLoader {
    
    func getAllPhotosByOwnerId (ownerId: Int, completion: @escaping (_ friends: [Photo]) -> ()) {
        
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "count": "10",
            "owner_id": "\(ownerId)", //без owner_id приходят фото авторизованного пользователя
            "extended": "1",
        ]

       AF.request("https://api.vk.com/method/photos.getAll", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
        let json = JSON(response.value!)
        let photos = json["response"]["items"].map { Photo(json: $0.1) }
        completion(photos)
       }
    }
}

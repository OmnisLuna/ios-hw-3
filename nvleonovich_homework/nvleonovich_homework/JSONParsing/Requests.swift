import SwiftyJSON
import Alamofire
import RealmSwift

class Requests {
    static let instance = Requests()
    
    private let baseUrl = "https://api.vk.com/method/"
    private var customUrl = ""
    private let apiVersion = "5.103"
    private let accessToken = Session.instance.token
    
    private init() {}
    
    func getMyFriends(handler: @escaping (Result<[UserRealm], Error>) -> Void) {
            customUrl = "friends.get"
            let fullUrl = baseUrl + customUrl
            let parameters: Parameters = [
                "access_token": accessToken,
                "v": apiVersion,
                "user_id": "\(Session.instance.userId)",
                "fields": "photo_100, nickname",
            ]
        
        AF.request(fullUrl,
                   method: .get,
                   parameters: parameters)
            .validate()
            .responseData(completionHandler: { responseData in
                guard let data = responseData.data else { return }
                let decoder = JSONDecoder()
                do {
                    let requestResponse = try decoder.decode(UserRealmResponse.self, from: data)
                    RealmHelper.instance.saveObjects(requestResponse.response.items)
                    
                } catch {
                    handler(.failure(error))
                }
            })
        }
    
    func getAllPhotosByOwnerId (ownerId: Int, handler: @escaping (Result<[PhotoRealm], Error>) -> Void) {
        customUrl = "photos.getAll"
        let fullUrl = baseUrl + customUrl
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "count": "10",
            "owner_id": "\(ownerId)", //без owner_id приходят фото авторизованного пользователя
            "extended": "1",
        ]

//       AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
//        let json = JSON(response.value!)
//        let photos = json["response"]["items"].map { Photo(json: $0.1) }
//        completion(photos)
//       }
        AF.request(fullUrl,
                   method: .get,
                   parameters: parameters)
            .validate()
            .responseData(completionHandler: { responseData in
                guard let data = responseData.data else { return }
                let decoder = JSONDecoder()
                do {
                    let requestResponse = try decoder.decode(PhotoRealmResponse.self, from: data)
                    RealmHelper.instance.saveObjects(requestResponse.response.items)
                    
                } catch {
                    handler(.failure(error))
                }
            })
    }

    func getMyGroups(handler: @escaping (Result<[PhotoRealm], Error>) -> Void) {
        customUrl = "groups.get"
        let fullUrl = baseUrl + customUrl
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "owner_id": "\(Session.instance.userId)",
            "extended": "1"
        ]
        
//        AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
//            let json = JSON(response.value!)
//            let groups = json["response"]["items"].map { Group(json: $0.1) }
//            completion(groups)
//        }
        
        AF.request(fullUrl,
                    method: .get,
                    parameters: parameters)
             .validate()
             .responseData(completionHandler: { responseData in
                 guard let data = responseData.data else { return }
                 let decoder = JSONDecoder()
                 do {
                     let requestResponse = try decoder.decode(GroupRealmResponse.self, from: data)
                     RealmHelper.instance.saveObjects(requestResponse.response.items)
                     
                 } catch {
                     handler(.failure(error))
                 }
             })
    }

    func getGroupByQuery() {
        customUrl = "groups.search"
        let fullUrl = baseUrl + customUrl

        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "q": ""
        ]
        
        AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            print("Группы, найденные по запросу \(response.value!)")
        }
    }
    
    func getGroupsCatalog(completion: @escaping (_ groups: [Group]) -> ()) {
        customUrl = "groups.getCatalog"
        let fullUrl = baseUrl + customUrl
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "extended": "1"
        ]
        
        AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            let json = JSON(response.value!)
            let groups = json["response"]["items"].map { Group(json: $0.1) }
            completion(groups)
        }
        }
    
    func joinGroup(id: Int) {
        customUrl = "groups.join"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "group_id": "\(id)"
        ]
        
        AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
    
    func leaveGroup(id: Int) {
        customUrl = "groups.leave"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
               "access_token": accessToken,
               "v": apiVersion,
               "group_id": "\(id)"
           ]
               
        AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
    
    func getUsersInfo(ids: [Int]) -> [User] {
        customUrl = "users.get"
        let fullUrl = baseUrl + customUrl
        
        var users: [User] = []
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "user_ids": "\(ids)",
            "fields": "photo_100",
        ]
        
        AF.request(fullUrl, method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            let json = JSON(response.value!)
//            users = json["response"].map { User(json: $0.1) }
        }
        print("Пользователи: \(users)") //сделано для проверки во время разработки, что сами данные существуют
        return users
    }
    
    func addLike(_ itemId: Int, _ ownerId: Int) {
        customUrl = "likes.add"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
                "access_token": accessToken,
                "v": apiVersion,
                "owner_id": "\(ownerId)",
                "item_id": "\(itemId)",
                "type": "photo",
               ]
        AF.request(fullUrl, method: .post, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
    
    func deleteLike(_ itemId: Int, _ ownerId: Int) {
        customUrl = "likes.delete"
        let fullUrl = baseUrl + customUrl
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "owner_id": "\(ownerId)",
            "item_id": "\(itemId)",
            "type": "photo",
           ]
               
        AF.request(fullUrl, method: .post, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
}

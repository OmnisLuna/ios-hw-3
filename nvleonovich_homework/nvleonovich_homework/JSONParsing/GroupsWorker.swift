import SwiftyJSON
import Alamofire

class GroupsWorker {

    func getMyGroups(completion: @escaping (_ groups: [Group]) -> ())  {
        
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "owner_id": "\(Session.instance.userId)",
            "extended": "1"
        ]
        
        AF.request("https://api.vk.com/method/groups.get", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            let json = JSON(response.value!)
            let groups = json["response"]["items"].map { Group(json: $0.1) }
            completion(groups)
        }
    }

    func getGroupByQuery() {
        
        print()

        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "q": ""
        ]
        
        AF.request("https://api.vk.com/method/groups.search", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            print("Группы, найденные по запросу \(response.value!)")
        }
    }
    
    func getGroupsCatalog(completion: @escaping (_ groups: [Group]) -> ()) {
        
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "extended": "1"
        ]
        
        AF.request("https://api.vk.com/method/groups.getCatalog", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            let json = JSON(response.value!)
            let groups = json["response"]["items"].map { Group(json: $0.1) }
            completion(groups)
        }
        }
    
    func joinGroup(id: Int) {
        
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "group_id": "\(id)"
        ]
        
        AF.request("https://api.vk.com/method/groups.join", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
    
    func leaveGroup(id: Int) {
        let parameters: Parameters = [
               "access_token": "\(Session.instance.token)",
               "v": "5.110",
               "group_id": "\(id)"
           ]
               
        AF.request("https://api.vk.com/method/groups.leave", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in

        }
    }
}

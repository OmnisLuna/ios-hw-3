//
//  UserProfile.swift
//  nvleonovich_homework
//
//  Created by nvleonovich on 01.04.2020.
//  Copyright © 2020 nvleonovich. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

struct User {
    var id: Int = 0
    var name: String = ""
    var surname: String = ""
    var avatar: String = ""
    
//    init(id: Int, name: String, avatar: UIImage, photos: Array<Photo>, groups: Array<Group>) {
//        self.id = id
//        self.name = name
//        self.avatar = avatar
//        self.photos = photos //все фотографии пользователя,
//        self.groups = groups //все группы в которых состоит пользователь
//    }
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.surname = json["last_name"].stringValue
        self.avatar = json["photo_100"].stringValue
    }
}
    


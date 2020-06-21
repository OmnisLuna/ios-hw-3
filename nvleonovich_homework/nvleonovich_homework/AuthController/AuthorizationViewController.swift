//
//  AuthorizationViewController.swift
//  nvleonovich_homework
//
//  Created by nvleonovich on 21.06.2020.
//  Copyright © 2020 nvleonovich. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import WebKit

class AuthorizationViewController: UIViewController {


    @IBOutlet weak var webview: WKWebView!
        {
        didSet {
            webview.navigationDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doRequest()
    }
    
    func doRequest() {
            var urlComponents = URLComponents()
                
            urlComponents.scheme = "https"
            urlComponents.host = "oauth.vk.com"
            urlComponents.path = "/authorize"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: "7517453"),
                URLQueryItem(name: "display", value: "mobile"),
                URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                URLQueryItem(name: "scope", value: "262150"),
                URLQueryItem(name: "response_type", value: "token"),
                URLQueryItem(name: "v", value: "5.110")
            ]
            
            let request = URLRequest(url: urlComponents.url!)
            
            webview.load(request)

    }
    
    func getMyFriends() {
        
        print("Список друзей авторизованного пользователя")
        
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "user_id": "\(Session.instance.userId)",
        ]
        
        AF.request("https://api.vk.com/method/friends.get", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            print("Список друзей авторизованного пользователя \(response.value!)")
        }
    }
    
    func getMyGroups() {
        
        print()
    
        print("TOKEN = \(Session.instance.token)")
        
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "user_id": "\(Session.instance.userId)",
        ]
        
        AF.request("https://api.vk.com/method/groups.get", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            print("Группы авторизованного пользователя \(response.value!)")
        }
    }
    
    func getGroupByQuery() {
        
        print()

        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
            "q": "Парикхмахер"
        ]
        
        AF.request("https://api.vk.com/method/groups.search", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
            print("Группы, найденные по запросу \(response.value!)")
        }
    }
    
    func getAllPhotosByOwnerId() {
        
        print()
        
        let parameters: Parameters = [
            "access_token": "\(Session.instance.token)",
            "v": "5.110",
//            "owner_id": "-\(Session.instance.userId)", //без owner_id приходят фото авторизованного пользователя
        ]

               AF.request("https://api.vk.com/method/photos.getAll", method: .get, parameters: parameters, headers: nil).responseJSON { (response) in
                print("Все фотографии пользователя по его id \(response.value!)")
               }
    }
}

extension AuthorizationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        let id = params["user_id"]
        let userId = Int(id!) ?? 0
        Session.instance.userId = userId
        Session.instance.token = token!
        
        decisionHandler(.cancel)
        
        getMyFriends() //6. Получение списка друзей;
        getAllPhotosByOwnerId() //7. Получение фотографий человека;
        getMyGroups()    //8. Получение групп текущего пользователя;
        getGroupByQuery() //9. Получение групп по поисковому запросу;
    }
}

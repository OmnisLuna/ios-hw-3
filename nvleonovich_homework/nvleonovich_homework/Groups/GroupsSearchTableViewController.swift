import UIKit
import SDWebImage

class GroupsSearchTableViewController: UITableViewController {
    
    var allGroups: Array<Group> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GroupsWorker().getGroupsCatalog() { [weak self] groups in
                self?.allGroups = groups
                self?.tableView.reloadData()
            }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as! GroupTableViewCell
        cell.myGroupName.text = allGroups[indexPath.row].name
        cell.myGroupAvatar.sd_setImage(with: URL(string: allGroups[indexPath.row].avatar), placeholderImage: UIImage(named: ".png"))
        return cell
    }
}

//    var groupName = [
//        "Новости",
//        "Путешествия",
//        "Игры",
//        "Работа",
//        "Тренировки",
//        "Куда сходить",
//        "Рецепты",
//   ]/Users/nvleonovich/Public/ios-hw-3/ios-hw-3/nvleonovich_homework/nvleonovich_homework/Groups/GroupsSearchTableViewController.swift

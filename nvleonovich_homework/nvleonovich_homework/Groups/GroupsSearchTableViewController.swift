import UIKit
import SDWebImage
import RealmSwift

class GroupsSearchTableViewController: UITableViewController {
    
    @IBOutlet weak var tableAllGroupsView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allGroups = [GroupRealm]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableAllGroupsView.dataSource = self
        searchBar.delegate = self
        requestData()
    }
    
    private func requestData() {
        Requests.go.getGroupsCatalog { [weak self] result in
            //фильтруем группы, чтобы отображались только те, в которых текущий пользователь не участник
            let realm = try! Realm()
            self?.allGroups = Array(realm.objects(GroupRealm.self))
            self?.allGroups.sort{ $0.name < $1.name }
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
        cell.myGroupAvatar.sd_setImage(with: URL(string: allGroups[indexPath.row].avatar), placeholderImage: UIImage(named: "placeholder-1-300x200.png"))
        return cell
    }
}

extension GroupsSearchTableViewController: UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let realm = try! Realm()
        var sortedGroups = Array(realm.objects(GroupRealm.self))
        sortedGroups.sort{ $0.name < $1.name }
        allGroups = searchText.isEmpty ? sortedGroups : allGroups.filter { (group: GroupRealm) -> Bool in
            return group.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
}

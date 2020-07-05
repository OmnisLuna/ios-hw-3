import UIKit
import SDWebImage
import RealmSwift

class GroupsListTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableGroupsView: UITableView!
    
    var myGroups = [MyGroupRealm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableGroupsView.dataSource = self
        searchBar.delegate = self
        requestData()
        }
    
    private func requestData() {
        Requests.go.getMyGroups { [weak self] result in
            switch result {
            case .success(var groups):
                groups.sort{ $0.name < $1.name }
                self?.myGroups = groups
            case .failure(let error):
                print(error)
            }
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! MyGroupTableViewCell
        cell.name.text = myGroups[indexPath.row].name
        cell.avatar.sd_setImage(with: URL(string: myGroups[indexPath.row].avatar), placeholderImage: UIImage(named: "placeholder-1-300x200.png"))
        return cell
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        if segue.identifier == "AddGroup" {
        
            let allGroupsController = segue.source as! GroupsSearchTableViewController
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                let group = allGroupsController.allGroups[indexPath.row].id
                Requests.go.joinGroup(id: group)
                tableView.reloadData()
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let realm = try! Realm()
            let group = myGroups[indexPath.row].id
//            let groupForDelete = Array(realm.objects(GroupRealm.self).filter("id = %@", group))
//            RealmHelper.ask.deleteObjects(groupForDelete)
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Requests.go.leaveGroup(id: group)
            tableView.reloadData()
        }
    }
}

extension GroupsListTableViewController: UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let realm = try! Realm()
        var sortedGroups = Array(realm.objects(MyGroupRealm.self))
        sortedGroups.sort{ $0.name < $1.name }
        myGroups = searchText.isEmpty ? sortedGroups : myGroups.filter { (group: MyGroupRealm) -> Bool in
            return group.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
}

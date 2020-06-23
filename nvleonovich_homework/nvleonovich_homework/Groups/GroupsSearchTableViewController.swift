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
        cell.myGroupAvatar.sd_setImage(with: URL(string: allGroups[indexPath.row].avatar), placeholderImage: UIImage(named: "placeholder-1-300x200.png"))
        return cell
    }
}

import UIKit
import SDWebImage

class GroupsListTableViewController: UITableViewController {
    
    var myGroups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GroupsWorker().getMyGroups() { [weak self] groups in
                self?.myGroups = groups
                self?.tableView.reloadData()
            }
//        print(myGroups)
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
        cell.avatar.sd_setImage(with: URL(string: myGroups[indexPath.row].avatar), placeholderImage: UIImage(named: ".png"))
        return cell
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        if segue.identifier == "AddGroup" {
        
            let allGroupsController = segue.source as! GroupsSearchTableViewController
        
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                let group = allGroupsController.allGroups[indexPath.row].id
//                if !groupName.contains(group) {
//                    groupName.append(group)
                GroupsWorker().joinGroup(id: group)
                tableView.reloadData()
                }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            GroupsWorker().leaveGroup(id: myGroups[indexPath.row].id)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }

}

//    var groupName = [
//            "Книги",
//    ]
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

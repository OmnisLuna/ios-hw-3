import UIKit
import SDWebImage

class FriendsListViewController: UITableViewController {
    
    @IBOutlet var tableFriendsView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    //var sections = Array<Section>()
    var users = Array<User>()
    
    override func viewWillAppear(_ animated: Bool) {
        FriendsLoader().getMyFriends() { [weak self] friends in
                self?.users = friends
                self?.tableView.reloadData()
            }
        print(users)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableFriendsView.dataSource = self
        searchBar.delegate = self
        print(users)
    }
    
    //friends table sections
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return users.count
    }

    
    //friends table rows
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as! FriendTableViewCell
        let fullname = "\(users[indexPath.row].name) " + "\(users[indexPath.row].surname)"
        cell.myFriendName.text = "\(fullname)"
       cell.myFriendAvatar.sd_setImage(with: URL(string: users[indexPath.row].avatar), placeholderImage: UIImage(named: ".png"))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getFriendPhotos" {
            guard let target = segue.destination as? FriendsPhotoCollectionViewController,
                let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let currentUser = users[selectedIndexPath.row]
            target.currentUserId = currentUser.id
        }
    }
   
}

extension FriendsListViewController: UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        if searchText.isEmpty {
//            sortFriendsByName(friends: users)
//        } else {
//            let foundFriends = users.filter({ (friend: User) -> Bool in
//                return friend.name.lowercased().contains(searchText.lowercased())
//            })
//            sortFriendsByName(friends: foundFriends)
//        }
        tableView.reloadData()
    }
}

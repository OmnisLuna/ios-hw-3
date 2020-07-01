import UIKit
import SDWebImage
import RealmSwift

class FriendsListViewController: UITableViewController {
    
    @IBOutlet var tableFriendsView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var users = [UserRealm]()
    var userId: Int = 601976
    private var sectionTitles = [String]()
//    private var token: NotificationToken?
    var photos = [PhotoRealm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableFriendsView.dataSource = self
        searchBar.delegate = self
        RealmHelper.instance.cleanRealm()
        requestData()
        requestPhotosForTest()
//        tableView.tableFooterView = UIView()
    }
    
    private func requestData() {
        Requests.instance.getMyFriends { result in
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print(error)
            }
        }
        self.tableView.reloadData()
    }
    
    private func requestPhotosForTest() {
        Requests.instance.getAllPhotosByOwnerId(ownerId: userId) { result in
            switch result {
            case .success(let photos):
                self.photos = photos
            case .failure(let error):
                print(error)
            }
        }
         DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
       cell.myFriendAvatar.sd_setImage(with: URL(string: users[indexPath.row].avatar), placeholderImage: UIImage(named: "Portrait_Placeholder.png"))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getFriendPhotos" {
            guard let target = segue.destination as? FriendsPhotoCollectionViewController,
                let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            target.currentUserId = users[selectedIndexPath.row].id
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

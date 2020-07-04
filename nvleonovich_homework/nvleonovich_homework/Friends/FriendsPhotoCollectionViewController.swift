import UIKit
import SDWebImage


class FriendsPhotoCollectionViewController: UICollectionViewController {
    
    var currentUserId: Int = 0
    let animation = Animations()
    var photos = [PhotoRealm]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        requestPhotosForTest()
        print("\(currentUserId) и \(photos)")
    }
    
    private func requestPhotosForTest() {
        Requests.instance.getAllPhotosByOwnerId(ownerId: currentUserId) { [weak self] result in
            switch result {
            case .success(let photos):
            self?.photos = photos
            case .failure(let error):
                print(error)
            }
            self?.collectionView.reloadData()
        }
    }
        
        // MARK: UICollectionViewDataSource
        
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
        
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! FriendsPhotoCollectionViewCell
        cell.likesCount.text = "\(photos[indexPath.row].likesCount)"
        cell.heartButton.isSelected = photos[indexPath.row].isLikedByMe
        cell.friendsPhoto.sd_setImage(with: URL(string: photos[indexPath.row].url), placeholderImage: UIImage(named: "placeholder-1-300x200.png"))
        cell.likesCount.textColor = cell.heartButton.isSelected ? #colorLiteral(red: 0.8094672561, green: 0, blue: 0.2113229036, alpha: 1)  : #colorLiteral(red: 0, green: 0.4539153576, blue: 1, alpha: 1)
        
        //замыкание для тапа на ячейку
        cell.heartButtoonTap = { [weak self] in
            let row = indexPath.row
            self!.photos[row].isLikedByMe = !self!.photos[row].isLikedByMe
            if self!.photos[row].isLikedByMe {
                self!.photos[row].likesCount += 1
            } else {
                self!.photos[row].likesCount -= 1
            }
            self!.collectionView.reloadItems(at: [indexPath])
            self!.animation.increaseElementOnTap(cell.heartButton)
        }
        return cell
    }
    
    @IBAction func openPhotoinGallery(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openFullSizePhoto"
        {
            let target = segue.destination as! SwipePhotoController
            target.currentUserId = currentUserId
            let index = collectionView.indexPathsForSelectedItems!.first!
            let photoIndex = index.item
            target.photoIndex = photoIndex
            target.photos = photos
        }
    }
    
}

extension FriendsPhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let cellWidth = (view.bounds.width - 15) / 2

            return CGSize(width: cellWidth, height: cellWidth)
        }
}

//
//  FriendPhotoCollectionController.swift
//  nvleonovich_homework
//
//  Created by nvleonovich on 30.03.2020.
//  Copyright © 2020 nvleonovich. All rights reserved.
//

import UIKit
import SDWebImage


class FriendsPhotoCollectionViewController: UICollectionViewController {
    
    var currentUserId: Int = 0
    let animation = Animations()
    var photos = [PhotoRealm]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        RealmHelper.instance.cleanRealm()
        requestData()
//        PhotosLoader().getAllPhotosByOwnerId(ownerId: currentUserId) { [weak self] photos in
//            self?.photos = photos
//             DispatchQueue.main.async {
//             self?.collectionView.reloadData()
//            }
//        }
        print("\(currentUserId) и \(photos)")
    }
    
    private func requestData() {
        Requests.instance.getAllPhotosByOwnerId(ownerId: currentUserId) { result in
            switch result {
            case .success(let photos):
                self.photos = photos
            case .failure(let error):
                print(error)
            }
        }
         DispatchQueue.main.async {
            self.collectionView.reloadData()
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
//        cell.likesCount.text = "\(photos[indexPath.row].likes.likesCount)"
//        cell.heartButton.isSelected = photos[indexPath.row].likes.isLikedByMe
//        cell.friendsPhoto.sd_setImage(with: URL(string: photos[indexPath.row].sizes[0].url), placeholderImage: UIImage(named: "placeholder-1-300x200.png"))
        cell.likesCount.textColor = cell.heartButton.isSelected ? #colorLiteral(red: 0.8094672561, green: 0, blue: 0.2113229036, alpha: 1)  : #colorLiteral(red: 0, green: 0.4539153576, blue: 1, alpha: 1)
        
        //замыкание для тапа на ячейку
//        cell.heartButtoonTap = { [weak self] in
//            let row = indexPath.row
//            self!.photos[row].likes.isLikedByMe = !self!.photos[row].likes.isLikedByMe
//            if self!.photos[row].likes.isLikedByMe {
//                self!.photos[row].likes.likesCount += 1
//            } else {
//                self!.photos[row].likes.likesCount -= 1
//            }
//            self!.collectionView.reloadItems(at: [indexPath])
//            self!.animation.increaseElementOnTap(cell.heartButton)
//        }
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
            
//            let cellWidth = 150
            let cellWidth = view.bounds.height / 10
            
            return CGSize(width: cellWidth, height: cellWidth)
        }
}

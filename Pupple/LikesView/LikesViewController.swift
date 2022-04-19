//
//  LikesViewController.swift
//  Pupple
//
//  Created by Mandy Yu on 4/19/22.
//

import UIKit
import Parse
import Alamofire

class LikesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

//    @IBOutlet weak var likedByCollectionView: UICollectionView!
//    @IBOutlet weak var likesCollectionView: UICollectionView!
    
    
    var likedBy = [PFObject]()
    var likes = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        likedByCollectionView.dataSource = self
//        likedByCollectionView.delegate = self
//
//        likesCollectionView.dataSource = self
//        likesCollectionView.delegate = self
//
//        PFUser.logInWithUsername(inBackground: "mandee", password: "123") {
//                  (user: PFUser?, error: Error?) -> Void in
//                    if error != nil {
//                        print(error)
//                    }
//        }
//        let user = PFUser.current()!
//
//        print(likedBy)
//        print(likes)
        
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.likedByCollectionView {
//            return likedBy.count
//        }
//        return likes.count
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCollectionViewCell", for: indexPath) as! LikeCollectionViewCell
        
//        var like = PFObject()
//
//        if collectionView == self.likedByCollectionView {
//            like = likedBy[indexPath.item]
//        } else {
//            like = likes[indexPath.item]
//        }
//
//
//        let query = PFQuery(className: "Dog")
//        query.getObjectInBackground(withId: like.objectId!) { dog, error in
//            if dog != nil {
//                let imageFile = dog!["dog_photo"] as! PFFileObject
//                let urlString = imageFile.url!
//                let url = URL(string: urlString)!
//
//                cell.dogImageView.af.setImage(withURL: url)
//                cell.dogNameLabel.text = dog!["name"] as? String
//                cell.dogBreedLabel.text = dog!["breed"] as? String
//
//                let owner = dog!["ownerid"] as! PFUser
//    //                print(owner)
//                let ownerquery = PFUser.query()
//                ownerquery?.getObjectInBackground(withId: owner.objectId!, block: { dogowner, error in
//                    if dogowner != nil {
//                        let ownerimg = dogowner!["user_photo"] as! PFFileObject
//                        let ownerurl = URL(string: ownerimg.url!)!
//                        cell.ownerImageView.af.setImage(withURL: ownerurl)
//                    }
//                })
//
//            } else {
//                print(error?.localizedDescription)
//            }
//        }
        return cell
    }
    

}

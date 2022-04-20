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

    @IBOutlet weak var likedByCollectionView: UICollectionView!
    @IBOutlet weak var likesCollectionView: UICollectionView!
    
    var likedBy = [PFObject?]()
    var likes = [PFObject?]()


    override func viewDidLoad() {
        super.viewDidLoad()
        likedByCollectionView.dataSource = self
        likedByCollectionView.delegate = self

        likesCollectionView.dataSource = self
        likesCollectionView.delegate = self

//        PFUser.logInWithUsername(inBackground: "mandee", password: "123") {
//                  (user: PFUser?, error: Error?) -> Void in
//                    if error != nil {
//                        print(error)
//                    }
//        }
        let user = PFUser.current()!

        let query = PFQuery(className: "Dog")
        query.whereKey("ownerid", equalTo: user)
        query.getFirstObjectInBackground { (dog: PFObject?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let dog = dog {
                // The find succeeded.
//                print("WHO LET THE DOGS OUT:", dog["likedBy"] as? [PFObject])
                self.likedBy = (dog["likedBy"] as? [PFObject]) ?? []
                self.likes = user["likes"] as? [PFObject] ?? []
//                self.user = user
//                self.dog = dog
                
                self.likedByCollectionView.reloadData()
                self.likesCollectionView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("LIKEDBY",likedBy)
        print("LIKES", likes)

        if collectionView == self.likedByCollectionView {
            return likedBy.count
        }
        return likes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCollectionViewCell", for: indexPath) as! LikeCollectionViewCell
        

        if collectionView == self.likedByCollectionView {
            let like = likedBy[indexPath.item]!
//            print("LIKE:", like)
            let query = PFUser.query()
            query?.getObjectInBackground(withId: like.objectId!, block: { user, error in
                let url = URL(string: (user!["user_photo"] as! PFFileObject).url!)!
                cell.ownerImageView.af.setImage(withURL: url)
                
                let dogquery = PFQuery(className: "Dog")
                dogquery.whereKey("ownerid", equalTo: user!)
                dogquery.getFirstObjectInBackground { (dog: PFObject?, error: Error?) in
                    if let error = error {
                        // Log details of the failure
                        print(error.localizedDescription)
                    } else if let dog = dog {
                        let dogurl = URL(string: (dog["dog_photo"] as! PFFileObject).url!)!
                        cell.dogImageView.af.setImage(withURL: dogurl)
                        cell.dogNameLabel.text = dog["name"] as? String
                        cell.dogBreedLabel.text = dog["breed"] as? String
                    }
                }
            })
            
        } else {
            let like = likes[indexPath.item]!
            let query = PFQuery(className: "Dog")
            query.getObjectInBackground(withId: like.objectId!) { dog, error in
                if dog != nil {
                    let imageFile = dog!["dog_photo"] as! PFFileObject
                    let urlString = imageFile.url!
                    let url = URL(string: urlString)!

                    cell.dogImageView.af.setImage(withURL: url)
                    cell.dogNameLabel.text = dog!["name"] as? String
                    cell.dogBreedLabel.text = dog!["breed"] as? String

                    let owner = dog!["ownerid"] as! PFUser
                    let ownerquery = PFUser.query()
                    ownerquery?.getObjectInBackground(withId: owner.objectId!, block: { dogowner, error in
                        if dogowner != nil {
                            let ownerimg = dogowner!["user_photo"] as! PFFileObject
                            let ownerurl = URL(string: ownerimg.url!)!
                            cell.ownerImageView.af.setImage(withURL: ownerurl)
                        }
                    })

                } else {
                    print(error?.localizedDescription)
                }
            }
        }

        
        return cell
    }
    

}

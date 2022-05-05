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
    @IBOutlet weak var profileBarButtonItem: UIBarButtonItem!
    
    var likedBy = [PFObject?]()
    var likes = [PFObject?]()

    var dogName: String?
    var ownerLocation: String?
    var dogBreed: String?
    var genderImageView: UIImageView?
    var dogImageView: UIImageView?
    var ownerImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfile()
        navBarUI()
        likedByCollectionView.dataSource = self
        likedByCollectionView.delegate = self

        likesCollectionView.dataSource = self
        likesCollectionView.delegate = self

        // unnecessary because viewdidappear gets called anyway
//        let user = PFUser.current()!
//
//        let query = PFQuery(className: "Dog")
//        query.whereKey("ownerid", equalTo: user)
//        query.getFirstObjectInBackground { (dog: PFObject?, error: Error?) in
//            if let error = error {
//                // Log details of the failure
//                print(error.localizedDescription)
//            } else if let dog = dog {
//                let matches = dog["matches"] as? [PFObject]
//                print("MATCHES:", matches)
//                self.likedBy = (dog["likedBy"] as? [PFObject])?.reversed() ?? []
//                self.likes = (dog["likes"] as? [PFObject])?.reversed() ?? []
//
//                self.likedByCollectionView.reloadData()
//                self.likesCollectionView.reloadData()
//            }
//        }
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("LIKEDBY",likedBy)
//        print("LIKES", likes)

        if collectionView == self.likedByCollectionView {
            return likedBy.count
        }
        return likes.count
    }
    
    static func exists(arr: [PFObject?], target: PFObject) -> Bool {
        for obj in arr {
            if obj?.objectId == target.objectId {
                return true
            }
        }
        return false
    }
    
    static func matches(lhs: [PFObject?], rhs: [PFObject?]) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        
        for (idx, obj) in lhs.enumerated() {
            if obj?.objectId != rhs[idx]?.objectId {
                return false
            }
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = PFUser.current() else {return}

        let query = PFQuery(className: "Dog")
        query.whereKey("ownerid", equalTo: user)
        query.getFirstObjectInBackground { (dog: PFObject?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let dog = dog {
                self.likesCollectionView.contentOffset.x = 0
                self.likedByCollectionView.contentOffset.x = 0
                
                let o_likes = self.likes
                let o_likedBy = self.likedBy
                
                let matches = dog["matches"] as? [PFObject] ?? []
                let likedBy = (dog["likedBy"] as? [PFObject]) ?? []
            
                for like in likedBy {
                    if !LikesViewController.exists(arr: matches, target: like) && !LikesViewController.exists(arr: self.likedBy, target: like) {
                        self.likedBy.insert(like, at: 0)
                    }
                }
                
                let likes = (dog["likes"] as? [PFObject]) ?? []
    
                for like in likes {
                    if !LikesViewController.exists(arr: matches, target: like) && !LikesViewController.exists(arr: self.likes, target: like) {
                        self.likes.insert(like, at: 0)
                    }
                }
                
                if !LikesViewController.matches(lhs: o_likes, rhs: self.likes) {
                    self.likesCollectionView.reloadData()
                }
                
                if !LikesViewController.matches(lhs: o_likedBy, rhs: self.likedBy) {
                    self.likedByCollectionView.reloadData()
                }
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCollectionViewCell", for: indexPath) as! LikeCollectionViewCell
        
//        var like: PFObject
        var like = PFObject(className: "Dog")
        if collectionView == self.likesCollectionView {
            like = likes[indexPath.item]!
        } else if collectionView == self.likedByCollectionView {
            like = likedBy[indexPath.item]!
        }
        let query = PFQuery(className: "Dog")
        query.getObjectInBackground(withId: like.objectId!) { dog, error in
            if let error = error {
                print(error)
            }
            else if let dog = dog {
                let imageFile = dog["dog_photo"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!

                cell.dogImageView.af.setImage(withURL: url)
                cell.dogNameLabel.text = dog["name"] as? String
                cell.dogBreedLabel.text = dog["breed"] as? String

                let owner = dog["ownerid"] as! PFUser
                let ownerquery = PFUser.query()
                ownerquery?.getObjectInBackground(withId: owner.objectId!, block: { dogowner, error in
                    if let error = error {
                        print(error)
                    }
                    else if let dogowner = dogowner {
                        let ownerimg = dogowner["user_photo"] as! PFFileObject
                        let ownerurl = URL(string: ownerimg.url!)!
                        cell.ownerImageView.af.setImage(withURL: ownerurl)
                    }
                })

            }
        }

        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ((segue.identifier?.contains("dogProfileSegue")) == true) {
            
            let cell = sender as! LikeCollectionViewCell
            let dogProfileViewController: DogProfileFeedViewController = segue.destination as! DogProfileFeedViewController
            
            var collectionView: UICollectionView?
            var like: PFObject!
            if segue.identifier == "dogProfileSegueLikedBy" {
                collectionView = likedByCollectionView
                like = likedBy[collectionView!.indexPath(for:cell)!.item]
            } else if segue.identifier == "dogProfileSegueLikes" {
                collectionView = likesCollectionView
                like = likes[collectionView!.indexPath(for:cell)!.item]
            }
            
            let query = PFQuery(className: "Dog")
            query.getObjectInBackground(withId: like.objectId!) { dog, error in
                if let error = error {
                    print(error)
                }
                else if let dog = dog {
                    let imageFile = dog["dog_photo"] as! PFFileObject
                    let urlString = imageFile.url!
                    let url = URL(string: urlString)!
                    dogProfileViewController.dogImageView.af.setImage(withURL: url)

                    dogProfileViewController.dogNameLabel.text = dog["name"] as? String

                    dogProfileViewController.breedLabel.text = dog["breed"] as? String
                    
                    dogProfileViewController.dogSizeLabel.text = dog["size"] as? String

                    let vaccinated = dog["vaccinated"] as! Bool
                    let fixed = dog["fixed"] as! Bool
                    let dogAgeNum = dog["age"] as? Int
                    var dogAge: String = "N/A"
                    if(dogAgeNum != nil) {dogAge = String(dogAgeNum!) + " years old"}
                    var dogAbout = dog["about"] as? String
                    
                    if (vaccinated){ dogProfileViewController.vaccinatedLabel.text = "Yes"}
                    else { dogProfileViewController.vaccinatedLabel.text = "No"}
                    
                    if (fixed){ dogProfileViewController.fixedLabel.text = "Yes"}
                    else { dogProfileViewController.fixedLabel.text = "No"}
                    
                    dogProfileViewController.dogAgeLabel.text = dogAge
                    
                    if(dogAbout == nil) { dogAbout = ""}
                    dogProfileViewController.dogAboutLabel.text = dogAbout
                    
                    let dogGender = dog["gender"] as! String
                    if(dogGender == "Male") {dogProfileViewController.genderImageView.image = UIImage(named: "male_gender")}
                    else if (dogGender == "Female") {dogProfileViewController.genderImageView.image = UIImage(named: "female_gender")}
                    
                    let owner = dog["ownerid"] as! PFUser
                    let ownerquery = PFUser.query()
                    ownerquery?.getObjectInBackground(withId: owner.objectId!, block: { dogowner, error in
                        if let error = error {
                            print(error)
                        }
                        else if let dogowner = dogowner{
                            let ownerimg = dogowner["user_photo"] as! PFFileObject
                            let ownerurl = URL(string: ownerimg.url!)!
                            dogProfileViewController.ownerImageView.af.setImage(withURL: ownerurl)
                            dogProfileViewController.locationLabel.text = dogowner["location"] as? String
                            let ownerFirstName = dogowner["firstname"] as! String
                            let ownerLastName = dogowner["lastname"] as! String
                            dogProfileViewController.ownerNameLabel.text = ownerFirstName + " " + ownerLastName
                            
                            // Calculate age
                            let birthday = dogowner["birthday"] as! String
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM/dd/yy"
                            dateFormatter.date(from: birthday)
                            let calendar = Calendar.current
                            let now = Date()
                            let ageComponents = calendar.dateComponents([.year], from: dateFormatter.date(from: birthday)!, to: now)
                            let age = ageComponents.year!
                            let ageString = String(age)
                            
                            dogProfileViewController.ownerAgeLabel.text = ageString + " years old"
                            
                            let ownerAbout = dogowner["about"] as? String
                            dogProfileViewController.ownerAboutLabel.text = ownerAbout
                            
                            var ownerEducation = dogowner["education"] as? String
                            if(ownerEducation == nil) { ownerEducation = "N/A"}
                            dogProfileViewController.educationLabel.text = ownerEducation
                            
                            var ownerGender = dogowner["gender"] as? String
                            if(ownerGender == nil) { ownerGender = "N/A"}
                            dogProfileViewController.ownerGenderLabel.text = ownerGender
                            
                            var ownerSnapchat = dogowner["snapchat"] as? String
                            if(ownerSnapchat == nil) { ownerSnapchat = "N/A"}
                            dogProfileViewController.ownerSnapchatButton.setTitle(ownerSnapchat, for: .normal)
                            
                            var ownerInstagram = dogowner["instagram"] as? String
                            if(ownerInstagram == nil) { ownerInstagram = "N/A"}
                            dogProfileViewController.ownerInstagramButton.setTitle(ownerInstagram, for: .normal)
                            
                            var ownerOccupation = dogowner["occupation"] as? String
                            if(ownerOccupation == nil) { ownerOccupation = "N/A" }
                            dogProfileViewController.occupationLabel.text = ownerOccupation
                        } //end of dogowner
                    }) //end of dogowner query

                } // end of dog

            } //end of dog query
        } // end of dog prof segue
        else if (segue.identifier == "profileDetailsLikes") {
            // will perform segue to owner profile on press
            
            let destinationVC: UserProfileViewController = segue.destination as! UserProfileViewController
            destinationVC.segueName = segue.identifier
            
        } // end of profile details
    } // end of function
    
    
    @IBAction func goToProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "profileDetailsLikes", sender: self)
    }
    
} // end of LikesViewController

extension LikesViewController : UIBarPositioningDelegate, UINavigationBarDelegate {
    
    func userProfile()
    {
        let user = PFUser.current()!
        let userImageFile = user["user_photo"] as! PFFileObject
        userImageFile.getDataInBackground { imageData, error in
            if imageData != nil
            {
                let image = UIImage(data: imageData!)
                let size = CGSize(width: 50, height: 50)
                let scaledImage = image!.af.imageAspectScaled(toFill: size)
                let roundedImage = scaledImage.af.imageRounded(withCornerRadius: 20)
                self.navigationItem.leftBarButtonItem?.setBackgroundImage(roundedImage, for: .normal, barMetrics: .default)
            }
        }
        navigationItem.leftBarButtonItem?.title = ""
    }
    
    func navBarUI()
    {
        let app_color = UIColor(red: 196/255, green: 164/255, blue: 132/255, alpha: 1)
        navigationController?.navigationBar.delegate = self
        navigationController?.navigationBar.barTintColor = app_color
        profileBarButtonItem.setBackButtonBackgroundVerticalPositionAdjustment(CGFloat(-8), for: UIBarMetrics.default)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

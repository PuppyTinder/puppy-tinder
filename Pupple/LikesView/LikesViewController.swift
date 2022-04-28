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
    override func viewDidAppear(_ animated: Bool) {
        likesCollectionView.reloadData()
        likedByCollectionView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! LikeCollectionViewCell
        let dogProfileViewController: DogProfileFeedViewController = segue.destination as! DogProfileFeedViewController
        
        if (segue.identifier == "dogProfileSegueLikes")
        {
            
            let indexPath = likesCollectionView.indexPath(for: cell)!
            
            let like = likes[indexPath.item]!
            print(like)
            let query = PFQuery(className: "Dog")
            query.getObjectInBackground(withId: like.objectId!) { dog, error in
                if dog != nil {
//                    let imageFile = dog!["dog_photo"] as! PFFileObject
//                    let urlString = imageFile.url!
//                    let url = URL(string: urlString)!

                    dogProfileViewController.dogName = dog!["name"] as? String
//                    dogProfileViewController.dogImage = UIImage(cgImage: CGImag)
                    dogProfileViewController.breed = dog!["breed"] as? String
                    
                    dogProfileViewController.size = dog!["size"] as? String

                    let vaccinated = dog!["vaccinated"] as! Bool
                    let fixed = dog!["fixed"] as! Bool
                    var dogAge = dog!["age"] as? String
                    var dogAbout = dog!["about"] as? String
                    
                    if (vaccinated){ dogProfileViewController.vaccinatedLabel.text = "Yes"}
                    else { dogProfileViewController.vaccinatedLabel.text = "No"}
                    
                    if (fixed){ dogProfileViewController.fixedLabel.text = "Yes"}
                    else { dogProfileViewController.fixedLabel.text = "No"}
                    
                    if(dogAge == nil) { dogAge = "N/A"}
                    else { dogAge = dogAge! + " years old"}
                    dogProfileViewController.dogAgeLabel.text = dogAge
                    
                    if(dogAbout == nil) { dogAbout = ""}
                    dogProfileViewController.dogAboutLabel.text = dogAbout
                    
                    
                    let owner = dog!["ownerid"] as! PFUser
                    let ownerquery = PFUser.query()
                    ownerquery?.getObjectInBackground(withId: owner.objectId!, block: { dogowner, error in
                        if dogowner != nil {
//                            let ownerimg = dogowner!["user_photo"] as! PFFileObject
//                            let ownerurl = URL(string: ownerimg.url!)!
//                            cell.ownerImageView.af.setImage(withURL: ownerurl)
                            dogProfileViewController.location = dogowner!["location"] as? String
                            let ownerFirstName = dogowner!["firstname"] as! String
                            let ownerLastName = dogowner!["lastname"] as! String
                            dogProfileViewController.ownerName = ownerFirstName + " " + ownerLastName
                            
                            // Calculate age
                            let birthday = dogowner!["birthday"] as! String
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM/dd/yy"
                            dateFormatter.date(from: birthday)
                            let calendar = Calendar.current
                            let now = Date()
                            let ageComponents = calendar.dateComponents([.year], from: dateFormatter.date(from: birthday)!, to: now)
                            let age = ageComponents.year!
                            let ageString = String(age)
                            
                            dogProfileViewController.ownerAgeLabel.text = ageString + " years old"
                            
                            let ownerAbout = dogowner!["about"] as? String
                            dogProfileViewController.ownerAboutLabel.text = ownerAbout
                            
                            var ownerEducation = dogowner!["education"] as? String
                            if(ownerEducation == nil) { ownerEducation = "N/A"}
                            dogProfileViewController.educationLabel.text = ownerEducation
                            
                            var ownerGender = dogowner!["gender"] as? String
                            if(ownerGender == nil) { ownerGender = "N/A"}
                            dogProfileViewController.ownerGenderLabel.text = ownerGender
                            
                            var ownerSnapchat = dogowner!["snapchat"] as? String
                            if(ownerSnapchat == nil) { ownerSnapchat = "N/A"}
                            dogProfileViewController.ownerSnapchatButton.setTitle(ownerSnapchat, for: .normal)
                            
                            var ownerInstagram = dogowner!["instagram"] as? String
                            if(ownerInstagram == nil) { ownerInstagram = "N/A"}
                            dogProfileViewController.ownerInstagramButton.setTitle(ownerInstagram, for: .normal)
                            
                            var ownerOccupation = dogowner!["occupation"] as? String
                            if(ownerOccupation == nil) { ownerOccupation = "N/A" }
                            dogProfileViewController.occupationLabel.text = ownerOccupation
                        }
                    })

                } else {
                    print(error?.localizedDescription)
                }

            
//            dogProfileViewController.dogName = dogName
//            dogProfileViewController.dogImage = dogImageView?.image
//            dogProfileViewController.ownerImage = ownerImageView?.image
//            dogProfileViewController.gender = genderImageView?.image
//            dogProfileViewController.location = ownerLocation
//            dogProfileViewController.breed = dogBreed
            
           
        
}}}
}

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

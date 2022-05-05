//
//  RecentMatchViewController.swift
//  Pupple
//
//  Created by Yoomin Song on 4/30/22.
//

import UIKit
import Parse
import AlamofireImage

class RecentMatchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {

    //MARK: - IBOutlet
  
    @IBOutlet weak var matchCollectionView: UICollectionView!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var profileBarButton: UIBarButtonItem!
    //MARK: - Vars
    var matches = [PFObject]() // creates an empty array of matches
    let app_color = UIColor(red: 196/255, green: 164/255, blue: 132/255, alpha: 1)
    var selected_row: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfile()
        navBarUI()
        matchCollectionView.dataSource = self
        matchCollectionView.delegate = self
        
        messageTableView.dataSource = self
        messageTableView.delegate = self
    }
    
    // reload a page each time new match occurs
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        matchQuery()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return matches.count
    }
    
    //MARK: - match Query
    // i) get the user's dog that has an array of matches containing the matched dogs
    // ii) save the array of matched dogs
    
    func matchQuery() {
        
        guard let user = PFUser.current() else { return }
        
        let userDogquery = PFQuery(className: "Dog")
        userDogquery.includeKeys(["name", "matches", "dog_photo", "ownerid"])
        userDogquery.whereKey("ownerid", equalTo: user) // constraint to get the current user's dog
        
        var dogArray = [PFObject]()
        userDogquery.findObjectsInBackground { userDog, error in
            if userDog != nil {
                dogArray = userDog!
                
                for currentUserDog in dogArray {
                    let dogMatches = currentUserDog["matches"] as! [PFObject]
                    self.matches = dogMatches
                    self.matchCollectionView.reloadData() //reload the collection view data
                    self.messageTableView.reloadData() //reload the table view data
                }
            }
        }// end of query
     
        
    }
    
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentMatchCollectionViewCell", for: indexPath) as! RecentMatchCollectionViewCell // grab the cell
        let match = matches[indexPath.item] as! PFObject// grab a particular match
        cell.puppyNameLabel.text = match["name"] as? String
        
        let imageFile = match["dog_photo"] as! PFFileObject
        let imageUrl = imageFile.url!
        let url = URL(string: imageUrl)
        
        cell.avatarImageView.af.setImage(withURL: url!)

        return cell
      }
    
    //MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MatchandMessageTableViewCell // grab the cell
        
        let match = matches[indexPath.row]
        
        cell.userNameLabel.text = match["name"] as! String
        cell.lastMessageLabel.text = ""
        
        let imageFile = match["dog_photo"] as! PFFileObject
        let imageUrl = imageFile.url!
        let url = URL(string: imageUrl)
        
        cell.dogImageView.af.setImage(withURL: url!)
        
        let matchOwner = match["ownerid"] as! PFUser
        let userDogOwnerquery = PFQuery(className: "_User")
        userDogOwnerquery.includeKeys(["user_photo","firstname"])
        
        userDogOwnerquery.getObjectInBackground(withId: matchOwner.objectId!) { owner, error in
            if owner != nil
            {
                let userImageFile = owner!["user_photo"] as! PFFileObject
                let userImageUrl = userImageFile.url!
                let userUrl = URL(string: userImageUrl)
                
                cell.userImageView.af.setImage(withURL: userUrl!)
            }
            else
            {
                print("Owner not found.")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_row = indexPath.row
        self.performSegue(withIdentifier: "conversationSegue", sender: indexPath.row)
    }

    @IBAction func goToProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "profileDetailsMatches", sender: self)
    }
}

extension RecentMatchViewController {
    
    
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
                self.profileBarButton.setBackgroundImage(roundedImage, for: .normal, barMetrics: .default)
            }
        }
        navigationItem.leftBarButtonItem?.title = ""
    }
    
    func navBarUI()
    {
        navigationController?.navigationBar.delegate = self
        navigationController?.navigationBar.barTintColor = app_color
        navigationController?.tabBarItem.selectedImage = navigationController?.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        profileBarButton.setBackButtonBackgroundVerticalPositionAdjustment(CGFloat(-8), for: UIBarMetrics.default)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "matchesProfileSegue") {
            
            let cell = sender as! RecentMatchCollectionViewCell
            let dogProfileViewController: DogProfileFeedViewController = segue.destination as! DogProfileFeedViewController
            
            var collectionView: UICollectionView?
 
            collectionView = matchCollectionView
            let match = matches[collectionView!.indexPath(for:cell)!.item]
            
            let query = PFQuery(className: "Dog")
            query.getObjectInBackground(withId: match.objectId!) { dog, error in
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
        else if (segue.identifier == "conversationSegue") {
            let chatViewController = segue.destination as! ChatViewController
            let match = matches[selected_row!]
            chatViewController.matchdog = match
            chatViewController.title = match["name"] as! String
        } // end of convo segue
        else if (segue.identifier == "profileDetailsMatches")
        {
            let userProfileViewController = segue.destination as! UserProfileViewController
            userProfileViewController.segueName = segue.identifier
        }
    } // end of function

}



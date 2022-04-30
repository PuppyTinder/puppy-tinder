//
//  FeedViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/6/22.
//

import UIKit
import Foundation
import Parse
import AlamofireImage
import Koloda

class FeedViewController: UIViewController, UIBarPositioningDelegate, UINavigationBarDelegate{
    
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resetLabel: UILabel!
    @IBOutlet weak var profileBarButton: UIBarButtonItem!
    
    let app_color = UIColor(red: 196/255, green: 164/255, blue: 132/255, alpha: 1)
    
    var dogArray = [PFObject]() // Array of dogs to like
    var viewModels = [KolodaCardView]() // Array containing the UIView of swipeable cards
    
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
        resetButton.isHidden = true
        resetLabel.isHidden = true
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        parse { data in
            self.viewModels = data!
            self.viewModels.shuffle() // Randomize the order of cards
            self.kolodaView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dogProfileSegue")
        {
            let dogProfileViewController: DogProfileFeedViewController = segue.destination as! DogProfileFeedViewController
            dogProfileViewController.dogName = dogName
            dogProfileViewController.dogImage = dogImageView?.image
            dogProfileViewController.ownerImage = ownerImageView?.image
            dogProfileViewController.gender = genderImageView?.image
            dogProfileViewController.location = ownerLocation
            dogProfileViewController.breed = dogBreed
            
            var queryArray = [PFObject]()
            let query = PFQuery(className: "Dog")
            query.whereKey("name", equalTo: dogName!)
            query.whereKey("breed", equalTo: dogBreed!)
            query.findObjectsInBackground { dogs, error in
                queryArray = dogs!
                
                for dog in queryArray
                {
                    // Parse dog information
                    let size = dog["size"] as! String
                    let vaccinated = dog["vaccinated"] as! Bool
                    let fixed = dog["fixed"] as! Bool
                    let dogAgeNum = dog["age"] as? Int
                    var dogAge: String = "N/A"
                    if(dogAgeNum != nil) {dogAge = String(dogAgeNum!) + " years old"}
                    var dogAbout = dog["about"] as? String
                    
                    dogProfileViewController.dogSizeLabel.text = size
                    
                    if (vaccinated){ dogProfileViewController.vaccinatedLabel.text = "Yes"}
                    else { dogProfileViewController.vaccinatedLabel.text = "No"}
                    
                    if (fixed){ dogProfileViewController.fixedLabel.text = "Yes"}
                    else { dogProfileViewController.fixedLabel.text = "No"}
                    
                    dogProfileViewController.dogAgeLabel.text = dogAge
                    
                    if(dogAbout == nil) { dogAbout = ""}
                    dogProfileViewController.dogAboutLabel.text = dogAbout
                    
                    // Parse owner information
                    let dogOwner = dog["ownerid"] as! PFObject
                    dogOwner.fetchIfNeededInBackground { owner, error in
                        if(owner != nil)
                        {
                            let ownerFirstName = dogOwner["firstname"] as! String
                            let ownerLastName = dogOwner["lastname"] as! String
                            dogProfileViewController.ownerNameLabel.text = ownerFirstName + " " + ownerLastName
                            
                            // Calculate age
                            let birthday = dogOwner["birthday"] as! String
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM/dd/yy"
                            dateFormatter.date(from: birthday)
                            let calendar = Calendar.current
                            let now = Date()
                            let ageComponents = calendar.dateComponents([.year], from: dateFormatter.date(from: birthday)!, to: now)
                            let age = ageComponents.year!
                            let ageString = String(age)
                            
                            dogProfileViewController.ownerAgeLabel.text = ageString + " years old"
                            
                            let ownerAbout = dogOwner["about"] as? String
                            dogProfileViewController.ownerAboutLabel.text = ownerAbout
                            
                            var ownerEducation = dogOwner["education"] as? String
                            if(ownerEducation == nil) { ownerEducation = "N/A"}
                            dogProfileViewController.educationLabel.text = ownerEducation
                            
                            var ownerGender = dogOwner["gender"] as? String
                            if(ownerGender == nil) { ownerGender = "N/A"}
                            dogProfileViewController.ownerGenderLabel.text = ownerGender
                            
                            var ownerSnapchat = dogOwner["snapchat"] as? String
                            if(ownerSnapchat == nil) { ownerSnapchat = "N/A"}
                            dogProfileViewController.ownerSnapchatButton.setTitle(ownerSnapchat, for: .normal)
                            
                            var ownerInstagram = dogOwner["instagram"] as? String
                            if(ownerInstagram == nil) { ownerInstagram = "N/A"}
                            dogProfileViewController.ownerInstagramButton.setTitle(ownerInstagram, for: .normal)
                            
                            var ownerOccupation = dogOwner["occupation"] as? String
                            if(ownerOccupation == nil) { ownerOccupation = "N/A" }
                            dogProfileViewController.occupationLabel.text = ownerOccupation
                        }
                    }
                    
                }
            }
        }     else if (segue.identifier == "ProfileDetails"){
                // will perform segue to owner profile on press
            }
    }
    
    
    
    func parse(completion :@escaping ( _ data : [KolodaCardView]?) -> ())
    {
        var cardArray = [KolodaCardView]()
        let query = PFQuery(className: "Dog")
        query.includeKeys(["name", "breed", "gender", "ownerid"])
        
        // Prevents the user from seeing their own dog in the feed
        let user = PFUser.current()!
        let user_id = user.objectId!
        let query_constraint = PFQuery(className: "Dog")
        query_constraint.includeKey("ownerid")
        query_constraint.whereKey("ownerid", contains: user_id) // current user's dog
        query.whereKey("ownerid", doesNotMatchKey: "ownerid", in: query_constraint)
        
        // Get our dog
        query_constraint.getFirstObjectInBackground { ownerDog, error in
            if(ownerDog != nil)
            {
                query.whereKey("likedBy", notEqualTo: ownerDog!) // prevents seeing dogs already liked
                query.findObjectsInBackground { dogs, error in
                    if dogs != nil
                    {
                        self.dogArray = dogs!
                        for dog in self.dogArray
                        
                        {
                            let dog_name = dog["name"] as! String
                            let breed = dog["breed"] as! String
                            let gender = dog["gender"] as! String
                            let dog_owner = dog["ownerid"] as! PFObject
                            let location = dog_owner["location"] as! String
                            let genderImage: UIImage!
                            
                            // Parse the image for the dog
                            let dogImageFile = dog["dog_photo"] as! PFFileObject
                            let urlString = dogImageFile.url!
                            let dog_image_url = URL(string: urlString)!
                            
                            // Condition to set either the male or female image
                            if gender == "Male"
                            {
                                genderImage = UIImage(named: "male_gender")
                            }
                            else
                            {
                                genderImage = UIImage(named: "female_gender")
                            }
                            
                            // Parse the image for the owner
                            let ownerImageFile = dog_owner["user_photo"] as! PFFileObject
                            let owner_url_string = ownerImageFile.url!
                            let owner_image_url = URL(string: owner_url_string)!
            
                            // Instantiate view for each card
                            let cardExampleView = KolodaCardView()
                            cardExampleView.dogNameLabel.text = dog_name
                            cardExampleView.breedLabel.text = breed
                            cardExampleView.locationLabel.text = location
                            cardExampleView.genderImageView.image = genderImage
                            cardExampleView.dogImageView.af.setImage(withURL: dog_image_url)
                            cardExampleView.ownerImageView.af.setImage(withURL: owner_image_url)
                            cardExampleView.dogObjectId = dog.objectId!
                         
                            // Apply view constraints to container & imageviews
                            cardExampleView.containerUIView.layer.borderWidth = 1
                            cardExampleView.containerUIView.layer.cornerRadius = 20
                            cardExampleView.containerUIView.layer.borderColor = CGColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 0.2)
                            cardExampleView.dogImageView.layer.cornerRadius = 20
                            cardExampleView.dogImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                            cardExampleView.ownerImageView.layer.cornerRadius = 30

                            cardArray.append(cardExampleView)
                        }
                        completion(cardArray)
                    }
                }
            }
        }
        
        
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func resetCards(_ sender: Any) {
        kolodaView.resetCurrentCardIndex()
        resetButton.isHidden = true
        resetLabel.isHidden = true
    }
    
}


extension FeedViewController : KolodaViewDelegate{
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        resetButton.isHidden = false
        resetLabel.isHidden = false
        //kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        dogName = viewModels[index].dogNameLabel.text!
        dogImageView = viewModels[index].dogImageView!
        ownerImageView = viewModels[index].ownerImageView!
        genderImageView = viewModels[index].genderImageView!
        ownerLocation = viewModels[index].locationLabel.text!
        dogBreed = viewModels[index].breedLabel.text!
        self.performSegue(withIdentifier: "dogProfileSegue", sender: self)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .right:
            let user = PFUser.current()!
            
            let userDogQuery = PFQuery(className: "Dog")
            userDogQuery.whereKey("ownerid", equalTo: user) // Constraint to get the current user's dog
            
            let query = PFQuery(className: "Dog") // Get the selected dog
            let selectedDogId = viewModels[index].dogObjectId!
           
            userDogQuery.getFirstObjectInBackground { ownerDog, error in
                if(ownerDog != nil)
                {
                    query.getObjectInBackground(withId: selectedDogId) { dog, error in
                        if(dog != nil)
                        {
                            ownerDog?.addUniqueObject(dog!, forKey: "likes")
                            dog?.addUniqueObject(ownerDog!, forKey: "likedBy")
                            
                            // Handle match logic
                            let current_likedBy = (ownerDog!["likedBy"] as? [PFObject]) ?? []
                            if current_likedBy.count != 0
                            {
                                for dog_likedBy in current_likedBy
                                {
                                    if(dog_likedBy.objectId! == selectedDogId)
                                    {
                                        ownerDog?.addUniqueObject(dog!, forKey: "matches")
                                        dog?.addUniqueObject(ownerDog!, forKey: "matches")
                                    }
                                }
                            }
                            
                            dog?.saveInBackground(block: { success, error in
                                if(success != nil)
                                {
                                    print("liked!")
                                }
                            })
                        }
                    }
                }
            }
            
        case .topRight:
            let user = PFUser.current()!
            
            let userDogQuery = PFQuery(className: "Dog")
            userDogQuery.whereKey("ownerid", equalTo: user) // Constraint to get the current user's dog
            
            let query = PFQuery(className: "Dog") // Get the selected dog
            let selectedDogId = viewModels[index].dogObjectId!
           
            userDogQuery.getFirstObjectInBackground { ownerDog, error in
                if(ownerDog != nil)
                {
                    query.getObjectInBackground(withId: selectedDogId) { dog, error in
                        if(dog != nil)
                        {
                            ownerDog?.addUniqueObject(dog!, forKey: "likes")
                            dog?.addUniqueObject(ownerDog!, forKey: "likedBy")
                            
                            // Handle match logic
                            let current_likedBy = (ownerDog!["likedBy"] as? [PFObject]) ?? []
                            if current_likedBy.count != 0
                            {
                                for dog_likedBy in current_likedBy
                                {
                                    if(dog_likedBy.objectId! == selectedDogId)
                                    {
                                        ownerDog?.addUniqueObject(dog!, forKey: "matches")
                                        dog?.addUniqueObject(ownerDog!, forKey: "matches")
                                    }
                                }
                            }
                            
                            dog?.saveInBackground(block: { success, error in
                                if(success != nil)
                                {
                                    print("liked!")
                                }
                            })
                        }
                    }
                }
            }
        case .bottomRight:
            let user = PFUser.current()!
            
            let userDogQuery = PFQuery(className: "Dog")
            userDogQuery.whereKey("ownerid", equalTo: user) // Constraint to get the current user's dog
            
            let query = PFQuery(className: "Dog") // Get the selected dog
            let selectedDogId = viewModels[index].dogObjectId!
           
            userDogQuery.getFirstObjectInBackground { ownerDog, error in
                if(ownerDog != nil)
                {
                    query.getObjectInBackground(withId: selectedDogId) { dog, error in
                        if(dog != nil)
                        {
                            ownerDog?.addUniqueObject(dog!, forKey: "likes")
                            dog?.addUniqueObject(ownerDog!, forKey: "likedBy")
                            
                            // Handle match logic
                            let current_likedBy = (ownerDog!["likedBy"] as? [PFObject]) ?? []
                            if current_likedBy.count != 0
                            {
                                for dog_likedBy in current_likedBy
                                {
                                    if(dog_likedBy.objectId! == selectedDogId)
                                    {
                                        ownerDog?.addUniqueObject(dog!, forKey: "matches")
                                        dog?.addUniqueObject(ownerDog!, forKey: "matches")
                                    }
                                }
                            }
                            
                            dog?.saveInBackground(block: { success, error in
                                if(success != nil)
                                {
                                    print("liked!")
                                }
                            })
                        }
                    }
                }
            }
        case .left:
            print("swiped left")
        case .up:
            print("swiped up")

        case .down:
            print("swiped down")

        case .topLeft:
            print("swiped left")

        case .bottomLeft:
            print("swiped left")

        }
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [SwipeResultDirection.left, SwipeResultDirection.topLeft, SwipeResultDirection.bottomLeft, SwipeResultDirection.topRight, SwipeResultDirection.bottomRight, SwipeResultDirection.right]
    }
}

extension FeedViewController : KolodaViewDataSource{
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        viewModels.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return viewModels[index]
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil
    }
}






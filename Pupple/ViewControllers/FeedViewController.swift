//
//  FeedViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/6/22.
//

import UIKit
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
                    
                    dogProfileViewController.size = size
                    
                    if (vaccinated){ dogProfileViewController.vaccinated = "Yes"}
                    else { dogProfileViewController.vaccinated = "No"}
                    
                    if (fixed){ dogProfileViewController.fixed = "Yes"}
                    else { dogProfileViewController.fixed = "No"}
                    
                    // Parse owner information
                    let dogOwner = dog["ownerid"] as! PFObject
                    dogOwner.fetchIfNeededInBackground { owner, error in
                        if(owner != nil)
                        {
                            let ownerFirstName = dogOwner["firstname"] as! String
                            let ownerLastName = dogOwner["lastname"] as! String
                            dogProfileViewController.ownerName = ownerFirstName + " " + ownerLastName
                        }
                    }
                    
                }
            }
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
        query_constraint.whereKey("ownerid", contains: user_id)
        query.whereKey("ownerid", doesNotMatchKey: "ownerid", in: query_constraint)
        
        // Constraint to prevent seeing dogs that the user already liked
        query.whereKey("likedBy", notEqualTo: user)
        
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

    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = loginViewController
    }
    
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
            var tempArray = [PFObject]()
            let user = PFUser.current()!
            let query = PFQuery(className: "Dog")
            let dog_name = viewModels[index].dogNameLabel.text!
            let dog_breed = viewModels[index].breedLabel.text!
            query.whereKey("name", equalTo: dog_name)
            query.whereKey("breed", equalTo: dog_breed)
    
            query.findObjectsInBackground { dogs, error in
                tempArray = dogs!
                for dog in tempArray
                {
                    user.addUniqueObject(dog, forKey: "likes")
                    dog.addUniqueObject(user, forKey: "likedBy")
                    user.saveInBackground { user, error in
                        if error == nil
                        {
                            print("Liked successfully!")
                        }
                    }
                }
            }
        case .topRight:
            var tempArray = [PFObject]()
            let user = PFUser.current()!
            let query = PFQuery(className: "Dog")
            let dog_name = viewModels[index].dogNameLabel.text!
            let dog_breed = viewModels[index].breedLabel.text!
            query.whereKey("name", equalTo: dog_name)
            query.whereKey("breed", equalTo: dog_breed)
    
            query.findObjectsInBackground { dogs, error in
                tempArray = dogs!
                for dog in tempArray
                {
                    user.addUniqueObject(dog, forKey: "likes")
                    dog.addUniqueObject(user, forKey: "likedBy")
                    user.saveInBackground { user, error in
                        if error == nil
                        {
                            print("Liked successfully!")
                        }
                    }
                }
            }
        case .bottomRight:
            var tempArray = [PFObject]()
            let user = PFUser.current()!
            let query = PFQuery(className: "Dog")
            let dog_name = viewModels[index].dogNameLabel.text!
            let dog_breed = viewModels[index].breedLabel.text!
            query.whereKey("name", equalTo: dog_name)
            query.whereKey("breed", equalTo: dog_breed)
    
            query.findObjectsInBackground { dogs, error in
                tempArray = dogs!
                for dog in tempArray
                {
                    user.addUniqueObject(dog, forKey: "likes")
                    dog.addUniqueObject(user, forKey: "likedBy")
                    user.saveInBackground { user, error in
                        if error == nil
                        {
                            print("Liked successfully!")
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






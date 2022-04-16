//
//  FeedViewController.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/6/22.
//

import UIKit
import Parse
import AlamofireImage
import SwiftUI
import Koloda

class FeedViewController: UIViewController, UIBarPositioningDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var ownerImageView: UIImageView!
    
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var dogImageView: UIImageView!
    
    let app_color = UIColor(red: 196/255, green: 164/255, blue: 132/255, alpha: 1)
    
    var dogArray = [PFObject]() // Array of dogs to like
    var images = [UIImage]()
    //var viewModels = [SampleSwipeableCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfile()
        navBarUI()
        //swipeableCardView.dataSource = self
        //parse()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.layer.cornerRadius = 20
        kolodaView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dogImageView.layer.cornerRadius = 20
        dogImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        parseImages()
    }
    
    func parseImages()
    {
        let query = PFQuery(className: "Dog")
        query.includeKeys(["name", "breed", "gender", "ownerid", "dog_photo"])
        query.findObjectsInBackground { dogs, error in
            if dogs != nil
            {
                self.dogArray = dogs!
                for dog in self.dogArray
                {
                    let dogImageFile = dog["dog_photo"] as! PFFileObject
                    let urlString = dogImageFile.url!
                    let dog_image_url = URL(string: urlString)!
                    self.dogImageView.af.setImage(withURL: dog_image_url)
                    let data = try? Data(contentsOf: dog_image_url)
                    self.images.append(UIImage(data: data!)!)
                    self.kolodaView.reloadData()
                }
                for image in self.images
                {
                    print(image)
                }
            }
        }
    }
    
    /*func parse()
    {
        let query = PFQuery(className: "Dog")
        query.includeKeys(["name", "breed", "gender", "ownerid"])
        
        // Prevents the user from seeing their own dog in the feed
        let user = PFUser.current()!
        let user_id = user.objectId!
        let query_constraint = PFQuery(className: "Dog")
        query_constraint.includeKey("ownerid")
        query_constraint.whereKey("ownerid", contains: user_id)
        query.whereKey("ownerid", doesNotMatchKey: "ownerid", in: query_constraint)
        
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
                 
                    let card = SampleSwipeableCellViewModel(dog_image: dog_image_url, owner_image: owner_image_url, dog_name: dog_name, breed: breed, gender: genderImage, location: location)
                    self.viewModels.append(card)
                    self.viewModels.shuffle() // Randomize the order of dogs displayed
                    self.swipeableCardView.reloadData()
                }
            }
        }
    }*/

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
}

// MARK: - SwipeableCardViewDataSource

/*extension FeedViewController extension SwipeableCardViewDataSource {
    func numberOfCards() -> Int {
        return viewModels.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard
    {
        let viewModel = viewModels[index]
        let cardView = SampleSwipeableCard()
        cardView.viewModel = viewModel
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
}*/

extension FeedViewController : KolodaViewDelegate{
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
}

extension FeedViewController : KolodaViewDataSource{
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        images.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return kolodaView
    }

}


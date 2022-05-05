//
//  UserProfileViewController.swift
//  Pupple
//
//  Created by Shareena Wiggins on 4/22/22.
//

import UIKit
import Parse
import AlamofireImage

class UserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var dogView: UIView!
    
    @IBOutlet weak var ownerView: UIView!
    
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var dogNameLabel: UILabel!
    
    @IBOutlet weak var dogBreedLabel: UILabel!
    
    @IBOutlet weak var genderIconView: UIImageView!
    
    @IBOutlet weak var dogLocationLabel: UILabel!
    
    @IBOutlet weak var dogSizeLabel: UILabel!
    
    @IBOutlet weak var dogAgeLabel: UILabel!{ didSet {dogAgeLabel.text = "N/A"} }
    
    @IBOutlet weak var dogAboutLabel: UILabel!{ didSet {dogAboutLabel.text = ""} }
    
    @IBOutlet weak var fixedLabel: UILabel!
    
    @IBOutlet weak var vaccinatedLabel: UILabel!
    
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    @IBOutlet weak var ownerImageview: UIImageView!
    
    @IBOutlet weak var ownerGenderLabel: UILabel!{ didSet{ownerGenderLabel.text = "N/A"}}
    
    @IBOutlet weak var ownerAgeLabel: UILabel!{ didSet{ownerAgeLabel.text = "N/A"}}
    
    @IBOutlet weak var ownerOccupationLabel: UILabel!{ didSet{ownerOccupationLabel.text = "N/A"}}
    
    @IBOutlet weak var ownerEducationLabel: UILabel!{ didSet{ownerEducationLabel.text = "N/A"}}
    
    @IBOutlet weak var aboutLabel: UILabel!{ didSet{aboutLabel.text = ""}}
    
    @IBOutlet weak var ownerInstagramButton: UIButton!
    
    @IBOutlet weak var ownerSnapchatButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    var segueName: String? // Used to determine which segue you came from
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        ownerImageview.layer.cornerRadius = 50
        
        userParse()
 
    }
    
    @IBAction func goBackToHome(_ sender: Any) {
        self.dismiss(animated: false, completion: {
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as! UITabBarController
            
            // To determine which view in the tab bar to return to
            switch self.segueName{
            case "profileDetailsLikes":
                tabbarVC.selectedIndex = 0
                
            case "profileDetails":
                tabbarVC.selectedIndex = 1
                
            case "profileDetailsMatches":
                tabbarVC.selectedIndex = 2
                
            default:
                tabbarVC.selectedIndex = 1
            }
        
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
            delegate.window?.rootViewController = tabbarVC
            delegate.window?.makeKeyAndVisible()
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    override func viewWillLayoutSubviews() {
        aboutLabel.sizeToFit()
        dogAboutLabel.sizeToFit()
    }
    
    func userParse(){
        let user = PFUser.current()!
        
        let name = user["firstname"] as! String
        let lastName = user["lastname"] as! String
        let fullName = name + " " + lastName
        let doglocation = user["location"] as! String
        self.ownerNameLabel.text = fullName
        self.dogLocationLabel.text = doglocation
        var about = user["about"] as? String
        if(about == nil){
            about = ""
        }
        aboutLabel.text = about
        
        var insta = user["instagram"] as? String
        if(insta == nil){
            insta = "N/A"
        }
        ownerInstagramButton.setTitle(insta, for: .normal)
        
        var occupation = user["occupation"] as? String
        if(occupation == nil){
            occupation = "N/A"
        }
        ownerOccupationLabel.text = occupation
        
        var education = user["education"] as? String
        if(education == nil){
            education = "N/A"
        }
        ownerEducationLabel.text = education
        
        var snap = user["snapchat"] as? String
        if(snap == nil){
            snap = "N/A"
        }
        ownerSnapchatButton.setTitle(snap, for: .normal)
        
        var gender = user["gender"] as? String
        if(gender == nil){
            gender = "N/A"
        }
        ownerGenderLabel.text = gender
        
        let userImageFile = user["user_photo"] as! PFFileObject
        let fileUrlString = userImageFile.url!
        let fileUrl = URL(string: fileUrlString)
        ownerImageview.af.setImage(withURL: fileUrl!)
        
        // Calculate age
        let birthday = user["birthday"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateFormatter.date(from: birthday)
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateFormatter.date(from: birthday)!, to: now) 
        let age = ageComponents.year!
        let ageString = String(age)
        ownerAgeLabel.text = ageString + " years old"
        
        var dogs = [PFObject]()
        let query = PFQuery(className: "Dog")
        query.whereKey("ownerid", equalTo: user)
        query.findObjectsInBackground { dog , error in
            dogs = dog!
            for ownerDog in dogs {
                let dogName = ownerDog["name"] as! String
                let dogBreed = ownerDog["breed"] as! String
                let dogSize = ownerDog["size"] as! String
                self.dogNameLabel.text = dogName
                self.dogBreedLabel.text = dogBreed
                self.dogSizeLabel.text = dogSize
                
                let file = ownerDog["dog_photo"] as! PFFileObject
                let url = file.url!
                let dogUrl = URL(string: url)
                self.dogImageView.af.setImage(withURL: dogUrl!)
                
                let dogAgeNum = ownerDog["age"] as? Int
                var dogAge: String = "N/A"
                if(dogAgeNum != nil) {dogAge = String(dogAgeNum!) + " years old"}
                
                self.dogAgeLabel.text = dogAge
                
                var dogAbout = ownerDog["about"] as? String
                if(dogAbout == nil){
                    dogAbout = ""
                }
                self.dogAboutLabel.text = dogAbout
                
            }
        }
        
        
    }
    
    
    @IBAction func instagram(_ sender: Any) {
        let instaUrl = URL(string: "https://www.instagram.com/" + (ownerInstagramButton.titleLabel?.text)!)
        UIApplication.shared.open(instaUrl!)
    }
    
    @IBAction func snapchat(_ sender: Any) {
        let snapchatUrl = URL(string: "https://www.snapchat.com/add/" + (ownerSnapchatButton.titleLabel?.text)!)
        UIApplication.shared.open(snapchatUrl!)
    }
    
    @IBAction func unwindToProfile(_send: UIStoryboardSegue){}
    
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = loginViewController
    }
}
    
    
    



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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownerImageview.layer.cornerRadius = 50
        
        userParse()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       userParse()
    }
    
    
    func userParse(){
        let user = PFUser.current()!
        
        let name = user["firstname"] as! String
        let lastName = user["lastname"] as! String
        let fullName = name + " " + lastName
        let doglocation = user["location"] as! String
        self.ownerNameLabel.text = fullName
        self.dogLocationLabel.text = doglocation
        
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
                
            }
        }
        
        
    }
    
    
        
    }
    
    
    


